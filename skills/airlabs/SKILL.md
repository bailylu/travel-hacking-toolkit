---
name: airlabs
description: Real-time flight tracking, schedules, and airport/flight status via Airlabs API. Covers live positions, en-route status, delay info, and scheduled departures/arrivals.
allowed-tools: Bash(curl *)
---

# Airlabs Flight Data

Real-time flight tracking and schedules via the [Airlabs API](https://airlabs.co). Provides live flight positions (ADS-B), status tracking, delay information, and scheduled flight data.

**Source:** [airlabs.co](https://airlabs.co)

## Prerequisites

- `AIRLABS_API_KEY` environment variable set with your Airlabs API token
- Free tier: 1000 requests/month, expires 2026-05-22

## API Basics

- **Base URL:** `https://airlabs.co/api/v9`
- **Auth:** `api_key` parameter (NOT `token`)
- **Rate limit:** 2500 requests/hour (free tier)

## Track a Flight by IATA Code

```bash
curl -s "https://airlabs.co/api/v9/flight?flight_iata=UA901&api_key=$AIRLABS_API_KEY"
```

Response includes: departure/arrival times, terminal/gate, status (scheduled/en-route/landed), delay minutes, aircraft type, route percentage complete.

## Real-Time Flights from an Airport

```bash
# Departures
curl -s "https://airlabs.co/api/v9/flights?dep_iata=JFK&_view=array&_dir=dep&api_key=$AIRLABS_API_KEY"

# Arrivals
curl -s "https://airlabs.co/api/v9/flights?arr_iata=JFK&_view=array&_dir=arr&api_key=$AIRLABS_API_KEY"
```

## Flight Schedules

```bash
# By route and date
curl -s "https://airlabs.co/api/v9/schedules?dep_iata=JFK&arr_iata=LAX&date=2026-04-25&api_key=$AIRLABS_API_KEY"
```

## Response Fields

### Flight Tracking (`/flight`)
| Field | Description |
|-------|-------------|
| `flight_iata` | Flight number (e.g., UA901) |
| `status` | scheduled / en-route / landed / cancelled |
| `dep_iata` / `arr_iata` | Departure/arrival airport codes |
| `dep_time` / `arr_time` | Scheduled times |
| `dep_estimated` / `arr_estimated` | Estimated times |
| `dep_delayed` / `arr_delayed` | Delay in minutes |
| `dep_terminal` / `arr_terminal` | Terminal |
| `dep_gate` / `arr_gate` | Gate |
| `duration` | Flight duration in minutes |
| `aircraft_icao` | Aircraft type (e.g., B77W) |
| `percent` | % of journey completed |
| `eta` | Estimated time of arrival (minutes remaining) |

### Schedule (`/schedules`)
| Field | Description |
|-------|-------------|
| `flight_iata` | Flight number |
| `airline_iata` | Marketing airline |
| `dep_iata` / `arr_iata` | Route |
| `dep_time` / `arr_time` | Scheduled times (local) |
| `duration` | Duration in minutes |
| `status` | scheduled / delayed / cancelled |
| `delayed` | Delay in minutes |
| `cs_flight_iata` | Codeshare flight number (if applicable) |

## Important Notes

- Use IATA codes (3-letter), not ICAO codes
- `/flight` gives real-time tracking; `/schedules` gives scheduled data
- Free tier expires 2026-05-22 — renew before then
- Real-time position data comes from ADS-B receivers worldwide
- Delay info is updated in real-time from airline and airport sources
