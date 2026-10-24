// Round-based public transit routing (RAPTOR, Delling et al. 2012) over the bundled timetable.
// Times are seconds relative to local midnight of the query's service day D. Trips of D-1 and
// D+1 are included with a -/+86400 s offset so after-midnight service is handled.
import type { Timetable } from "./data";

const INF = Number.POSITIVE_INFINITY;
export const DAY = 86400;
/** Extra time when changing vehicles at the same stop (OTP's default transfer slack is 1 min). */
const SAME_STOP_SLACK = 60;

export interface Access {
  stop: number;
  seconds: number;
  meters: number;
}

interface RideLabel {
  kind: "ride";
  pattern: number;
  trip: number;
  offset: number;
  boardPos: number;
  alightPos: number;
}
interface WalkLabel {
  kind: "walk";
  from: number;
  seconds: number;
  meters: number;
  curated: boolean;
}
interface AccessLabel {
  kind: "access";
  seconds: number;
  meters: number;
}
type Label = RideLabel | WalkLabel | AccessLabel;

export type LegPlan =
  | { kind: "ride"; pattern: number; trip: number; offset: number; boardPos: number; alightPos: number }
  | { kind: "walk"; from: number; to: number; dep: number; arr: number; meters: number; curated: boolean }
  | { kind: "access"; to: number; dep: number; arr: number; meters: number }
  | { kind: "egress"; from: number; dep: number; arr: number; meters: number };

export interface Plan {
  departure: number;
  arrival: number;
  transfers: number;
  legs: LegPlan[];
  firstBoard: number;
}

export class Router {
  private readonly routesAt: [number, number][][];
  private readonly walksFrom: [number, number, number, number][][];
  private readonly nStops: number;

  constructor(private readonly tt: Timetable) {
    this.nStops = tt.stops.length;
    this.routesAt = Array.from({ length: this.nStops }, () => []);
    tt.patterns.forEach((p, pi) => p.stops.forEach((s, pos) => this.routesAt[s]!.push([pi, pos])));
    this.walksFrom = Array.from({ length: this.nStops }, () => []);
    for (const [a, b, secs, meters, curated] of tt.footpaths) this.walksFrom[a]!.push([b, secs, meters, curated]);
  }

  private arr(p: Timetable["patterns"][number], trip: number, pos: number): number {
    return p.times[(trip * p.stops.length + pos) * 2]!;
  }
  private dep(p: Timetable["patterns"][number], trip: number, pos: number): number {
    return p.times[(trip * p.stops.length + pos) * 2 + 1]!;
  }

  /** Earliest (trip, offset) of pattern `pi` departing position `pos` at or after `t`. */
  private earliestTrip(pi: number, pos: number, t: number, active: Set<number>[]): [number, number] | null {
    const p = this.tt.patterns[pi]!;
    let best: [number, number] | null = null;
    let bestDep = INF;
    for (let day = 0; day < 3; day++) {
      const offset = (day - 1) * DAY;
      const svc = active[day]!;
      for (let j = 0; j < p.trips.length; j++) {
        if (!svc.has(p.services[j]!)) continue;
        const d = this.dep(p, j, pos) + offset;
        if (d >= t) {
          if (d < bestDep) {
            bestDep = d;
            best = [j, offset];
          }
          break; // trips are FIFO within a pattern
        }
      }
    }
    return best;
  }

