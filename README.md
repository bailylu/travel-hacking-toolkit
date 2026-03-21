# Travel Hacking Toolkit

AI-powered travel hacking with points, miles, and award flights. Drop-in skills and MCP servers for [OpenCode](https://opencode.ai) and [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Ask your AI to find you a 60,000-mile business class flight to Tokyo. It'll search award availability across 25+ programs, compare against cash prices, check your loyalty balances, and tell you the best play.

## What's Included

### MCP Servers (real-time tools)

| Server | What It Does | API Key |
|--------|-------------|---------|
| [Skiplagged](https://skiplagged.com) | Flight search with hidden city fares | None (free) |
| [Kiwi.com](https://www.kiwi.com) | Flights with virtual interlining (creative cross-airline routing) | None (free) |
| [Trivago](https://mcp.trivago.com/docs) | Hotel metasearch across booking sites | None (free) |
| [Ferryhopper](https://ferryhopper.github.io/fh-mcp/) | Ferry routes across 33 countries, 190+ operators | None (free) |
| [Airbnb](https://github.com/openbnb-org/mcp-server-airbnb) | Search Airbnb listings, property details, pricing | None (free) |
| [LiteAPI](https://mcp.liteapi.travel) | Hotel search with live rates and booking | [LiteAPI](https://liteapi.travel) |

### Skills (API knowledge for your AI)

| Skill | What It Does | API Key |
|-------|-------------|---------|
| **duffel** | Real-time flight search across airlines via Duffel API | [Duffel](https://duffel.com) |
| **seats-aero** | Award flight availability across 25+ mileage programs | [Seats.aero](https://seats.aero) Pro/Partner |
| **awardwallet** | Loyalty program balances, elite status, history | [AwardWallet](https://business.awardwallet.com) Business |
| **serpapi** | Google Flights cash prices, hotels, destination discovery | [SerpAPI](https://serpapi.com) |
| **rapidapi** | Secondary prices via Google Flights Live + Booking.com | [RapidAPI](https://rapidapi.com) |
| **atlas-obscura** | Hidden gems near any destination | None (free) |
| **scandinavia-transit** | Trains, buses, ferries in Norway/Sweden/Denmark | [Entur](https://developer.entur.org) + [Trafiklab](https://www.trafiklab.se) |

## Quick Start

### Option 1: Work from this directory (easiest)

```bash
git clone https://github.com/borski/travel-hacking-toolkit.git
cd travel-hacking-toolkit
```

**Launch OpenCode:**

```bash
opencode
```

OpenCode reads `opencode.json` from the project directory automatically. The free servers (Skiplagged, Kiwi, Trivago, Ferryhopper, Airbnb) work immediately with zero config.

**Launch Claude Code:**

```bash
claude --strict-mcp-config --mcp-config .mcp.json
```

The `--strict-mcp-config` flag tells Claude Code to load MCP servers exclusively from the provided config file. This is more reliable than auto-discovery ([known issue](https://github.com/anthropics/claude-code/issues/5037)).

#### Adding your API keys

Some MCP servers and all skills need API keys. Add them once and they load every session.

**OpenCode:**

```bash
cp .env.example .env
# Edit .env with your API keys
```

**Claude Code:**

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit .claude/settings.local.json with your API keys
```

This file is auto-gitignored by Claude Code. Keys are loaded as environment variables.

### Option 2: Install globally

```bash
git clone https://github.com/borski/travel-hacking-toolkit.git
cd travel-hacking-toolkit
./scripts/setup.sh
```

The setup script copies skills to your tool's global skills directory and creates API key config files.

### Minimum Setup

You don't need every API key. Start with these two for the core experience:

| Key | Why | Free Tier |
|-----|-----|-----------|
| `SEATS_AERO_API_KEY` | Award flight search. The main event. | No (Pro ~$8/mo) |
| `SERPAPI_API_KEY` | Cash price comparison for "points or cash?" decisions | Yes (100 searches/mo) |

Everything else adds capability but isn't required.

## How It Works

### Skills

Skills are markdown files that teach your AI how to call travel APIs. They contain endpoint documentation, curl examples, useful jq filters, and workflow guidance. Both OpenCode and Claude Code support skills natively.

The `skills/` directory is the canonical source. The setup script either:
- Copies them to your tool's global skills directory (`~/.config/opencode/skills/` or `~/.claude/skills/`)
- Or creates project-level symlinks so they load when you work from this directory

### MCP Servers

MCP (Model Context Protocol) servers give your AI real-time tools it can call directly. The configs are in:
- `opencode.json` for OpenCode
- `.mcp.json` for Claude Code

Skiplagged, Kiwi.com, Trivago, Ferryhopper, and Airbnb need no setup at all. LiteAPI is also a remote server but needs an API key configured in your settings.

## The Travel Hacking Workflow

The core question: **"Should I burn points or pay cash?"**

1. **Search award availability** — Seats.aero across 25+ programs
2. **Search cash prices** — SerpAPI (Google Flights) or Skiplagged
3. **Calculate portal value** — Cash price ÷ 0.015 = Chase UR equivalent
4. **Compare** — Lower number wins
5. **Check balances** — AwardWallet confirms you have enough
6. **Book it** — Use booking links from Seats.aero or Duffel

### Example Prompts

```
"Find me the cheapest business class award from SFO to Tokyo in August"
"Compare points vs cash for a round trip JFK to London next March"
"What are my United miles and Chase UR balances?"
"Find hidden gems near Lisbon"
"How do I get from Oslo to Bergen by train?"
```

## Project Structure

```
travel-hacking-toolkit/
├── AGENTS.md -> CLAUDE.md          # OpenCode project instructions (symlink)
├── CLAUDE.md                       # Project instructions and workflow guidance
├── opencode.json                   # OpenCode MCP server config
├── .mcp.json                       # Claude Code MCP server config
├── .env.example                    # API key template (OpenCode)
├── .claude/
│   ├── settings.local.json.example # API key template (Claude Code)
│   └── skills -> ../skills         # Symlink to skills
├── .opencode/
│   └── skills -> ../skills         # Symlink to skills
├── data/
│   └── points-valuations.json      # Points/miles valuations from 4 sources
├── skills/
│   ├── duffel/SKILL.md             # Real-time flight search
│   ├── seats-aero/SKILL.md         # Award flight search
│   ├── awardwallet/SKILL.md        # Loyalty balances
│   ├── serpapi/SKILL.md            # Cash prices + hotels
│   ├── rapidapi/SKILL.md           # Secondary price source
│   ├── atlas-obscura/              # Hidden gems (+ Node.js scraper)
│   │   ├── SKILL.md
│   │   ├── ao.mjs
│   │   └── package.json
│   └── scandinavia-transit/        # Nordic trains/buses/ferries
│       └── SKILL.md
├── scripts/
│   └── setup.sh                    # Interactive installer
└── LICENSE                         # MIT
```

## Credits

Built on these excellent projects:

- [Seats.aero](https://seats.aero) — Award flight availability data
- [AwardWallet](https://awardwallet.com) — Loyalty program tracking
- [Duffel](https://duffel.com) — Real-time flight search and booking
- [SerpAPI](https://serpapi.com) — Google search result APIs
- [RapidAPI](https://rapidapi.com) — API marketplace
- [atlas-obscura-api](https://github.com/bartholomej/atlas-obscura-api) by [@bartholomej](https://github.com/bartholomej) — Atlas Obscura scraper
- [Skiplagged MCP](https://mcp.skiplagged.com) — Flight search with hidden city fares
- [Kiwi.com MCP](https://www.kiwi.com/stories/kiwi-mcp-connector/) — Flight search with virtual interlining
- [Trivago MCP](https://mcp.trivago.com/docs) — Hotel metasearch
- [Ferryhopper MCP](https://ferryhopper.github.io/fh-mcp/) by [Ferryhopper](https://ferryhopper.com) — Ferry routes across 33 countries
- [mcp-server-airbnb](https://github.com/openbnb-org/mcp-server-airbnb) by [OpenBnB](https://github.com/openbnb-org) — Airbnb search and listing details
- [LiteAPI MCP](https://mcp.liteapi.travel) by [LiteAPI](https://liteapi.travel) — Hotel booking
- [Entur](https://developer.entur.org) — Norwegian transit API
- [Trafiklab / ResRobot](https://www.trafiklab.se) — Swedish transit API
- [Rejseplanen](https://labs.rejseplanen.dk) — Danish transit API

## License

MIT
