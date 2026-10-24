// /api/v1/journeys on the free edge: RAPTOR over the bundled timetable.
// Walking is estimated from straight-line distance (x detour factor) and labelled as such.
import type { Data, Manifest, RouteSummary, Timetable } from "./data";
import { type Access, DAY, type LegPlan, type Plan, Router } from "./raptor";
import {
  ApiError,
  addDays,
  dayInt,
  dayIso,
  haversineM,
  inCoverage,
  isoAt,
  izmirParts,
  type ServiceDay,
} from "./util";

const ACCESS_RADIUS_M = 1000;
const ACCESS_RADIUS_MAX_M = 2000;
const WALK_ONLY_MAX_M = 3000;
const MAX_RUNS = 40;

export interface Endpoint {
  lat: number;
  lon: number;
  stopIds: number[]; // timetable stop indexes when the endpoint is a stop or station
  name: string | null;
  stopId: string | null;
}

let routerCache: { label: string; router: Router; byId: Map<string, number[]> } | null = null;

function routerFor(tt: Timetable, label: string) {
  if (routerCache?.label !== label) {
    const byId = new Map<string, number[]>();
    tt.stops.forEach(([id, , , , parent], i) => {
      byId.set(id, [...(byId.get(id) ?? []), i]);
      if (parent) byId.set(parent, [...(byId.get(parent) ?? []), i]);
    });
    routerCache = { label, router: new Router(tt), byId };
  }
  return routerCache;
}

const COORD = /^\s*(-?\d{1,2}(?:\.\d+)?)\s*,\s*(-?\d{1,3}(?:\.\d+)?)\s*$/;

export async function resolveEndpoint(data: Data, value: string | null, field: string): Promise<Endpoint> {
  if (!value) throw new ApiError("VALIDATION_ERROR", 422, `${field} is required`);
  const m = COORD.exec(value);
  if (m) {
    const lat = Number(m[1]);
    const lon = Number(m[2]);
    if (!inCoverage(lat, lon)) throw new ApiError("OUTSIDE_COVERAGE_AREA", 422, "İzmir il sınırları dışında bir konum.");
    return { lat, lon, stopIds: [], name: null, stopId: null };
  }
  if (/^[a-z][a-z0-9_]{1,15}:\S+$/.test(value)) {
    const tt = await data.timetable();
    const man = await data.manifest();
    const { byId } = routerFor(tt, man.dataset.label);
    const idx = byId.get(value) ?? [];
    const detail = await data.stopDetail(value);
    const dir = detail ? null : await data.directoryStop(value);
    const base = detail?.stop ?? dir;
    if (!base) throw new ApiError("NOT_FOUND", 404, `stop ${value} not found`);
    return { lat: base.lat, lon: base.lon, stopIds: idx, name: base.name, stopId: value };
  }
  throw new ApiError("VALIDATION_ERROR", 422, `${field} must be 'lat,lon' or a stop id like metro:6`);
}

function accessFor(ep: Endpoint, tt: Timetable, man: Manifest): Access[] {
  if (ep.stopIds.length) return ep.stopIds.map((stop) => ({ stop, seconds: 0, meters: 0 }));
  const near = (radius: number) =>
    tt.stops
      .map(([, , lat, lon], stop) => ({ stop, d: haversineM(ep.lat, ep.lon, lat, lon) }))
      .filter((x) => x.d <= radius);
  let list = near(ACCESS_RADIUS_M);
  if (!list.length) list = near(ACCESS_RADIUS_MAX_M);
  return list.map(({ stop, d }) => {
    const meters = Math.round(d * man.detour);
    return { stop, seconds: Math.ceil(meters / man.walk_speed_mps), meters };
  });
}

function activeSets(services: Record<string, number[]>, tt: Timetable, day: ServiceDay): Set<number>[] {
  return [-1, 0, 1].map((n) => {
    const target = dayInt(addDays(day, n));
    const set = new Set<number>();
    tt.services.forEach((sid, i) => {
      if (services[sid]?.includes(target)) set.add(i);
    });
    return set;
  });
}

