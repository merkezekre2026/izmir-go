# OSM fixture

`halkapinar-walk.osm.pbf` is a small clip of real OpenStreetMap data around Halkapınar, İzmir
(bbox 27.145,38.424,27.185,38.446), filtered to walkable ways and platforms. It was fetched on
2026-10-24 from the OSM API (`/api/0.6/map`) and reduced with
`osmium tags-filter ... w/highway w/public_transport=platform w/railway=platform`.

OTP integration tests use it to route walking access, egress and transfers for the synthetic
fixture feeds, whose stops sit inside this area.

Map data © OpenStreetMap contributors, available under the Open Database License (ODbL 1.0):
https://www.openstreetmap.org/copyright
