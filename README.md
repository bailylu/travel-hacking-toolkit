# Travel Hacking Toolkit

AI 驱动的旅行积分工具，集成多个航班搜索、酒店查询、积分管理服务。

**支持的 AI**: Claude Code, OpenCode

## 快速开始

### 1. 安装依赖

```bash
# 安装 Fli (Google Flights 搜索)
pipx install flights

# 克隆项目
git clone <repo-url>
cd travel-hacking-toolkit

# 复制配置文件
cp .env.example .env
```

### 2. 配置 API Key

编辑 `.env` 文件，填入你需要的 API key：

| 服务 | 用途 | 是否必须 | 获取地址 |
|------|------|---------|---------|
| **Fli** | Google Flights 搜索 | ✅ 不需要 key | 已安装 |
| **Airlabs** | 航班追踪、实时位置 | 推荐 | [airlabs.co](https://airlabs.co) |
| **Duffel** | 实时现金价格 | 推荐 | [duffel.com](https://duffel.com) |
| **SerpAPI** | Google Hotels | 可选 | [serpapi.com](https://serpapi.com) |
| **RapidAPI** | Booking.com | 可选 | [rapidapi.com](https://rapidapi.com) |
| **Seats.aero** | 奖励航班搜索 | 可选 | [seats.aero](https://seats.aero) |
| **AwardWallet** | 积分余额管理 | 可选 | [awardwallet.com](https://business.awardwallet.com) |

### 3. 配置 MCP 服务器

复制并修改 `.mcp.json`：

```json
{
  "mcpServers": {
    "skiplagged": {
      "type": "http",
      "url": "https://mcp.skiplagged.com/mcp"
    },
    "kiwi": {
      "type": "http",
      "url": "https://mcp.kiwi.com"
    },
    "trivago": {
      "type": "http",
      "url": "https://mcp.trivago.com/mcp"
    },
    "ferryhopper": {
      "type": "http",
      "url": "https://mcp.ferryhopper.com/mcp"
    },
    "fli": {
      "command": "fli-mcp"
    },
    "airbnb": {
      "command": "npx",
      "args": ["-y", "@openbnb/mcp-server-airbnb@latest", "--ignore-robots-txt"]
    }
  }
}
```

### 4. 启动 Claude Code

```bash
claude --strict-mcp-config --mcp-config .mcp.json
```

## 可用工具

### 免费 MCP 服务器（无需 API Key）

| 服务 | 用途 |
|------|------|
| Skiplagged | 隐藏城市机票 |
| Kiwi.com | 虚拟联程航班 |
| Trivago | 酒店元搜索 |
| Ferryhopper | 欧洲渡轮搜索 |
| Airbnb | 民宿搜索 |
| Fli | Google Flights（无 key，覆盖所有航司）|

### 航班搜索优先级

1. **Fli** - Google Flights，覆盖所有航司包括 Southwest
2. **Duffel** - GDS 实时价格，最准确
3. **Ignav** - REST API 备用
4. **Skiplagged** - 隐藏城市省钱
5. **Kiwi** - 创意联程
6. **Seats.aero** - 奖励里程搜索（需 key）

### 积分管理

- **AwardWallet** - 所有积分里程余额
- **Seats.aero** - 25+ 里程计划可用性

## 示例问题

- "帮我搜索 JFK 到 LAX 2026-05-01 的航班"
- "查询 UA901 航班当前状态"
- "找 SFO 到东京最便宜的商务舱奖励航班"
- "JFK 到 LAX 5月份最便宜的日期是哪些"
- "帮我查一下巴黎的酒店，预算 200 美元"
- "我有 10 万 Amex MR 积分，怎么用最划算"

## 项目结构

```
travel-hacking-toolkit/
├── .env.example          # API Key 模板
├── .mcp.json             # MCP 服务器配置
├── CLAUDE.md             # AI 指令文件（重要）
├── skills/               # 各服务 Skill 文档
│   ├── fli/              # Google Flights
│   ├── airlabs/          # 航班追踪
│   ├── duffel/           # GDS 实时价格
│   ├── seats-aero/        # 奖励航班
│   ├── serpapi/           # Google Hotels
│   └── ...
├── data/                 # 本地数据文件
│   ├── transfer-partners.json   # 积分转换比例
│   ├── points-valuations.json  # 积分估值
│   ├── alliances.json          # 航空联盟
│   └── hotel-chains.json       # 酒店集团
└── scripts/
    └── setup.sh          # 交互式安装脚本
```

## 注意事项

- Seats.aero 数据是缓存的，不是实时数据
- Duffel 搜索免费，只有预订时才收费
- Fli 不需要任何 API Key，直接可用
- 所有 API 都有用量限制，注意查看免费额度

## 许可

MIT License
