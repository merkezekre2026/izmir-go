// Shared helpers. fileKey/bucket/fold mirror backend/src/izmirgo (edge/bundle.py, search_text.py).

export const API = "/api/v1";
export const VERSION = "0.1.0-edge";

/** Filesystem/URL-safe name for an id (mirrors bundle.file_key). */
export function fileKey(value: string): string {
  return value.replace(/[^A-Za-z0-9_-]/g, (c) => `~${c.charCodeAt(0).toString(16)}`);
}

/** Stable 0..63 bucket for an id: FNV-1a over UTF-8 (mirrors bundle._bucket). */
export function bucket(id: string): number {
  let h = 0x811c9dc5;
  for (const b of new TextEncoder().encode(id)) {
    h ^= b;
    h = Math.imul(h, 0x01000193) >>> 0;
  }
  return h % 64;
}

const UPPER: Record<string, string> = { I: "ı", "İ": "i" };
const FOLD: Record<string, string> = { ç: "c", ğ: "g", ı: "i", ö: "o", ş: "s", ü: "u", â: "a", î: "i", û: "u" };

/** Turkish-aware ASCII search key ("HALKAPINAR" -> "halkapinar"). */
export function fold(text: string): string {
  let out = "";
  for (const ch of text) {
    const lower = UPPER[ch] ?? ch.toLowerCase();
    for (const c of lower) out += FOLD[c] ?? c;
  }
  return out.normalize("NFKD").replace(/[̀-ͯ]/g, "").replace(/[^a-z0-9]+/g, " ").trim();
}

export function haversineM(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const r = 6371008.8;
  const p1 = (lat1 * Math.PI) / 180;
  const p2 = (lat2 * Math.PI) / 180;
  const dp = p2 - p1;
  const dl = ((lon2 - lon1) * Math.PI) / 180;
  const h = Math.sin(dp / 2) ** 2 + Math.cos(p1) * Math.cos(p2) * Math.sin(dl / 2) ** 2;
  return 2 * r * Math.asin(Math.sqrt(h));
}

export const COVERAGE = { lonMin: 26.2, latMin: 37.8, lonMax: 28.5, latMax: 39.4 };
export function inCoverage(lat: number, lon: number): boolean {
  return lat >= COVERAGE.latMin && lat <= COVERAGE.latMax && lon >= COVERAGE.lonMin && lon <= COVERAGE.lonMax;
}

// ---- İzmir time --------------------------------------------------------------------------
// Europe/Istanbul is UTC+3 all year (no DST since 2016). GTFS service days start at local
// midnight (noon minus 12h equals midnight without DST).
const OFFSET_MS = 3 * 3600 * 1000;

export interface ServiceDay {
  y: number;
  m: number;
  d: number;
}

/** Local wall-clock parts of an instant in İzmir. */
export function izmirParts(epochMs: number): { day: ServiceDay; seconds: number } {
  const t = new Date(epochMs + OFFSET_MS);
  return {
    day: { y: t.getUTCFullYear(), m: t.getUTCMonth() + 1, d: t.getUTCDate() },
    seconds: t.getUTCHours() * 3600 + t.getUTCMinutes() * 60 + t.getUTCSeconds(),
  };
}

export function addDays(day: ServiceDay, n: number): ServiceDay {
  const t = new Date(Date.UTC(day.y, day.m - 1, day.d + n));
  return { y: t.getUTCFullYear(), m: t.getUTCMonth() + 1, d: t.getUTCDate() };
}

export const dayInt = (day: ServiceDay): number => day.y * 10000 + day.m * 100 + day.d;
const p2 = (n: number): string => String(n).padStart(2, "0");
export const dayIso = (day: ServiceDay): string => `${day.y}-${p2(day.m)}-${p2(day.d)}`;

