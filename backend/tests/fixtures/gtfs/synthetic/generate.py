"""Generate the SYNTHETIC fixture feeds used by tests.

These feeds are invented test data, NOT real timetables. Stop coordinates are placed on real
street locations around Halkapınar so walking transfers can be tested against a real OSM clip;
names are prefixed "Fixture" so they can never be confused with production data.

Run: python tests/fixtures/gtfs/synthetic/generate.py   (outputs are committed)
"""

from __future__ import annotations

import csv
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
NOTE = "SYNTHETIC TEST DATA - not a real timetable"


def write(feed: str, name: str, header: list[str], rows: list[list[object]]) -> None:
    d = HERE / feed
    d.mkdir(parents=True, exist_ok=True)
    with (d / name).open("w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh, lineterminator="\n")
        w.writerow(header)
        w.writerows(rows)


def hms(seconds: int) -> str:
    h, rem = divmod(seconds, 3600)
    m, s = divmod(rem, 60)
    return f"{h:02d}:{m:02d}:{s:02d}"


def line_trips(
    prefix: str,
    route_id: str,
    service_id: str,
    stops: list[str],
    first: int,
    last: int,
    headway: int,
    hop: int,
) -> tuple[list[list[object]], list[list[object]]]:
    trips: list[list[object]] = []
    stop_times: list[list[object]] = []
    for direction, seq_stops in ((0, stops), (1, list(reversed(stops)))):
        for n, dep in enumerate(range(first, last + 1, headway), start=1):
            trip_id = f"{prefix}_{service_id}_{direction}_{n:03d}"
            trips.append([route_id, service_id, trip_id, f"Fixture {seq_stops[-1]}", direction])
            for i, sid in enumerate(seq_stops):
                t = hms(dep + i * hop)
                stop_times.append([trip_id, t, t, sid, i + 1])
    return trips, stop_times


def agency(feed: str, agency_id: str, name: str) -> None:
    write(
        feed,
        "agency.txt",
        ["agency_id", "agency_name", "agency_url", "agency_timezone", "agency_lang"],
        [[agency_id, f"{name} ({NOTE})", "https://example.invalid/", "Europe/Istanbul", "tr"]],
    )


def gen_metro() -> None:
    f = "fx_metro"
    agency(f, "FXM", "Fixture Metro")
    write(
        f,
        "stops.txt",
        ["stop_id", "stop_name", "stop_lat", "stop_lon", "location_type"],
        [
            ["FXM1", "Fixture Stadyum", "38.442500", "27.180800", 0],
            ["FXM2", "Fixture Halkapınar Metro", "38.435000", "27.168600", 0],
            ["FXM3", "Fixture Hilal", "38.427500", "27.156400", 0],
        ],
    )
    write(
        f,
        "routes.txt",
        [
            "route_id",
            "agency_id",
            "route_short_name",
            "route_long_name",
            "route_type",
            "route_color",
            "route_text_color",
        ],
        [["FX1", "FXM", "FM1", "Fixture Stadyum – Fixture Hilal", 1, "0038EF", "FFFFFF"]],
    )
    write(
        f,
        "calendar.txt",
        [
            "service_id",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
            "sunday",
            "start_date",
            "end_date",
        ],
        [
            ["WD", 1, 1, 1, 1, 1, 0, 0, "20260101", "20271231"],
            ["WE", 0, 0, 0, 0, 0, 1, 1, "20260101", "20271231"],
        ],
    )
    write(
        f,
        "calendar_dates.txt",
        ["service_id", "date", "exception_type"],
        [["WD", "20261029", 2], ["WE", "20261029", 1]],
    )
    trips, st = line_trips(
        "FXM", "FX1", "WD", ["FXM1", "FXM2", "FXM3"], 6 * 3600, 24 * 3600 + 20 * 60, 600, 150
    )
    t2, st2 = line_trips(
        "FXM", "FX1", "WE", ["FXM1", "FXM2", "FXM3"], 7 * 3600, 24 * 3600, 1200, 150
    )
    write(
        f,
        "trips.txt",
        ["route_id", "service_id", "trip_id", "trip_headsign", "direction_id"],
        trips + t2,
    )
    write(
        f,
        "stop_times.txt",
        ["trip_id", "arrival_time", "departure_time", "stop_id", "stop_sequence"],
        st + st2,
    )


def gen_tram() -> None:
    f = "fx_tram"
    agency(f, "FXT", "Fixture Tram")
    stops = [
        ["FXT1", "Fixture Halkapınar Tram", "38.433952", "27.171507", 0],
        ["FXT2", "Fixture Havagazı", "38.439858", "27.158134", 0],
        ["FXT3", "Fixture Alsancak Gar", "38.439586", "27.148271", 0],
    ]
    write(f, "stops.txt", ["stop_id", "stop_name", "stop_lat", "stop_lon", "location_type"], stops)
    write(
        f,
        "routes.txt",
        [
            "route_id",
            "agency_id",
            "route_short_name",
            "route_long_name",
            "route_type",
            "route_color",
            "route_text_color",
        ],
        [["FXK", "FXT", "", "Fixture Konak Tramvayı", 0, "AD1457", "FFFFFF"]],
    )
    write(
        f,
        "calendar.txt",
        [
            "service_id",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
            "sunday",
            "start_date",
            "end_date",
        ],
        [["ALL", 1, 1, 1, 1, 1, 1, 1, "20260101", "20271231"]],
    )
    trips, st = line_trips(
        "FXT", "FXK", "ALL", ["FXT1", "FXT2", "FXT3"], 6 * 3600, 24 * 3600, 720, 240
    )
    write(
        f,
        "trips.txt",
        ["route_id", "service_id", "trip_id", "trip_headsign", "direction_id", "shape_id"],
        [[*t, "FXK_0" if t[4] == 0 else "FXK_1"] for t in trips],
    )
    write(
        f,
        "stop_times.txt",
        ["trip_id", "arrival_time", "departure_time", "stop_id", "stop_sequence"],
        st,
    )
    pts = [(s[2], s[3]) for s in stops]
    shapes = [["FXK_0", lat, lon, i + 1] for i, (lat, lon) in enumerate(pts)]
    shapes += [["FXK_1", lat, lon, i + 1] for i, (lat, lon) in enumerate(reversed(pts))]
    write(
        f, "shapes.txt", ["shape_id", "shape_pt_lat", "shape_pt_lon", "shape_pt_sequence"], shapes
    )


def gen_bus_expired() -> None:
    f = "fx_bus_expired"
    agency(f, "FXB", "Fixture Bus")
    write(
        f,
        "stops.txt",
        ["stop_id", "stop_name", "stop_lat", "stop_lon"],
        [
            ["9001", "Fixture Bus A", "38.4300", "27.1600"],
            ["9002", "Fixture Bus B", "38.4400", "27.1700"],
        ],
    )
    write(
        f,
        "routes.txt",
        ["route_id", "route_short_name", "route_long_name", "route_type"],
        [["90", "990", "Fixture Bus Line", 3]],
    )
    write(
        f,
        "calendar.txt",
        [
            "service_id",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
            "sunday",
            "start_date",
            "end_date",
        ],
        [["S1", 1, 1, 1, 1, 1, 1, 1, "20240101", "20241231"]],
    )
    write(f, "trips.txt", ["route_id", "service_id", "trip_id"], [["90", "S1", "B1"]])
    write(
        f,
        "stop_times.txt",
        ["trip_id", "arrival_time", "departure_time", "stop_id", "stop_sequence"],
        [["B1", "08:00:00", "08:00:00", "9001", 1], ["B1", "08:10:00", "08:10:00", "9002", 2]],
    )


def gen_broken() -> None:
    src = HERE / "fx_tram"
    for name in ("broken_missing_column", "broken_orphan", "broken_non_monotonic"):
        dst = HERE / name
        if dst.exists():
            shutil.rmtree(dst)
        shutil.copytree(src, dst)
    # trips.txt without service_id
    p = HERE / "broken_missing_column" / "trips.txt"
    rows = list(csv.reader(p.open(encoding="utf-8")))
    idx = rows[0].index("service_id")
    with p.open("w", newline="", encoding="utf-8") as fh:
        csv.writer(fh, lineterminator="\n").writerows([r[:idx] + r[idx + 1 :] for r in rows])
    # a stop_time pointing at a trip that does not exist
    with (HERE / "broken_orphan" / "stop_times.txt").open("a", newline="", encoding="utf-8") as fh:
        csv.writer(fh, lineterminator="\n").writerow(["GHOST", "08:00:00", "08:00:00", "FXT1", 1])
    # times going backwards within a trip
    p = HERE / "broken_non_monotonic" / "stop_times.txt"
    rows = list(csv.reader(p.open(encoding="utf-8")))
    rows[2][1] = rows[2][2] = "05:00:00"
    with p.open("w", newline="", encoding="utf-8") as fh:
        csv.writer(fh, lineterminator="\n").writerows(rows)


if __name__ == "__main__":
    gen_metro()
    gen_tram()
    gen_bus_expired()
    gen_broken()
    (HERE / "README.md").write_text(
        "# Synthetic fixture feeds\n\n**These are invented test feeds, not real timetables.** They are "
        "generated by `generate.py`. Stop coordinates sit on real streets near Halkapınar so OTP can "
        "route walking transfers over a real OSM clip; every name is prefixed `Fixture`.\n\n"
        "| Feed | Purpose |\n|---|---|\n"
        "| `fx_metro` | weekday/weekend service, trips past midnight (24:20), a calendar_dates exception |\n"
        "| `fx_tram` | daily service with shapes; a transfer partner for `fx_metro` at Halkapınar |\n"
        "| `fx_bus_expired` | calendar ended 2024-12-31, so it must be excluded from routing |\n"
        "| `broken_*` | structural failures: missing column, orphan stop_time, non-monotonic times |\n",
        "utf-8",
    )
