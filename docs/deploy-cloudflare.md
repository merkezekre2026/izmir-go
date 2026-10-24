# Free deployment on Cloudflare Workers

The İzmir Go API runs on the **Cloudflare Workers free plan** at no cost. The deploy itself runs on GitHub Actions (free).

## How it works

```
GitHub Actions (daily, free)                     Cloudflare (free)
  fetch + validate GTFS feeds  ──► static bundle ──► Worker "izmir-go-api"
  (izmirgo-ingest build-bundle)    edge/public/data    /api/v1/*  (same contract as the FastAPI backend)
                                                       live ESHOT data fetched on request
```

- **No database.** Stops, routes, departures, nearby-stop tiles and a search index are precomputed
  static files. Cloudflare serves static assets free and without request limits.
- **Journey planning** runs in the Worker as a compact RAPTOR router over the bundled timetable.
  This replaces OpenTripPlanner, which needs a paid container.
- **Live ESHOT data** is fetched on request and cached for 15 s. It shows stops remaining, never
  minutes.
- **A failed feed build never deploys,** so the previous data stays online.

## Limits of the free setup

| Limit | Effect |
|---|---|
| 100,000 Worker requests/day, 10 ms CPU per request | Plenty for a small user base; static files are not counted |
| Walking is estimated from straight-line distance × 1.3 | Walk legs are labelled `straight_line`; no street-by-street directions |
| Bus timetables (2M+ stop times) do not fit the free CPU/memory budget | If ESHOT's feed becomes valid again, journeys stay Metro + Tram; live bus data and bus stops still work |
| Address search uses the public Photon instance (fair use) | Best-effort; stop search always works |

The full stack (`backend/` + OpenTripPlanner + PostGIS) is still the path for street-accurate walking and bus routing on a paid host.

## One-time setup (about 5 minutes)

1. Create a free Cloudflare account at <https://dash.cloudflare.com/sign-up>. The Workers free plan needs no payment method.
2. In Workers & Pages, open your account once to choose a `*.workers.dev` subdomain.
3. Create an API token: My Profile → API Tokens → Create Token → template **Edit Cloudflare Workers**.
4. Copy your **Account ID** (Workers & Pages → right sidebar).
5. In GitHub: Settings → Secrets and variables → Actions:
   - Secret `CLOUDFLARE_API_TOKEN`: the token.
   - Secret `CLOUDFLARE_ACCOUNT_ID`: the account id.
6. Run Actions → **deploy-edge** → Run workflow. The API is then at
   `https://izmir-go-api.<your-subdomain>.workers.dev/api/v1`.
7. Set the repository **variable** `API_BASE_URL` to that URL. The release workflow then builds the mobile app against it, and deploys get a smoke test.

After that, it redeploys every day at 05:17 İzmir time and on every push to `main` that touches the backend, edge or data.

## Local development

```bash
cd edge
npm ci
npm run bundle          # real feeds (or: npm run bundle:fixtures)
npx wrangler dev        # http://127.0.0.1:8787/api/v1/health
```