function hash(text: string): string {
  let h = 0x811c9dc5;
  for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 0x01000193) >>> 0;
  return h.toString(16).padStart(8, "0");
}

interface PlaceOut {
  name: string;
  lat: number;
  lon: number;
  stop_id: string | null;
  station_id: string | null;
}

export async function planJourneys(
  data: Data,
  url: URL,
  nowMs: number,
): Promise<{ items: unknown[]; routing_errors: { code: string; message: string }[]; day: ServiceDay }> {
  const from = await resolveEndpoint(data, url.searchParams.get("from"), "from");
  const to = await resolveEndpoint(data, url.searchParams.get("to"), "to");
  const atRaw = url.searchParams.get("at");
  const when = atRaw ? Date.parse(/([zZ]|[+-]\d{2}:?\d{2})$/.test(atRaw) ? atRaw : `${atRaw}+03:00`) : nowMs;
  if (Number.isNaN(when)) throw new ApiError("VALIDATION_ERROR", 422, "at must be an ISO 8601 datetime");
  const arriveBy = url.searchParams.get("time_type") === "arrive";
  const limitRaw = Number(url.searchParams.get("limit") ?? 3);
  const limit = Number.isInteger(limitRaw) && limitRaw >= 1 && limitRaw <= 5 ? limitRaw : 3;
  const maxTransfersRaw = url.searchParams.get("max_transfers");
  const maxRounds = maxTransfersRaw ? Math.min(5, Math.max(0, Number(maxTransfersRaw))) + 1 : 5;
  const speedName = url.searchParams.get("walk_speed") ?? "normal";
  const speedFactor = speedName === "slow" ? 1.33 / 0.9 : speedName === "fast" ? 1.33 / 1.7 : 1;
  const modesParam = url.searchParams.get("modes");
  const modes = modesParam ? new Set(modesParam.split(",")) : null;

  const [tt, man, services, routes] = await Promise.all([
    data.timetable(),
    data.manifest(),
    data.services(),
    data.routeSummaries(),
  ]);
  const { router } = routerFor(tt, man.dataset.label);
  const { day, seconds } = izmirParts(when);
  const active = activeSets(services, tt, day);
  if (modes) {
    // Drop services of excluded modes by filtering patterns through their route mode.
    // (Cheap: the timetable is small.) Done via a per-request copy of active sets.
    const allowedPatterns = new Set(
      tt.patterns.map((p, i) => [i, routes[p.route]?.mode] as const).filter(([, m]) => m && modes.has(m)).map(([i]) => i),
    );
    if (allowedPatterns.size < tt.patterns.length) {
      const allowedServices = new Set<number>();
      tt.patterns.forEach((p, i) => {
        if (allowedPatterns.has(i)) p.services.forEach((s) => allowedServices.add(s));
      });
      for (const set of active) for (const s of [...set]) if (!allowedServices.has(s)) set.delete(s);
    }
  }

  const errors: { code: string; message: string }[] = [];
  if (active.every((s) => s.size === 0)) {
    errors.push({ code: "OUTSIDE_SERVICE_PERIOD", message: "Seçilen tarih için tarife verisi yok." });
  }

  const scale = (a: Access[]) => a.map((x) => ({ ...x, seconds: Math.ceil(x.seconds * speedFactor) }));
  const access = scale(accessFor(from, tt, man));
  const egressList = scale(accessFor(to, tt, man));
  if (!access.length || !egressList.length) {
    errors.push({ code: "NO_STOPS_IN_RANGE", message: "Yürüme mesafesinde durak bulunamadı." });
  }
  const egress = new Map(egressList.map((e) => [e.stop, e]));

  const plans: Plan[] = [];
  const seen = new Set<string>();
  const sig = (p: Plan) => p.legs.map((l) => (l.kind === "ride" ? `${l.pattern}/${l.trip}/${l.offset}` : l.kind)).join("|");
  if (access.length && egress.size && errors.length === 0) {
    if (!arriveBy) {
      let t = seconds;
      for (let run = 0; run < MAX_RUNS && plans.length < limit; run++) {
        const found = router.run(t, access, egress, active, maxRounds);
        const bestPlan = found.at(-1); // earliest arrival (results improve per round)
        if (!bestPlan) break;
        if (!seen.has(sig(bestPlan))) {
          seen.add(sig(bestPlan));
          plans.push(bestPlan);
        }
        if (bestPlan.firstBoard + 60 <= t) break;
        t = bestPlan.firstBoard + 60;
        if (t > seconds + 6 * 3600) break;
      }
    } else {
      // Latest departures that still arrive by the deadline.
      let t = seconds - 4 * 3600;
      const candidates: Plan[] = [];
      for (let run = 0; run < MAX_RUNS; run++) {
        const found = router.run(t, access, egress, active, maxRounds);
        const bestPlan = found.at(-1);
        if (!bestPlan || bestPlan.arrival > seconds) break;
        if (!seen.has(sig(bestPlan))) {
          seen.add(sig(bestPlan));
          candidates.push(bestPlan);
        }
        if (bestPlan.firstBoard + 60 <= t) break;
        t = bestPlan.firstBoard + 60;
      }
      plans.push(...candidates.slice(-limit).reverse());
    }
    if (!plans.length) {
      errors.push({ code: "NO_TRANSIT_CONNECTION_IN_SEARCH_WINDOW", message: "Seçilen saat aralığında uygun sefer bulunamadı." });
    }
  }

  const place = (stop: number): PlaceOut => {
    const [id, name, lat, lon, parent] = tt.stops[stop]!;
    return { name, lat, lon, stop_id: id, station_id: parent };
  };
  const endpointPlace = (ep: Endpoint, fallback: string): PlaceOut => ({
    name: ep.name ?? fallback,
    lat: ep.lat,
    lon: ep.lon,
    stop_id: ep.stopId,
    station_id: null,
  });

  const items: unknown[] = plans.map((p) => toJourney(p, tt, routes, router, day, from, to, place, endpointPlace));

  // Walking the whole way, when it is short enough to be a real alternative.
  const direct = haversineM(from.lat, from.lon, to.lat, to.lon) * man.detour;
  if (direct <= WALK_ONLY_MAX_M && !(from.stopId && from.stopId === to.stopId)) {
    const secs = Math.ceil((direct / man.walk_speed_mps) * speedFactor);
    const start = arriveBy ? seconds - secs : seconds;
    const leg = walkLeg(endpointPlace(from, "Başlangıç"), endpointPlace(to, "Varış"), day, start, start + secs, Math.round(direct), false, null);
    items.push({
      id: `j_${hash(`walk|${start}|${from.lat},${from.lon}|${to.lat},${to.lon}`)}`,
      start: isoAt(day, start),
      end: isoAt(day, start + secs),
      duration_s: secs,
      transfers: 0,
      walk_distance_m: Math.round(direct),
      modes: ["walk"],
      legs: [leg],
      basis: "scheduled",
    });
  }
  return { items, routing_errors: errors, day };
}

