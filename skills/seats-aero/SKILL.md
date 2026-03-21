---
name: seats-aero
description: Search award flight availability across mileage programs via Seats.aero Partner API. Use when planning trips on points, searching for award flights, or comparing mileage costs across programs. Triggers on "award flight", "miles cost", "points for flights", "cheapest award", "seats.aero", "mileage program availability", "United miles", "Flying Blue", "Aeroplan", or any question about how many miles/points a specific flight costs.
license: MIT
---

# Seats.aero Skill

Search cached and live award flight availability across 25+ mileage programs. Find the cheapest award flights, compare programs, and get booking links.

**Source:** [seats.aero](https://seats.aero) — Requires a Pro or Partner account.

## Authentication

Set `SEATS_AERO_API_KEY` in your `.env` file. Get the key from your Seats.aero Pro or Partner account settings.

All requests use the `Partner-Authorization` header.

## API Base

```
https://seats.aero/partnerapi
```

## Mileage Program Sources

| Source | Program | Cabins | Seat Count | Trip Data |
|--------|---------|--------|------------|-----------|
| `eurobonus` | SAS EuroBonus | Y/J | Yes | Yes |
| `virginatlantic` | Virgin Atlantic Flying Club | Y/W/J | Yes | Yes |
| `aeromexico` | Aeromexico Club Premier | Y/W/J | Yes | Yes |
| `american` | American Airlines AAdvantage | Y/W/J/F | Limited | Yes |
| `delta` | Delta SkyMiles | Y/W/J | Yes | Yes |
| `etihad` | Etihad Guest | Y/J/F | Yes | Yes |
| `united` | United MileagePlus | Y/W/J/F | Yes | Yes |
| `emirates` | Emirates Skywards | Y/W/J/F | No | Yes |
| `aeroplan` | Air Canada Aeroplan | Y/W/J/F | Yes | Yes |
| `alaska` | Alaska Mileage Plan | Y/W/J/F | Yes | Yes |
| `velocity` | Virgin Australia Velocity | Y/W/J/F | Yes | Yes |
| `qantas` | Qantas Frequent Flyer | Y/W/J/F | No | Yes |
| `connectmiles` | Copa ConnectMiles | Y/J/F | No | Yes |
| `azul` | Azul TudoAzul | Y/J | No | Yes |
| `smiles` | GOL Smiles | Y/W/J/F | Yes | Yes |
| `flyingblue` | Air France/KLM Flying Blue | Y/W/J/F | Yes | Yes |
| `jetblue` | JetBlue TrueBlue | Y/W/J/F | Yes | Yes |
| `qatar` | Qatar Privilege Club | Y/J/F | No | Yes |
| `turkish` | Turkish Miles & Smiles | Y/J | No | Yes |
| `singapore` | Singapore KrisFlyer | Y/W/J/F | No | Yes |
| `ethiopian` | Ethiopian ShebaMiles | Y/J | Yes | Yes |
| `saudia` | Saudi AlFursan | Y/J/F | Yes | Yes |
| `finnair` | Finnair Plus | Y/W/J/F | Yes | Yes |
| `lufthansa` | Lufthansa Miles&More | Y/J/F | Yes | Yes |

**Cabin codes:** Y = economy, W = premium economy, J = business, F = first

## Cached Search (Primary Endpoint)

Search for award availability between specific airports and date ranges across all programs.

```bash
curl -s -H "Partner-Authorization: $SEATS_AERO_API_KEY" \
  "https://seats.aero/partnerapi/search?origin_airport=SFO&destination_airport=NRT&start_date=2026-03-01&end_date=2026-03-31" | jq '.'
```

### Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `origin_airport` | Yes | Comma-delimited airport codes: `SFO,LAX` |
| `destination_airport` | Yes | Comma-delimited airport codes: `NRT,HND` |
| `start_date` | No | YYYY-MM-DD format |
| `end_date` | No | YYYY-MM-DD format |
| `cabins` | No | Comma-delimited: `economy,business` |
| `sources` | No | Comma-delimited program filter: `aeroplan,united` |
| `only_direct_flights` | No | Boolean. Only direct flights. |
| `carriers` | No | Comma-delimited airline codes: `DL,AA` |
| `order_by` | No | Default: date+cabin priority. Use `lowest_mileage` for cheapest first. |
| `include_trips` | No | Boolean. Include flight details (slower). |
| `take` | No | Results per page. 10-1000, default 500. |
| `skip` | No | Pagination offset. |
| `cursor` | No | Cursor from previous response for consistent pagination. |

### Response Fields (Availability Object)

Each result summarizes all flights for one route/date/program:

| Field | Description |
|-------|-------------|
| `ID` | Availability ID (use with `/trips/{id}` for flight details) |
| `Route.OriginAirport` | Origin airport code |
| `Route.DestinationAirport` | Destination airport code |
| `Date` | Departure date |
| `Source` | Mileage program |
| `YAvailable`, `WAvailable`, `JAvailable`, `FAvailable` | Cabin availability booleans |
| `YMileageCost`, `WMileageCost`, `JMileageCost`, `FMileageCost` | Points cost (string) |
| `YRemainingSeats`, `WRemainingSeats`, `JRemainingSeats`, `FRemainingSeats` | Seats remaining |
| `YAirlines`, `WAirlines`, `JAirlines`, `FAirlines` | Operating carriers |
| `YDirect`, `WDirect`, `JDirect`, `FDirect` | Direct flight available |
| `ComputedLastSeen` | When availability was last verified |

## Get Trip Details

Get flight-level information from an availability object.

```bash
curl -s -H "Partner-Authorization: $SEATS_AERO_API_KEY" \
  "https://seats.aero/partnerapi/trips/{availability_id}" | jq '.'
```

### Response Fields (Trip Object)

| Field | Description |
|-------|-------------|
| `Cabin` | economy, premium, business, first |
| `MileageCost` | Points cost (integer) |
| `TotalTaxes` | Taxes in cents |
| `RemainingSeats` | Seats left |
| `Stops` | Number of stops |
| `TotalDuration` | Minutes |
| `Carriers` | Operating airlines |
| `FlightNumbers` | Flight number string |
| `DepartsAt` | Departure (local airport time) |
| `ArrivesAt` | Arrival (local airport time) |
| `AvailabilitySegments` | Array of individual flight legs |
| `Source` | Mileage program |

The response also includes `booking_links` with direct links to book on each program's site.

### Trip Segment Fields

Each segment in `AvailabilitySegments`:

| Field | Description |
|-------|-------------|
| `FlightNumber` | e.g., "TK800" |
| `AircraftCode` | e.g., "77W" |
| `OriginAirport` | Segment origin |
| `DestinationAirport` | Segment destination |
| `DepartsAt` | Departure time |
| `ArrivesAt` | Arrival time |
| `FareClass` | Booking class letter |
| `Distance` | Segment distance |
| `Order` | Segment order (0-indexed) |

## Bulk Availability

Retrieve large result sets from one mileage program. Use for broad regional searches.

```bash
curl -s -H "Partner-Authorization: $SEATS_AERO_API_KEY" \
  "https://seats.aero/partnerapi/availability?source=united&origin_region=North%20America&destination_region=Europe&cabin=business&start_date=2026-08-01&end_date=2026-09-30" | jq '.'
```

### Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `source` | Yes | Single mileage program |
| `cabin` | No | economy, premium, business, first |
| `start_date` | No | YYYY-MM-DD |
| `end_date` | No | YYYY-MM-DD |
| `origin_region` | No | North America, South America, Africa, Asia, Europe, Oceania |
| `destination_region` | No | Same as above |
| `take` | No | 10-1000, default 500 |
| `skip` | No | Pagination offset |
| `cursor` | No | From previous response |

## Get Routes

List all monitored routes for a mileage program.

```bash
curl -s -H "Partner-Authorization: $SEATS_AERO_API_KEY" \
  "https://seats.aero/partnerapi/routes?source=united" | jq '.'
```

## Live Search

Real-time search for any city pair. Slower (5-15 seconds). May require commercial agreement beyond Pro.

```bash
curl -s -X POST -H "Partner-Authorization: $SEATS_AERO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"origin_airport":"SFO","destination_airport":"NRT","departure_date":"2026-08-15","source":"united","seat_count":2}' \
  "https://seats.aero/partnerapi/live" | jq '.'
```

### Parameters (JSON body)

| Param | Required | Description |
|-------|----------|-------------|
| `origin_airport` | Yes | Single airport code |
| `destination_airport` | Yes | Single airport code |
| `departure_date` | Yes | YYYY-MM-DD |
| `source` | Yes | Single mileage program |
| `seat_count` | No | 1-9, default 1 |
| `disable_filters` | No | Disable all dynamic pricing filters |

## Pagination

All endpoints use `skip` + `cursor`. On first call, omit both. From the response, save the `cursor` value. On subsequent calls, pass `cursor` and increment `skip` by the number of results received. Deduplicate by `ID` (rare duplicates possible).

## Useful jq Filters

```bash
# Business class availability sorted by cheapest miles
... | jq '[.data[] | select(.JAvailable == true) | {date: .Date, origin: .Route.OriginAirport, dest: .Route.DestinationAirport, miles: (.JMileageCost | tonumber), seats: .JRemainingSeats, airlines: .JAirlines, source: .Source, direct: .JDirect}] | sort_by(.miles)'

# Economy availability with 2+ seats
... | jq '[.data[] | select(.YAvailable == true and .YRemainingSeats >= 2) | {date: .Date, origin: .Route.OriginAirport, dest: .Route.DestinationAirport, miles: (.YMileageCost | tonumber), seats: .YRemainingSeats, source: .Source}] | sort_by(.miles)'

# All available cabins for a date range, grouped by date
... | jq '[.data[] | {date: .Date, origin: .Route.OriginAirport, dest: .Route.DestinationAirport, source: .Source, economy: (if .YAvailable then .YMileageCost else null end), business: (if .JAvailable then .JMileageCost else null end), first: (if .FAvailable then .FMileageCost else null end)}]'

# Direct flights only in business
... | jq '[.data[] | select(.JAvailable == true and .JDirect == true) | {date: .Date, miles: .JMileageCost, airlines: .JAirlines, source: .Source}]'
```

## Workflow: Trip Planning Search

1. **Cached Search** across multiple airports and date ranges to see what's available
2. **Compare programs** by checking which `source` has the cheapest miles
3. **Get Trip Details** on promising availability IDs for flight times and connections
4. **Use booking_links** from trip response to book directly on the airline site
5. Cross reference with AwardWallet balances to confirm enough points

## Notes

- All times in responses are local airport times.
- `TotalTaxes` is in cents (divide by 100 for dollars).
- `MileageCost` in availability objects is a string. In trip objects it's an integer.
- Dynamic pricing filters are on by default. Pass `include_filtered=true` to see filtered-out expensive options.
- Availability data is cached, not live. Check `ComputedLastSeen` for freshness.
