# Travel Hacking Toolkit

AI 驱动的旅行积分工具，集成航班搜索、酒店查询服务。针对中国用户优化，支持国内外旅行。

**支持的 AI**: Claude Code, OpenCode

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/bailylu/travel-hacking-toolkit.git
cd travel-hacking-toolkit
```

### 2. 配置 API Key ⚠️

复制配置文件并填入你的 API key：

```bash
cp .env.example .env
```

编辑 `.env` 文件：

| 服务 | 用途 | 是否必须 | 获取地址 |
|------|------|---------|---------|
| **Fli** | Google Flights 国际机票 | ✅ 不需要 key | 已安装，详见 skills/fli |
| **FlyAI** | 飞猪 中国国内机票/酒店/景点 | ✅ **需要 key** | [飞猪开放平台](https://open.fliggy.com/) |
| **SerpAPI** | Google Hotels 国际酒店 | ✅ **需要 key** | [serpapi.com](https://serpapi.com) |
| **Premium Hotels** | FHR/Chase Edit 高级酒店 | ✅ 不需要 key | 本地数据 in skills/premium-hotels |

### 3. 配置 MCP 服务器

`.mcp.json` 已预配置以下服务器：

| 服务 | 用途 | 需要 Key |
|------|------|---------|
| Skiplagged | 隐藏城市机票 | ❌ |
| Kiwi.com | 虚拟联程航班 | ❌ |
| Trivago | 酒店元搜索 | ❌ |
| Ferryhopper | 欧洲渡轮搜索 | ❌ |
| Airbnb | 民宿搜索 | ❌ |
| Fli | Google Flights | ❌ |

启动 Claude Code：

```bash
claude --strict-mcp-config --mcp-config .mcp.json
```

## 核心功能

### 机票搜索

```bash
# 国际机票 - 使用 fli (Google Flights)
fli flights JFK LAX 2026-05-01
fli dates SFO LAX 2026-05    # 找最便宜的日期

# 中国国内机票 - 使用 flyai (飞猪)
flyai search-flight --departure "上海" --destination "北京" --date 2026-05-01
```

### 酒店搜索

```bash
# 国际酒店 - 使用 SerpAPI
curl "https://serpapi.com/search?engine=google_hotels&q=hotels+Paris+France&..."

# 中国酒店 - 使用 flyai (飞猪)
flyai search-hotel --dest-name "杭州" --poi-name "西湖" --check-in-date 2026-03-10 --check-out-date 2026-03-12

# 高级酒店 (FHR/Chase Edit) - 本地数据，无需 API
# skills/premium-hotels/ 目录下按城市查询
```

### 景点 & 火车

```bash
# 中国景点 - flyai
flyai keyword-search --query "东京景点"

# 中国火车 - flyai
flyai search-train ...
```

## 项目结构

```
travel-hacking-toolkit/
├── .env.example          # API Key 模板 ⚠️ 需填写
├── .mcp.json             # MCP 服务器配置
├── CLAUDE.md             # AI 指令文件
├── skills/               # 各服务 Skill 文档
│   ├── fli/              # Google Flights (无需 key)
│   ├── flyai/            # 飞猪 (需要 key)
│   ├── serpapi/          # Google Hotels (需要 key)
│   └── premium-hotels/   # FHR/Chase Edit (无需 key)
├── data/                 # 本地数据
│   ├── hotel-chains.json     # 酒店集团
│   ├── fhr-properties.json   # FHR 酒店列表
│   ├── chase-edit-properties.json  # Chase Edit 酒店列表
│   └── alliances.json        # 航空联盟
└── scripts/
    └── setup.sh          # 安装脚本
```

## Skill 使用规则

| 场景 | 工具 |
|------|------|
| 国际机票 | `fli` |
| 中国国内机票/酒店/景点/火车 | `flyai` |
| 国际酒店 | SerpAPI |
| 高级酒店 (FHR/THC/Chase Edit) | `premium-hotels` 本地数据 |

**自动调用规则**:
- 询问机票 → 自动使用 `fli`
- 询问中国国内酒店/机票/景点 → 自动使用 `flyai`
- 询问国际酒店 → 自动使用 SerpAPI
- 询问 FHR/Chase Edit → 自动使用 `premium-hotels`

## v2 暂存功能

以下功能暂未实现：

- 积分/里程查询 (Seats.aero, AwardWallet)
- 积分转换比例查询
- 积分房搜索 (rooms.aero)
- 积分票计算器

## 注意事项

- Fli 不需要任何 API Key，直接可用
- FlyAI 和 SerpAPI 需要自行申请 API key
- Premium Hotels 使用本地 JSON 数据，无需网络请求
- 所有 API 都有用量限制，注意查看免费额度

## 许可

MIT License