/** ISO string with +03:00 for `seconds` after local midnight of `day` (may exceed 24h). */
export function isoAt(day: ServiceDay, seconds: number): string {
  const t = new Date(Date.UTC(day.y, day.m - 1, day.d) + seconds * 1000);
  return `${t.getUTCFullYear()}-${p2(t.getUTCMonth() + 1)}-${p2(t.getUTCDate())}T${p2(t.getUTCHours())}:${p2(
    t.getUTCMinutes(),
  )}:${p2(t.getUTCSeconds())}+03:00`;
}

/** Parse an ISO datetime query parameter; naive values are İzmir local time. */
export function parseWhen(value: string | null): number | null {
  if (!value) return null;
  const hasZone = /([zZ]|[+-]\d{2}:?\d{2})$/.test(value);
  const ms = Date.parse(hasZone ? value : `${value}+03:00`);
  return Number.isNaN(ms) ? null : ms;
}

export function parseDay(value: string): ServiceDay | null {
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
  if (!m) return null;
  return { y: Number(m[1]), m: Number(m[2]), d: Number(m[3]) };
}

// ---- responses ---------------------------------------------------------------------------
const TITLES: Record<string, string> = {
  VALIDATION_ERROR: "Geçersiz istek",
  NOT_FOUND: "Bulunamadı",
  OUTSIDE_COVERAGE_AREA: "Konum hizmet alanı dışında",
  NO_ACTIVE_DATASET: "Ulaşım verisi henüz yüklenmedi",
  ROUTING_UNAVAILABLE: "Rota planlama şu anda kullanılamıyor",
  UPSTREAM_UNAVAILABLE: "Kaynak veri servisine ulaşılamıyor",
  INTERNAL: "Beklenmeyen bir hata oluştu",
};

export class ApiError extends Error {
  constructor(
    readonly code: string,
    readonly status: number,
    readonly detail?: string,
  ) {
    super(detail ?? code);
  }
}

export function problem(code: string, status: number, path: string, detail?: string): Response {
  const body: Record<string, unknown> = {
    type: `https://izmirgo.app/problems/${code.toLowerCase().replaceAll("_", "-")}`,
    title: TITLES[code] ?? code,
    status,
    code,
    instance: path,
  };
  if (detail) body.detail = detail;
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/problem+json", "cache-control": "no-store" },
  });
}

export function json(body: unknown, cacheSeconds = 0, extra: Record<string, string> = {}): Response {
  return new Response(JSON.stringify(body), {
    headers: {
      "content-type": "application/json; charset=utf-8",
      "cache-control": cacheSeconds > 0 ? `public, max-age=${cacheSeconds}` : "no-store",
      ...extra,
    },
  });
}

export function intParam(url: URL, name: string, def: number, min: number, max: number): number {
  const raw = url.searchParams.get(name);
  if (raw === null || raw === "") return def;
  const n = Number(raw);
  if (!Number.isInteger(n) || n < min || n > max) {
    throw new ApiError("VALIDATION_ERROR", 422, `${name} must be an integer between ${min} and ${max}`);
  }
  return n;
}

export function floatParam(url: URL, name: string, min: number, max: number, required = true): number | null {
  const raw = url.searchParams.get(name);
  if (raw === null || raw === "") {
    if (required) throw new ApiError("VALIDATION_ERROR", 422, `${name} is required`);
    return null;
  }
  const n = Number(raw);
  if (!Number.isFinite(n) || n < min || n > max) {
    throw new ApiError("VALIDATION_ERROR", 422, `${name} must be a number between ${min} and ${max}`);
  }
  return n;
}

const MODES = new Set(["bus", "metro", "tram", "rail", "ferry"]);
export function modesParam(url: URL): string[] | null {
  const raw = url.searchParams.get("modes");
  if (!raw) return null;
  const modes = raw.split(",").map((m) => m.trim()).filter(Boolean);
  const bad = modes.filter((m) => !MODES.has(m));
  if (bad.length) throw new ApiError("VALIDATION_ERROR", 422, `unknown modes: ${bad.join(", ")}`);
  return modes;
}
