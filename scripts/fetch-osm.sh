#!/usr/bin/env bash
# Download the Türkiye OSM extract and clip it to the İzmir province bounding box.
# Requires: curl, osmium-tool. Output: var/osm/izmir.osm.pbf (ODbL, © OpenStreetMap contributors)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/var/osm"
mkdir -p "$OUT"
# Geofabrik is the usual source; openstreetmap.fr is a working mirror (both checked 2026-10-24).
SOURCES=(
  "https://download.geofabrik.de/europe/turkey-latest.osm.pbf"
  "https://download.openstreetmap.fr/extracts/europe/turkey-latest.osm.pbf"
)
if [[ ! -s "$OUT/turkey-latest.osm.pbf" ]]; then
  for url in "${SOURCES[@]}"; do
    echo "downloading $url"
    if curl -fSL --retry 3 --retry-delay 10 -o "$OUT/turkey-latest.osm.pbf.part" "$url"; then
      mv "$OUT/turkey-latest.osm.pbf.part" "$OUT/turkey-latest.osm.pbf"
      break
    fi
  done
fi
[[ -s "$OUT/turkey-latest.osm.pbf" ]] || { echo "no OSM extract could be downloaded" >&2; exit 1; }
# lon_min,lat_min,lon_max,lat_max (matches IZMIRGO coverage_bbox)
osmium extract --overwrite --strategy complete_ways --bbox 26.2,37.8,28.5,39.4 \
  -o "$OUT/izmir.osm.pbf" "$OUT/turkey-latest.osm.pbf"
ls -lh "$OUT/izmir.osm.pbf"
