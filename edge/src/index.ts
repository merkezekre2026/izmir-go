// İzmir Go API on Cloudflare Workers (free plan).
// Same /api/v1 contract as the FastAPI backend (contracts/openapi.json), served from a static
// bundle built by `izmirgo-ingest build-bundle`, plus live ESHOT data and in-Worker routing.
import { Data, type DepRow, type Env, type Manifest, type Notice, type StopSummary } from "./data";
import { planJourneys } from "./journeys";
import {
  API,
  ApiError,
  VERSION,
  addDays,
  dayInt,
  dayIso,
  fileKey,
  floatParam,
  fold,
  haversineM,
  inCoverage,
  intParam,
  isoAt,
  izmirParts,
  json,
  modesParam,
  parseDay,
  parseWhen,
  problem,
  type ServiceDay,
} from "./util";

const LIVE_SOURCES = new Set(["eshot"]);
const SOURCE_LABELS: Record<string, string> = {
  metro: "İzmir Metro",
  tram: "Tram İzmir",
  eshot: "ESHOT otobüs",
  izban: "İZBAN",
  izdeniz: "İZDENİZ vapur",
};

function meta(man: Manifest, onDay?: ServiceDay, extra: Notice[] = []) {
  const notices = [...man.notices];
  if (onDay) {
    const d = dayIso(onDay);
    for (const w of man.sources) {
      if (w.valid_from && w.valid_to && (d < w.valid_from || d > w.valid_to)) {
        const [y, m, dd] = d.split("-");
        notices.push({
          code: "SOURCE_OUT_OF_VALIDITY",
          source: w.source,
          message: `${SOURCE_LABELS[w.source] ?? w.source} tarifesi ${dd}.${m}.${y} için mevcut değil.`,
        });
      }
    }
  }
  return { dataset: man.dataset, generated_at: new Date().toISOString(), sources: man.sources, notices: [...notices, ...extra] };
}

async function staticJson(data: Data, path: string, cacheSeconds: number, notFound?: string): Promise<Response> {
  const res = await data.raw(path);
  if (!res) {
    if (notFound) throw new ApiError("NOT_FOUND", 404, notFound);
    throw new ApiError("NO_ACTIVE_DATASET", 503, "Ulaşım verisi henüz yüklenmedi.");
  }
  return new Response(res.body, {
    headers: { "content-type": "application/json; charset=utf-8", "cache-control": `public, max-age=${cacheSeconds}` },
  });
}

// ---- stops -------------------------------------------------------------------------------
async function searchStops(data: Data, q: string, limit: number, offset: number, modes: string[] | null) {
  const key = fold(q);
  const raw = q.trim();
  const index = await data.searchIndex();
  type Hit = { id: string; rank: number; name: string };
  const hits: Hit[] = [];
  for (const line of index.split("\n")) {
    if (!line) continue;
    const [id, folded, kind, code, rawId] = line.split("\t") as [string, string, string, string, string];
    const exact = raw === code || raw === rawId;
    const prefix = key !== "" && folded.startsWith(key);
    const contains = key !== "" && (folded.includes(` ${key}`) || folded.includes(key));
    if (!exact && !prefix && !contains) continue;
    hits.push({ id, name: folded, rank: (exact ? 0 : 4) + (prefix ? 0 : 2) + (kind === "station" ? 0 : 1) });
  }
  hits.sort((a, b) => a.rank - b.rank || a.name.localeCompare(b.name) || a.id.localeCompare(b.id));
  const out: StopSummary[] = [];
  let skipped = 0;
  for (const h of hits) {
    const s = (await data.summaries(h.id))?.[h.id];
    if (!s || (modes && !s.modes.some((m) => modes.includes(m)))) continue;
    if (skipped < offset) {
      skipped++;
      continue;
    }
    out.push(s);
    if (out.length > limit) break;
  }
  return out;
}

async function nearby(data: Data, lat: number, lon: number, radius: number, modes: string[] | null, limit: number) {
  const span = Math.ceil(radius / 1100) + 1;
  const ty = Math.floor(lat / 0.01);
  const tx = Math.floor(lon / 0.01);
  const keys: string[] = [];
  for (let dy = -span; dy <= span; dy++) for (let dx = -span; dx <= span; dx++) keys.push(`${ty + dy}_${tx + dx}`);
  const tiles = await Promise.all(keys.map((k) => data.tile(k)));
  const found: StopSummary[] = [];
  for (const tile of tiles) {
    for (const s of tile ?? []) {
      if (modes && !s.modes.some((m) => modes.includes(m))) continue;
      const d = Math.round(haversineM(lat, lon, s.lat, s.lon));
      if (d <= radius) found.push({ ...s, distance_m: d });
    }
  }
  found.sort((a, b) => a.distance_m! - b.distance_m! || a.id.localeCompare(b.id));
  return found.slice(0, limit);
}

