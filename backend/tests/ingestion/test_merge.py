import csv
import io
import zipfile
from datetime import date
from pathlib import Path

from izmirgo.ingestion.merge import SourceInput, load_interchanges, load_stations, merge_feeds
from tests.conftest import FIXTURES


def _read(zf: zipfile.ZipFile, name: str) -> list[dict[str, str]]:
    return list(csv.DictReader(io.TextIOWrapper(zf.open(name), encoding="utf-8")))


def test_merge_namespaces_and_links(tmp_path: Path, feed_zip, fixture_sources) -> None:  # type: ignore[no-untyped-def]
    inputs = [
        SourceInput(
            fixture_sources["metro"], feed_zip("fx_metro"), date(2026, 1, 1), date(2027, 12, 31)
        ),
        SourceInput(
            fixture_sources["tram"], feed_zip("fx_tram"), date(2026, 1, 1), date(2027, 12, 31)
        ),
    ]
    out = tmp_path / "merged.zip"
    res = merge_feeds(
        inputs,
        out,
        version_label="test-v1",
        interchanges=load_interchanges(FIXTURES / "data" / "interchanges.csv"),
        stations=load_stations(FIXTURES / "data" / "stations.csv"),
    )
    assert res.transfers_added == 2  # one curated pair, both directions
    assert res.skipped_interchanges == ["metro:FXM9<->tram:FXT1"]
    assert res.stations_added == 1  # the lonely station has a single existing member
    assert res.counts["tram"]["stops.txt"] == 3
    assert res.counts["metro"]["stops.txt"] == 3

    with zipfile.ZipFile(out) as zf:
        stops = {r["stop_id"]: r for r in _read(zf, "stops.txt")}
        assert set(stops) == {
            "metro:FXM1",
            "metro:FXM2",
            "metro:FXM3",
            "tram:FXT1",
            "tram:FXT2",
            "tram:FXT3",
            "stn:fx-halkapinar",
        }
        assert stops["metro:FXM2"]["parent_station"] == "stn:fx-halkapinar"
        assert stops["stn:fx-halkapinar"]["location_type"] == "1"
        assert stops["metro:FXM1"]["parent_station"] == ""

        routes = _read(zf, "routes.txt")
        assert {r["agency_id"] for r in routes} == {"metro:FXM", "tram:FXT"}
        trips = _read(zf, "trips.txt")
        assert all(t["service_id"].split(":")[0] in ("metro", "tram") for t in trips)
        assert {t["shape_id"] for t in trips if t["route_id"] == "tram:FXK"} == {
            "tram:FXK_0",
            "tram:FXK_1",
        }
        st = next(iter(_read(zf, "stop_times.txt")))
        assert st["trip_id"].startswith("metro:")

        transfers = _read(zf, "transfers.txt")
        assert {(t["from_stop_id"], t["to_stop_id"]) for t in transfers} == {
            ("metro:FXM2", "tram:FXT1"),
            ("tram:FXT1", "metro:FXM2"),
        }
        info = _read(zf, "feed_info.txt")[0]
        assert info["feed_version"] == "test-v1"
        assert info["feed_end_date"] == "20271231"
        assert len(_read(zf, "attributions.txt")) == 2


def test_merged_feed_validates(tmp_path: Path, feed_zip, fixture_sources) -> None:  # type: ignore[no-untyped-def]
    from izmirgo.ingestion.gtfs import GtfsFeed
    from izmirgo.ingestion.validate import validate_feed
    from tests.conftest import FIXTURE_TODAY, IZMIR_BBOX

    inputs = [
        SourceInput(
            fixture_sources["metro"], feed_zip("fx_metro"), date(2026, 1, 1), date(2027, 12, 31)
        ),
        SourceInput(
            fixture_sources["tram"], feed_zip("fx_tram"), date(2026, 1, 1), date(2027, 12, 31)
        ),
    ]
    out = tmp_path / "merged.zip"
    merge_feeds(
        inputs, out, version_label="v", stations=load_stations(FIXTURES / "data" / "stations.csv")
    )
    with GtfsFeed(out) as feed:
        report = validate_feed(feed, today=FIXTURE_TODAY, bbox=IZMIR_BBOX)
    assert report.usable, report.to_dict()


def test_merge_drops_repaired_trips(tmp_path: Path, feed_zip, fixture_sources) -> None:  # type: ignore[no-untyped-def]
    from izmirgo.ingestion.gtfs import GtfsFeed
    from izmirgo.ingestion.validate import validate_feed
    from tests.conftest import FIXTURE_TODAY, IZMIR_BBOX

    path = feed_zip("broken_non_monotonic")
    with GtfsFeed(path) as feed:
        report = validate_feed(feed, today=FIXTURE_TODAY, bbox=IZMIR_BBOX)
    (bad,) = report.drop_trip_ids
    out = tmp_path / "merged.zip"
    merge_feeds(
        [
            SourceInput(
                fixture_sources["tram"],
                path,
                date(2026, 1, 1),
                date(2027, 12, 31),
                frozenset(report.drop_trip_ids),
            )
        ],
        out,
        version_label="v",
    )
    with zipfile.ZipFile(out) as zf:
        assert f"tram:{bad}" not in {t["trip_id"] for t in _read(zf, "trips.txt")}
        assert f"tram:{bad}" not in {t["trip_id"] for t in _read(zf, "stop_times.txt")}
