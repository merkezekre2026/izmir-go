# OpenTripPlanner configuration

İzmir Go runs **OpenTripPlanner 2.10.0** (`opentripplanner/opentripplanner:2.10.0`) as a separate
service. Its graph is rebuilt for every published dataset version.

- `build-config.json` is the template the ingestion job writes into each build directory. The
  `osm` entry is dropped when no OSM extract is configured; in that case OTP can still route
  stop-to-stop with curated transfers, but it cannot walk from arbitrary coordinates.
- `router-config.json` holds the routing defaults: walk speed 1.33 m/s, 1 min transfer slack,
  at most 6 transfers, an 8 s API timeout.
- The single merged feed has feedId `izm`, so OTP ids look like `izm:metro:6`. The API strips
  the prefix.
- Curated cross-operator transfers (`data/interchanges.csv`) reach OTP as GTFS `transfers.txt`
  (type 2). OTP imports them as constrained transfers. OTP also computes walking transfers over
  the OSM street network up to `maxTransferDuration`.

Graph build + blue/green serve (see `backend/src/izmirgo/ingestion/otp_build.py`):

```bash
cd backend && uv run izmirgo-ingest run --build-graph   # needs Docker and IZMIRGO_OSM_PATH
```

OSM extract: `scripts/fetch-osm.sh` downloads the Türkiye extract and clips it to the İzmir
province bounding box with osmium. Map data © OpenStreetMap contributors, ODbL.
