# İzmir Go backend

One Python project with two entry points that share one model layer:

- `izmirgo-api`: the FastAPI service (`/api/v1`).
- `izmirgo-ingest`: the GTFS ingestion CLI (fetch → validate → normalize → merge → stage → publish).

See the repository root README and `CLAUDE.md` for commands.