function walkLeg(
  origin: PlaceOut,
  destination: PlaceOut,
  day: ServiceDay,
  dep: number,
  arr: number,
  meters: number,
  isTransfer: boolean,
  transferSource: "curated" | "computed" | null,
) {
  return {
    mode: "walk",
    start: isoAt(day, dep),
    end: isoAt(day, arr),
    duration_s: Math.max(0, Math.round(arr - dep)),
    distance_m: meters,
    origin,
    destination,
    route: null,
    trip_id: null,
    headsign: null,
    service_date: null,
    intermediate_stops: [],
    geometry: [
      [origin.lon, origin.lat],
      [destination.lon, destination.lat],
    ],
    geometry_basis: "straight_line",
    is_transfer: isTransfer,
    transfer_source: transferSource,
    basis: "scheduled",
    times_approximate: false,
  };
}

function toJourney(
  plan: Plan,
  tt: Timetable,
  routes: Record<string, RouteSummary>,
  router: Router,
  day: ServiceDay,
  from: Endpoint,
  to: Endpoint,
  place: (stop: number) => PlaceOut,
  endpointPlace: (ep: Endpoint, fallback: string) => PlaceOut,
) {
  const legs: Record<string, unknown>[] = [];
  let walk = 0;
  const rideCount = plan.legs.filter((l) => l.kind === "ride").length;
  let ridesSeen = 0;
  for (const l of plan.legs as LegPlan[]) {
    if (l.kind === "access") {
      walk += l.meters;
      legs.push(walkLeg(endpointPlace(from, "Başlangıç"), place(l.to), day, l.dep, l.arr, l.meters, false, null));
    } else if (l.kind === "egress") {
      walk += l.meters;
      legs.push(walkLeg(place(l.from), endpointPlace(to, "Varış"), day, l.dep, l.arr, l.meters, false, null));
    } else if (l.kind === "walk") {
      walk += l.meters;
      const transfer = ridesSeen > 0 && ridesSeen < rideCount;
      legs.push(
        walkLeg(place(l.from), place(l.to), day, l.dep, l.arr, l.meters, transfer, transfer ? (l.curated ? "curated" : "computed") : null),
      );
    } else {
      ridesSeen += 1;
      const p = tt.patterns[l.pattern]!;
      const route = routes[p.route] ?? null;
      const dep = router.depOf(l.pattern, l.trip, l.boardPos) + l.offset;
      const arr = router.arrOf(l.pattern, l.trip, l.alightPos) + l.offset;
      const stops = p.stops.slice(l.boardPos, l.alightPos + 1);
      let meters = 0;
      for (let i = 1; i < stops.length; i++) {
        const a = tt.stops[stops[i - 1]!]!;
        const b = tt.stops[stops[i]!]!;
        meters += haversineM(a[2], a[3], b[2], b[3]);
      }
      const serviceDay = addDays(day, Math.round(l.offset / DAY));
      legs.push({
        mode: route?.mode ?? "other",
        start: isoAt(day, dep),
        end: isoAt(day, arr),
        duration_s: arr - dep,
        distance_m: Math.round(meters),
        origin: place(stops[0]!),
        destination: place(stops.at(-1)!),
        route,
        trip_id: p.trips[l.trip],
        headsign: p.headsigns[l.trip] ?? null,
        service_date: dayIso(serviceDay),
        intermediate_stops: stops.slice(1, -1).map((s, i) => {
          const [id, name, lat, lon] = tt.stops[s]!;
          return {
            stop_id: id,
            name,
            lat,
            lon,
            scheduled_departure: isoAt(day, router.depOf(l.pattern, l.trip, l.boardPos + 1 + i) + l.offset),
          };
        }),
        geometry: stops.map((s) => [tt.stops[s]![3], tt.stops[s]![2]]),
        geometry_basis: "stop_to_stop",
        is_transfer: false,
        transfer_source: null,
        basis: "scheduled",
        times_approximate: route?.times_approximate ?? false,
      });
    }
  }
  const modes = [...new Set(legs.map((l) => l.mode as string))];
  const sig = legs.map((l) => `${l.mode}:${l.trip_id ?? ""}:${l.start}`).join("|");
  return {
    id: `j_${hash(sig)}`,
    start: isoAt(day, plan.departure),
    end: isoAt(day, plan.arrival),
    duration_s: Math.round(plan.arrival - plan.departure),
    transfers: plan.transfers,
    walk_distance_m: Math.round(walk),
    modes,
    legs,
    basis: "scheduled",
  };
}