async function stopDetail(data: Data, id: string) {
  const detail = await data.stopDetail(id);
  if (detail) return detail.stop;
  const dir = await data.directoryStop(id);
  if (!dir) throw new ApiError("NOT_FOUND", 404, `stop ${id} not found`);
  return { ...dir, wheelchair_boarding: null, children: [], routes: [], live_supported: LIVE_SOURCES.has(dir.source) };
}

async function departures(data: Data, url: URL, id: string) {
  const stop = await stopDetail(data, id);
  const man = await data.manifest();
  const when = parseWhen(url.searchParams.get("at")) ?? Date.now();
  const limit = intParam(url, "limit", 20, 1, 50);
  const windowS = intParam(url, "window_min", 180, 10, 720) * 60;
  const routeFilter = url.searchParams.get("route");
  const { day, seconds } = izmirParts(when);
  const ids = stop.kind === "station" ? stop.children.map((c) => c.id) : [id];
  const [services, routes] = await Promise.all([data.services(), data.routeSummaries()]);
  const rows: { stopId: string; row: DepRow; svcDay: ServiceDay; secs: number }[] = [];
  for (const sid of ids) {
    const deps = (await data.departures(sid)) ?? [];
    for (const back of [0, 1]) {
      const svcDay = addDays(day, -back);
      const nowS = seconds + back * 86400;
      const target = dayInt(svcDay);
      for (const row of deps) {
        if (row[0] < nowS || row[0] >= nowS + windowS) continue;
        if (routeFilter && row[1] !== routeFilter) continue;
        if (!services[row[5]]?.includes(target)) continue;
        rows.push({ stopId: sid, row, svcDay, secs: row[0] - back * 86400 });
      }
    }
  }
  rows.sort((a, b) => a.secs - b.secs || a.row[1].localeCompare(b.row[1]) || a.row[2].localeCompare(b.row[2]));
  const items = rows.slice(0, limit).map(({ stopId, row, svcDay }) => {
    const route = routes[row[1]]!;
    return {
      stop_id: stopId,
      route,
      trip_id: row[2],
      headsign: row[3],
      direction_id: row[4],
      service_date: dayIso(svcDay),
      scheduled_departure: isoAt(svcDay, row[0]),
      basis: "scheduled",
      times_approximate: route.times_approximate,
      wheelchair_accessible: row[6],
    };
  });
  const extra: Notice[] = items.some((i) => i.times_approximate)
    ? [{ code: "TIMES_APPROXIMATE", message: "Ara durak saatleri yaklaşıktır." }]
    : [];
  return { stop_id: id, from_time: isoAt(day, seconds), items, meta: meta(man, day, extra) };
}

// ---- live ESHOT --------------------------------------------------------------------------
function decimal(value: unknown): number | null {
  if (typeof value === "number") return value;
  if (typeof value !== "string") return null;
  const n = Number(value.trim().replace(",", "."));
  return Number.isFinite(n) ? n : null;
}

