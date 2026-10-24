// Access to the static bundle (public/data) with a per-isolate cache of parsed files.
import { ApiError, bucket, fileKey } from "./util";

export interface Env {
  ASSETS: Fetcher;
  IZMIR_OPENAPI_URL: string;
  PHOTON_URL: string;
}

export interface Notice {
  code: string;
  message: string;
  source?: string | null;
}
export interface SourceWindow {
  source: string;
  valid_from: string | null;
  valid_to: string | null;
}
export interface Manifest {
  dataset: { id: number; label: string; published_at: string };
  generated_at: string;
  sources: SourceWindow[];
  notices: Notice[];
  approximate_sources: string[];
  walk_speed_mps: number;
  detour: number;
}
export type Mode = "bus" | "metro" | "tram" | "rail" | "ferry" | "other";
export interface RouteSummary {
  id: string;
  line_key: string;
  short_name: string | null;
  long_name: string | null;
  mode: Mode;
  color: string | null;
  text_color: string | null;
  source: string;
  times_approximate: boolean;
}
export interface StopSummary {
  id: string;
  name: string;
  code: string | null;
  lat: number;
  lon: number;
  modes: Mode[];
  kind: "stop" | "station";
  parent_station: string | null;
  source: string;
  has_schedule: boolean;
  lines: string[];
  distance_m?: number;
}
export interface StopDetail extends StopSummary {
  wheelchair_boarding: number | null;
  children: StopSummary[];
  routes: RouteSummary[];
  live_supported: boolean;
}
/** [dep_s, route_id, trip_id, headsign, direction_id, service_id, wheelchair] */
export type DepRow = [number, string, string, string | null, number | null, string, number | null];
/** [trip_id, direction_id, headsign, service_id, first_s, last_s] */
export type TripRow = [string, number | null, string | null, string, number, number];

export interface Timetable {
  stops: [string, string, number, number, string | null][];
  services: string[];
  patterns: {
    route: string;
    stops: number[];
    trips: string[];
    headsigns: (string | null)[];
    services: number[];
    times: number[];
  }[];
  footpaths: [number, number, number, number, number][];
}

const cache = new Map<string, unknown>();

export class Data {
  constructor(private readonly env: Env, private readonly origin: string) {}

  async raw(path: string): Promise<Response | null> {
    const res = await this.env.ASSETS.fetch(new Request(`${this.origin}/data/${path}`));
    return res.ok ? res : null;
  }

  async get<T>(path: string): Promise<T | null> {
    if (cache.has(path)) return cache.get(path) as T;
    const res = await this.raw(path);
    if (!res) return null;
    const value = path.endsWith(".json") ? ((await res.json()) as T) : ((await res.text()) as T);
    if (cache.size > 400) cache.clear();
    cache.set(path, value);
    return value;
  }

  async must<T>(path: string): Promise<T> {
    const v = await this.get<T>(path);
    if (v === null) throw new ApiError("NO_ACTIVE_DATASET", 503, "Ulaşım verisi henüz yüklenmedi.");
    return v;
  }

  manifest = () => this.must<Manifest>("manifest.json");
  services = () => this.must<Record<string, number[]>>("services.json");
  routeSummaries = () => this.must<Record<string, RouteSummary>>("route_summaries.json");
  timetable = () => this.must<Timetable>("timetable.json");
  searchIndex = () => this.must<string>("search.tsv");

  stopDetail(id: string) {
    return this.get<{ stop: StopDetail }>(`api/stops/${fileKey(id)}.json`);
  }
  departures(id: string) {
    return this.get<DepRow[]>(`departures/${fileKey(id)}.json`);
  }
  routeTrips(id: string) {
    return this.get<TripRow[]>(`route_trips/${fileKey(id)}.json`);
  }
  tile(key: string) {
    return this.get<StopSummary[]>(`tiles/${key}.json`);
  }
  summaries(id: string) {
    return this.get<Record<string, StopSummary>>(`summaries/${bucket(id)}.json`);
  }
  async directoryStop(id: string): Promise<StopSummary | null> {
    const m = /^eshot:(\d+)$/.exec(id);
    if (!m) return null;
    const items = await this.get<StopSummary[]>(`dir/${Math.floor(Number(m[1]) / 100)}.json`);
    return items?.find((s) => s.id === id) ?? null;
  }
}
