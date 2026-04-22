---
name: fli
description: Google Flights search via Fli. Direct API access to Google Flights data - covers ALL airlines including Southwest. Fast, reliable, no browser automation needed.
allowed-tools: Bash(fli *)
---

# Fli - Google Flights

Programmatic access to Google Flights via Fli library. Returns comprehensive flight search results with pricing, duration, stops, and airline information.

**Source:** [github.com/punitarani/fli](https://github.com/punitarani/fli)

## CLI Usage

### Search Flights (One-Way)

```bash
fli flights JFK LAX 2026-05-01
```

### Search Flights (Round-Trip)

```bash
fli flights JFK LAX 2026-05-01 --return 2026-05-10
```

### Find Cheapest Dates

```bash
fli dates JFK LAX --from 2026-06-01 --to 2026-06-30
```

## Options

| Flag | Short | Description | Values |
|------|-------|-------------|--------|
| `--class` | `-c` | Cabin class | economy, premium_economy, business, first |
| `--stops` | `-s` | Max stops | non_stop, one_stop, two_stops |
| `--sort` | `-o` | Sort results | NONE, TOP_FLIGHTS, CHEAPEST, DEPARTURE_TIME, ARRIVAL_TIME, DURATION |
| `--airlines` | `-a` | Filter by airline codes | e.g., "AA,DELTA,UAL" |
| `--time` | `-t` | Departure time window | e.g., "06:00,12:00" |
| `--return` | `-r` | Return date for round-trip | YYYY-MM-DD |
| `--format` | `-f` | Output format | table, json, csv |

## Examples

### Search business class, non-stop, cheapest first

```bash
fli flights JFK LHR 2026-08-15 --class business --stops non_stop --sort CHEAPEST
```

### Search with airline filter

```bash
fli flights SFO NRT 2026-10-01 --airlines "ANA,JAL,UAL"
```

### Find cheapest dates for a route

```bash
fli dates JFK CDG --from 2026-07-01 --to 2026-09-30 --sort CHEAPEST
```

### JSON output for scripting

```bash
fli flights JFK LAX 2026-05-01 --format json
```

## Output Interpretation

- **Price**: Total price in USD (may include taxes)
- **Duration**: Total travel time including layovers
- **Stops**: Number of stops (0 = non-stop)
- **Segments**: Individual flight legs with departure/arrival times

## Important Notes

- Results come directly from Google Flights API
- Covers ALL airlines including Southwest (unlike Duffel/Ignav)
- Prices are live and accurate
- No API key required
- Fli MCP server (`fli-mcp`) provides `search_flights` and `search_dates` tools