async function approaching(env: Env, data: Data, id: string, ctx: ExecutionContext) {
  const m = /^([a-z][a-z0-9_]{1,15}):(\S+)$/.exec(id);
  if (!m) throw new ApiError("VALIDATION_ERROR", 422, "stop id must be namespaced, e.g. eshot:10005");
  const [, source, raw] = m as unknown as [string, string, string];
  if (!LIVE_SOURCES.has(source) || !/^\d+$/.test(raw)) {
    return {
      stop_id: id,
      supported: false,
      basis: "live",
      fetched_at: null,
      source: null,
      items: [],
      notice: { code: "LIVE_UNAVAILABLE", message: "Bu durak için canlı veri yayımlanmıyor.", source: null },
    };
  }
  const cacheKey = new Request(`https://izmirgo.cache/live/eshot/${raw}`);
  const cached = await caches.default.match(cacheKey);
  let payload: { fetched_at: string; rows: unknown };
  if (cached) {
    payload = (await cached.json()) as typeof payload;
  } else {
    let res: Response | null = null;
    for (let attempt = 0; attempt < 2 && !res; attempt++) {
      try {
        res = await fetch(`${env.IZMIR_OPENAPI_URL}/iztek/duragayaklasanotobusler/${raw}`, {
          headers: { accept: "application/json", "user-agent": "IzmirGo/0.1 (+https://github.com/merkezekre2026/izmir-go)" },
          signal: AbortSignal.timeout(5000),
        });
      } catch {
        res = null;
      }
    }
    if (!res || (res.status !== 200 && res.status !== 204)) {
      throw new ApiError("UPSTREAM_UNAVAILABLE", 503, "Canlı veri alınamadı.");
    }
    const rows = res.status === 204 ? [] : await res.json().catch(() => null);
    if (rows === null) throw new ApiError("UPSTREAM_UNAVAILABLE", 503, "Canlı veri alınamadı.");
    payload = { fetched_at: new Date().toISOString(), rows };
    ctx.waitUntil(
      caches.default.put(cacheKey, new Response(JSON.stringify(payload), { headers: { "cache-control": "max-age=15" } })),
    );
  }
  const routes = await data.routeSummaries();
  const byLine = new Map<string, { id: string; color: string | null }>();
  for (const r of Object.values(routes)) {
    if (r.source === "eshot" && r.short_name && !byLine.has(r.short_name)) byLine.set(r.short_name, { id: r.id, color: r.color });
  }
  const items = (Array.isArray(payload.rows) ? payload.rows : [])
    .filter((x): x is Record<string, unknown> => typeof x === "object" && x !== null)
    .filter((x) => typeof x.KalanDurakSayisi === "number" && x.HatNumarasi !== undefined && x.HatNumarasi !== null)
    .map((x) => {
      let lat = decimal(x.KoorX); // KoorX is latitude (official docs), sent with a decimal comma
      let lon = decimal(x.KoorY);
      if (lat === null || lon === null || !(lat > 36 && lat < 40 && lon > 25 && lon < 29)) lat = lon = null;
      const line = String(x.HatNumarasi);
      return {
        line_number: line,
        line_name: String(x.HatAdi ?? ""),
        route_id: byLine.get(line)?.id ?? null,
        color: byLine.get(line)?.color ?? null,
        direction: typeof x.HattinYonu === "number" ? x.HattinYonu : null,
        remaining_stops: x.KalanDurakSayisi as number,
        lat,
        lon,
        vehicle_id: x.OtobusId === undefined || x.OtobusId === null ? null : String(x.OtobusId),
        wheelchair_accessible: typeof x.EngelliMi === "boolean" ? x.EngelliMi : null,
        bike_rack: typeof x.BisikletAparatliMi === "boolean" ? x.BisikletAparatliMi : null,
      };
    })
    .sort((a, b) => a.remaining_stops - b.remaining_stops || a.line_number.localeCompare(b.line_number));
  return {
    stop_id: id,
    supported: true,
    basis: "live",
    fetched_at: payload.fetched_at,
    source: "ESHOT · İzmir Büyükşehir Belediyesi Açık Veri (CC BY 4.0)",
    items,
    notice: null,
  };
}

// ---- places (catalog + Photon) -----------------------------------------------------------
async function photon(env: Env, path: string, params: Record<string, string>, ctx: ExecutionContext) {
  const url = new URL(`${env.PHOTON_URL}${path}`);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
  const key = new Request(`https://izmirgo.cache/photon${path}?${url.searchParams}`);
  const hit = await caches.default.match(key);
  if (hit) return (await hit.json()) as { features?: unknown[] };
  const res = await fetch(url, { headers: { "user-agent": "IzmirGo/0.1" }, signal: AbortSignal.timeout(4000) });
  if (!res.ok) throw new Error(`photon ${res.status}`);
  const body = (await res.json()) as { features?: unknown[] };
  ctx.waitUntil(caches.default.put(key, new Response(JSON.stringify(body), { headers: { "cache-control": "max-age=86400" } })));
  return body;
}

function photonPlaces(body: { features?: unknown[] }) {
  const out: Record<string, unknown>[] = [];
  for (const f of body.features ?? []) {
    const feat = f as { geometry?: { coordinates?: number[] }; properties?: Record<string, unknown> };
    const c = feat.geometry?.coordinates;
    const p = feat.properties ?? {};
    if (!c || c.length < 2) continue;
    const street = p.street ? `${p.street} ${p.housenumber ?? ""}`.trim() : "";
    const name = (p.name as string) || street;
    if (!name) continue;
    const parts = [street, p.district, p.locality, p.city].filter((x, i, a) => x && a.indexOf(x) === i) as string[];
    out.push({
      id: `photon:${p.osm_type ?? "?"}${p.osm_id ?? ""}`,
      name,
      subtitle: parts.join(", ") || null,
      lat: c[1],
      lon: c[0],
      kind: ["place", "highway", "building"].includes(String(p.osm_key)) || "housenumber" in p ? "address" : "poi",
      provider: "photon",
    });
  }
  return out;
}