  /**
   * One RAPTOR query.
   * @param active service sets for [D-1, D, D+1]
   */
  run(t0: number, access: Access[], egress: Map<number, Access>, active: Set<number>[], maxRounds: number): Plan[] {
    const n = this.nStops;
    const best = new Float64Array(n).fill(INF);
    const tau: Float64Array[] = [];
    const labels: (Label | undefined)[][] = [];
    let marked = new Set<number>();

    tau.push(new Float64Array(n).fill(INF));
    labels.push(new Array<Label | undefined>(n));
    for (const a of access) {
      const t = t0 + a.seconds;
      if (t < tau[0]![a.stop]!) {
        tau[0]![a.stop] = t;
        best[a.stop] = t;
        labels[0]![a.stop] = { kind: "access", seconds: a.seconds, meters: a.meters };
        marked.add(a.stop);
      }
    }

    let bestTarget = INF;
    const targetAt = (k: number): [number, number] => {
      let arrival = INF;
      let stop = -1;
      for (const [s, e] of egress) {
        const t = tau[k]![s]! + e.seconds;
        if (t < arrival) {
          arrival = t;
          stop = s;
        }
      }
      return [arrival, stop];
    };

    const results: { k: number; arrival: number; stop: number }[] = [];
    for (let k = 1; k <= maxRounds && marked.size > 0; k++) {
      const prev = tau[k - 1]!;
      const cur = new Float64Array(prev);
      tau.push(cur);
      labels.push(new Array<Label | undefined>(n));
      const lab = labels[k]!;

      // Patterns to scan, from the earliest marked position.
      const queue = new Map<number, number>();
      for (const s of marked) {
        for (const [pi, pos] of this.routesAt[s]!) {
          const q = queue.get(pi);
          if (q === undefined || pos < q) queue.set(pi, pos);
        }
      }
      const newly = new Set<number>();
      for (const [pi, startPos] of queue) {
        const p = this.tt.patterns[pi]!;
        let trip = -1;
        let offset = 0;
        let boardPos = -1;
        for (let pos = startPos; pos < p.stops.length; pos++) {
          const s = p.stops[pos]!;
          if (trip >= 0) {
            const a = this.arr(p, trip, pos) + offset;
            if (a < Math.min(best[s]!, bestTarget)) {
              cur[s] = a;
              best[s] = a;
              lab[s] = { kind: "ride", pattern: pi, trip, offset, boardPos, alightPos: pos };
              newly.add(s);
            }
          }
          const ready = prev[s]!;
          if (ready === INF) continue;
          const prevLabel = labels[k - 1]![s];
          const slack = prevLabel?.kind === "ride" ? SAME_STOP_SLACK : 0;
          if (trip < 0 || ready + slack <= this.dep(p, trip, pos) + offset) {
            const found = this.earliestTrip(pi, pos, ready + slack, active);
            if (found && (trip < 0 || found[0] !== trip || found[1] !== offset)) {
              const cand = this.dep(p, found[0], pos) + found[1];
              if (trip < 0 || cand < this.dep(p, trip, pos) + offset) {
                [trip, offset] = found;
                boardPos = pos;
              }
            }
          }
        }
      }
      // Footpaths (not chained).
      for (const s of [...newly]) {
        for (const [u, secs, meters, curated] of this.walksFrom[s]!) {
          const t = cur[s]! + secs;
          if (t < Math.min(best[u]!, bestTarget)) {
            cur[u] = t;
            best[u] = t;
            lab[u] = { kind: "walk", from: s, seconds: secs, meters, curated: curated === 1 };
            newly.add(u);
          }
        }
      }
      marked = newly;
      const [arrival, stop] = targetAt(k);
      if (stop >= 0 && arrival < bestTarget) {
        bestTarget = arrival;
        results.push({ k, arrival, stop });
      }
    }

    return results.map((r) => this.reconstruct(r.k, r.stop, r.arrival, tau, labels, egress));
  }

  private reconstruct(
    kTarget: number,
    stop: number,
    arrival: number,
    tau: Float64Array[],
    labels: (Label | undefined)[][],
    egress: Map<number, Access>,
  ): Plan {
    const legs: LegPlan[] = [];
    const e = egress.get(stop)!;
    if (e.seconds > 0) legs.push({ kind: "egress", from: stop, dep: tau[kTarget]![stop]!, arr: arrival, meters: e.meters });
    let k = kTarget;
    let s = stop;
    let rides = 0;
    let firstBoard = 0;
    for (let guard = 0; guard < 50; guard++) {
      const l = labels[k]![s];
      if (!l) {
        // Value carried over from an earlier round.
        k -= 1;
        if (k < 0) break;
        continue;
      }
      if (l.kind === "access") {
        if (l.seconds > 0) legs.push({ kind: "access", to: s, dep: tau[0]![s]! - l.seconds, arr: tau[0]![s]!, meters: l.meters });
        break;
      }
      if (l.kind === "walk") {
        legs.push({ kind: "walk", from: l.from, to: s, dep: tau[k]![s]! - l.seconds, arr: tau[k]![s]!, meters: l.meters, curated: l.curated });
        s = l.from;
        continue;
      }
      legs.push({ ...l });
      rides += 1;
      const p = this.tt.patterns[l.pattern]!;
      firstBoard = this.dep(p, l.trip, l.boardPos) + l.offset;
      s = p.stops[l.boardPos]!;
      k -= 1;
    }
    legs.reverse();
    const first = legs[0];
    const departure =
      first?.kind === "access" ? first.dep : first?.kind === "ride" ? firstBoard : arrival;
    return { departure, arrival, transfers: Math.max(0, rides - 1), legs, firstBoard };
  }

  depOf(pattern: number, trip: number, pos: number): number {
    return this.dep(this.tt.patterns[pattern]!, trip, pos);
  }
  arrOf(pattern: number, trip: number, pos: number): number {
    return this.arr(this.tt.patterns[pattern]!, trip, pos);
  }
}