// ---- router ------------------------------------------------------------------------------
async function handle(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
  const url = new URL(request.url);
  if (request.method !== "GET" && request.method !== "HEAD") throw new ApiError("VALIDATION_ERROR", 405, "GET only");
  const data = new Data(env, url.origin);
  const path = url.pathname.replace(/\/+$/, "");
  if (!path.startsWith(API)) throw new ApiError("NOT_FOUND", 404);
  const rest = decodeURIComponent(path.slice(API.length));

  if (rest === "/health") return json({ status: "ok", version: VERSION });
  if (rest === "/health/ready") {
    const ok = (await data.get<Manifest>("manifest.json")) !== null;
    return json({ status: ok ? "ready" : "degraded", database: ok, active_dataset: ok, routing: ok ? "ok" : "unavailable" }, 0);
  }
  if (rest === "/transit/status") return staticJson(data, "api/status.json", 60);
  if (rest === "/meta/attributions") return staticJson(data, "api/attributions.json", 86400);
  if (rest === "/catalog/snapshot") {
    const man = await data.manifest();
    const etag = `"${man.dataset.label}"`;
    if (request.headers.get("if-none-match") === etag) return new Response(null, { status: 304, headers: { etag } });
    const res = await staticJson(data, "api/catalog.json", 3600);
    res.headers.set("etag", etag);
    return res;
  }
  if (rest === "/alerts") {
    const all = await data.must<{ items: { route_ids: string[] }[]; generated_at: string }>("api/alerts.json");
    const route = url.searchParams.get("route");
    return json(route ? { ...all, items: all.items.filter((a) => a.route_ids.includes(route)) } : all, 300);
  }
  if (rest === "/routes") {
    const modes = modesParam(url);
    const q = url.searchParams.get("q");
    const list = await data.must<{ items: { mode: string; short_name: string | null; long_name: string | null }[]; meta: unknown }>(
      "api/routes.json",
    );
    if (!modes && !q) return json(list, 3600);
    const key = q ? fold(q) : "";
    return json(
      {
        ...list,
        items: list.items.filter(
          (r) => (!modes || modes.includes(r.mode)) && (!key || fold(`${r.short_name ?? ""} ${r.long_name ?? ""}`).includes(key)),
        ),
      },
      3600,
    );
  }
  let m = /^\/routes\/([^/]+)\/schedule$/.exec(rest);
  if (m) {
    const id = m[1]!;
    const trips = await data.routeTrips(id);
    if (!trips) throw new ApiError("NOT_FOUND", 404, `route ${id} not found`);
    const dateParam = url.searchParams.get("date");
    const day = dateParam ? parseDay(dateParam) : izmirParts(Date.now()).day;
    if (!day) throw new ApiError("VALIDATION_ERROR", 422, "date must be YYYY-MM-DD");
    const direction = url.searchParams.get("direction");
    const services = await data.services();
    const target = dayInt(day);
    const items = trips
      .filter((t) => services[t[3]]?.includes(target) && (direction === null || String(t[1]) === direction))
      .map((t) => ({
        trip_id: t[0],
        direction_id: t[1],
        headsign: t[2],
        first_departure: isoAt(day, t[4]),
        last_arrival: isoAt(day, t[5]),
      }));
    return json({ route_id: id, service_date: dayIso(day), items, meta: meta(await data.manifest(), day) }, 600);
  }
  m = /^\/routes\/([^/]+)$/.exec(rest);
  if (m) return staticJson(data, `api/routes/${fileKey(m[1]!)}.json`, 3600, `route ${m[1]} not found`);

  if (rest === "/stops") {
    const q = url.searchParams.get("q");
    const limit = intParam(url, "limit", 20, 1, 50);
    const offset = Number(url.searchParams.get("cursor") ?? 0) || 0;
    const modes = modesParam(url);
    const man = await data.manifest();
    let items: StopSummary[];
    const bbox = url.searchParams.get("bbox");
    if (q && q.trim()) {
      items = await searchStops(data, q, limit, offset, modes);
    } else if (bbox) {
      const parts = bbox.split(",").map(Number);
      if (parts.length !== 4 || parts.some((x) => !Number.isFinite(x))) throw new ApiError("VALIDATION_ERROR", 422, "bad bbox");
      const [x1, y1, x2, y2] = parts as [number, number, number, number];
      const radius = Math.min(1500, haversineM(y1, x1, y2, x2) / 2);
      items = (await nearby(data, (y1 + y2) / 2, (x1 + x2) / 2, radius, modes, 1000))
        .filter((s) => s.lat >= y1 && s.lat <= y2 && s.lon >= x1 && s.lon <= x2)
        .map(({ distance_m: _d, ...s }) => s)
        .slice(offset, offset + limit + 1);
    } else {
      items = await searchStops(data, "", limit, offset, modes);
    }
    const more = items.length > limit;
    return json({ items: items.slice(0, limit), next_cursor: more ? String(offset + limit) : null, meta: meta(man) }, 300);
  }
  if (rest === "/nearby-stops") {
    const lat = floatParam(url, "lat", -90, 90)!;
    const lon = floatParam(url, "lon", -180, 180)!;
    if (!inCoverage(lat, lon)) throw new ApiError("OUTSIDE_COVERAGE_AREA", 422, "İzmir il sınırları dışında bir konum.");
    const radius = intParam(url, "radius_m", 500, 50, 1500);
    const limit = intParam(url, "limit", 20, 1, 30);
    const items = await nearby(data, lat, lon, radius, modesParam(url), limit);
    return json({ items, meta: meta(await data.manifest()) }, 300);
  }
  m = /^\/stops\/([^/]+)\/departures$/.exec(rest);
  if (m) return json(await departures(data, url, m[1]!), 60);
  m = /^\/stops\/([^/]+)\/approaching-vehicles$/.exec(rest);
  if (m) return json(await approaching(env, data, m[1]!, ctx), 0);
  m = /^\/stops\/([^/]+)$/.exec(rest);
  if (m) return json({ stop: await stopDetail(data, m[1]!), meta: meta(await data.manifest()) }, 3600);

  if (rest === "/journeys") {
    const nowMs = Date.now();
    const { items, routing_errors, day } = await planJourneys(data, url, nowMs);
    return json({ items, routing_errors, meta: meta(await data.manifest(), day) }, 0);
  }
  if (rest === "/places/search") {
    const q = url.searchParams.get("q") ?? "";
    if (q.trim().length < 2) throw new ApiError("VALIDATION_ERROR", 422, "q must have at least 2 characters");
    const limit = intParam(url, "limit", 10, 1, 20);
    const stops = await searchStops(data, q, limit, 0, null);
    const items: Record<string, unknown>[] = stops.slice(0, limit).map((s) => ({
      id: s.id,
      name: s.name,
      subtitle: s.modes.join(", ") || null,
      lat: s.lat,
      lon: s.lon,
      kind: s.kind,
      provider: "catalog",
    }));
    let attribution: string | null = null;
    if (items.length < limit && env.PHOTON_URL) {
      try {
        const params: Record<string, string> = { q, limit: String(limit - items.length), bbox: "26.2,37.8,28.5,39.4" };
        const lat = url.searchParams.get("lat");
        const lon = url.searchParams.get("lon");
        if (lat && lon) Object.assign(params, { lat: Number(lat).toFixed(3), lon: Number(lon).toFixed(3) });
        items.push(...photonPlaces(await photon(env, "/api", params, ctx)));
        attribution = "Adres verisi © OpenStreetMap katkıcıları (Photon)";
      } catch {
        // addresses are best-effort; stops still answer
      }
    }
    return json({ items: items.slice(0, limit), attribution }, 300);
  }
  if (rest === "/places/reverse") {
    const lat = floatParam(url, "lat", -90, 90)!;
    const lon = floatParam(url, "lon", -180, 180)!;
    if (!inCoverage(lat, lon)) throw new ApiError("OUTSIDE_COVERAGE_AREA", 422, "İzmir il sınırları dışında bir konum.");
    try {
      const body = await photon(env, "/reverse", { lat: lat.toFixed(5), lon: lon.toFixed(5), limit: "1" }, ctx);
      return json({ items: photonPlaces(body), attribution: "Adres verisi © OpenStreetMap katkıcıları (Photon)" }, 86400);
    } catch {
      throw new ApiError("UPSTREAM_UNAVAILABLE", 503, "Adres servisine ulaşılamadı.");
    }
  }
  throw new ApiError("NOT_FOUND", 404);
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const path = new URL(request.url).pathname;
    try {
      return await handle(request, env, ctx);
    } catch (err) {
      if (err instanceof ApiError) return problem(err.code, err.status, path, err.detail);
      console.error("unhandled", path, err instanceof Error ? err.stack : String(err));
      return problem("INTERNAL", 500, path);
    }
  },
} satisfies ExportedHandler<Env>;
