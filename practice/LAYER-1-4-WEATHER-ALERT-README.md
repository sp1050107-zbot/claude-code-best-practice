# 天氣提醒助手 — Layer 1-4 完整演練

> **演練編號**：Weather Alert System v1.0  
> **學習者**：sp1050107-zbot | **背景**：DevOps 新手  
> **分支**：`practice/initial-setup` | **預計時間**：90 分鐘  
> **難度**：⭐⭐ 中等  

---

## 📋 演練簡述

通過建立「**天氣提醒助手**」系統，完整學習 Claude Code 的 4 層核心架構：

- **Layer 1**: 建立 Skill — 「獲取城市溫度」
- **Layer 2**: 建立 Agent — 「分析溫度並判斷提醒」
- **Layer 3**: 建立 Command — `/weather-alert` 命令
- **Layer 4**: 完整協調 — Command → Agent → Skill 工作流

---

## 🎯 最終效果

演練完成後，你將擁有：

```bash
# 執行命令
claude-code-best-practice main* ❯ /weather-alert

# 終端輸出（示例）
🌤️  Taipei: 28°C ✓ 正常
🌡️  Dubai: 42°C ⚠️  超過閾值 (>35°C)
💾 報告已保存: practice/weather-alert-report.html

# 打開報告
open practice/weather-alert-report.html
# 看到美化的 HTML 視覺化報告
```

---

## 🏗️ 系統架構

```
Layer 1: SKILL
└─ weather_fetcher_skill.md
   ├─ 功能：調用 Open-Meteo API 獲取城市溫度
   └─ 返回：{city, temp, unit, timestamp}

     ↓ (Layer 2 調用)

Layer 2: AGENT  
└─ weather_analyzer_agent.md
   ├─ 功能：分析溫度是否超過閾值
   ├─ 判斷：temp > 35°C 或 temp < 0°C
   └─ 返回：{city, temp, alert: true/false, reason}

     ↓ (Layer 3 調用)

Layer 3: COMMAND
└─ weather-alert.md
   ├─ 功能：協調工作流入口點
   ├─ 流程：讀配置 → 遍歷城市 → 呼叫 Agent → 生成報告
   └─ 輸出：終端日誌 + HTML 報告

     ↓

Layer 4: ORCHESTRATION (完整系統)
└─ 包含上述全部 + 進階功能
   ├─ 多城市支持
   ├─ 配置文件管理
   ├─ HTML 美化報告
   └─ 可定時執行
```

### 視覺架構圖

```
用户執行 /weather-alert
       ↓
   ┌─────────────────────────────┐
   │  Command (Layer 3)          │
   │  weather-alert.md           │
   │  - 讀取城市列表              │
   │  - 遍歷每個城市              │
   └─────────┬───────────────────┘
             ↓
   ┌─────────────────────────────┐
   │  Agent (Layer 2)            │
   │  weather_analyzer_agent.md  │
   │  - 調用 Skill               │
   │  - 分析溫度                  │
   │  - 判斷是否提醒              │
   └─────────┬───────────────────┘
             ↓
   ┌─────────────────────────────┐
   │  Skill (Layer 1)            │
   │  weather_fetcher_skill.md   │
   │  - HTTP 呼叫 Open-Meteo      │
   │  - 返回溫度數據              │
   └─────────┬───────────────────┘
             ↓
   ┌─────────────────────────────┐
   │  輸出                        │
   │  ✓ 終端日誌                  │
   │  ✓ HTML 報告                 │
   │  ✓ 數據文件                  │
   └─────────────────────────────┘
```

---

## 📂 文件結構

演練完成後的目錄結構：

```
practice/
├── LAYER-1-4-WEATHER-ALERT-README.md (本文件)
├── PRACTICE_GUIDE.md                  (整體指南)
│
├── layer-1-skill/
│   ├── notes.md                       (學習筆記)
│   ├── weather-fetcher-skill.md       (Skill 定義)
│   └── test-skill.py                  (測試代碼)
│
├── layer-2-agent/
│   ├── notes.md                       (學習筆記)
│   ├── weather-analyzer-agent.md      (Agent 定義)
│   └── test-agent.py                  (測試代碼)
│
├── layer-3-command/
│   ├── notes.md                       (學習筆記)
│   └── weather-alert.md               (Command 定義)
│
├── layer-4-orchestration/
│   ├── notes.md                       (學習筆記)
│   ├── weather-alert-complete.md      (完整工作流)
│   ├── config.json                    (配置文件)
│   ├── template.html                  (HTML 報告模板)
│   └── weather-alert-report.html      (生成的報告)
│
└── outputs/
    └── weather-data-*.json            (原始數據)
```

---

## 🎓 分層學習目標

### Layer 1: SKILL — 技能基礎（15 分鐘）

**學習目標**：
- ✓ 理解 Skill 的定義和配置
- ✓ 學會用 `WebFetch` 調用 API
- ✓ 理解 Skill 的輸入輸出

**具體任務**：
1. 讀懂 `best-practice/claude-skills.md` (5 分鐘)
2. 分析 `.claude/skills/weather-fetcher/SKILL.md` (3 分鐘)
3. 創建 `layer-1-skill/weather-fetcher-skill.md` (5 分鐘)
4. 寫筆記：`layer-1-skill/notes.md` (2 分鐘)

**Skill 功能**：
```markdown
# 功能
- 接收城市名稱（英文或座標）
- 調用 Open-Meteo API
- 返回當前溫度（攝氏度）

# 輸入
city: string (e.g., "Taipei", "Dubai")

# 輸出
{
  "city": "Taipei",
  "temperature": 28,
  "unit": "Celsius",
  "timestamp": "2026-08-17T10:00:00Z"
}
```

---

### Layer 2: AGENT — 獨立分析（15 分鐘）

**學習目標**：
- ✓ 理解 Agent 的隔離性和獨立性
- ✓ 學會在 Agent 中調用 Skill
- ✓ 理解 Agent 的決策邏輯

**具體任務**：
1. 讀懂 `best-practice/claude-subagents.md` (5 分鐘)
2. 分析 `.claude/agents/weather-agent.md` (3 分鐘)
3. 創建 `layer-2-agent/weather-analyzer-agent.md` (5 分鐘)
4. 寫筆記：`layer-2-agent/notes.md` (2 分鐘)

**Agent 功能**：
```markdown
# 功能
- 接收溫度數據
- 判斷是否超過閾值
- 生成提醒信息

# 判斷邏輯
- 溫度 > 35°C: 🌡️ 熱浪警報
- 溫度 < 0°C: ❄️ 寒冷警報
- 0-35°C: ✓ 正常

# 輸出
{
  "city": "Dubai",
  "temperature": 42,
  "alert": true,
  "alert_type": "heat_wave",
  "message": "🌡️ Dubai 溫度 42°C，超過閾值 35°C"
}
```

---

### Layer 3: COMMAND — 工作流入口（15 分鐘）

**學習目標**：
- ✓ 理解 Command 如何協調 Agent 和 Skill
- ✓ 學會設計工作流邏輯
- ✓ 理解前端控制

**具體任務**：
1. 讀懂 `best-practice/claude-commands.md` (5 分鐘)
2. 分析 `.claude/commands/weather-orchestrator.md` (3 分鐘)
3. 創建 `layer-3-command/weather-alert.md` (5 分鐘)
4. 寫筆記：`layer-3-command/notes.md` (2 分鐘)

**Command 功能**：
```markdown
# 功能
- 作為用户入口：/weather-alert
- 讀取預設城市列表（Taipei, Dubai）
- 逐一調用 Agent 進行分析
- 輸出結果到終端

# 流程
1. 讀取配置（城市列表、溫度閾值）
2. 遍歷每個城市
3. 為每個城市調用 Agent
4. 收集結果
5. 輸出到終端

# 輸出示例
🌤️  Taipei: 28°C ✓ 正常
🌡️  Dubai: 42°C ⚠️  超過閾值 (>35°C)
```

---

### Layer 4: ORCHESTRATION — 完整系統（30 分鐘）

**學習目標**：
- ✓ 理解完整的 Command → Agent → Skill 協調
- ✓ 學會生成 HTML 報告
- ✓ 理解可配置系統的設計

**具體任務**：
1. 讀懂 `orchestration-workflow/orchestration-workflow.md` (5 分鐘)
2. 分析完整的 Weather 工作流實現 (5 分鐘)
3. 建立配置文件 `layer-4-orchestration/config.json` (3 分鐘)
4. 建立 HTML 模板 `layer-4-orchestration/template.html` (7 分鐘)
5. 整合完整工作流 `layer-4-orchestration/weather-alert-complete.md` (5 分鐘)
6. 寫筆記和測試 (5 分鐘)

**進階功能**：
- ✓ 配置文件管理（cities, thresholds）
- ✓ HTML 美化報告（含圖表）
- ✓ 數據持久化（JSON 文件）
- ✓ 可擴展架構（易於添加新城市）

---

## ⏱️ 時間表

| 層級 | 任務 | 時間 | 完成指標 |
|-----|------|------|---------|
| **Layer 1** | Skill 開發 | 15分 | 能調用 API 獲取溫度 |
| **Layer 2** | Agent 開發 | 15分 | 能分析溫度並判斷 |
| **Layer 3** | Command 開發 | 15分 | 能執行 `/weather-alert` 命令 |
| **Layer 4** | 完整協調 | 30分 | 能生成 HTML 報告 |
| **文檔/複習** | 筆記和測試 | 15分 | 完成所有筆記 |
| | **總計** | **90分** | |

---

## 🔧 技術棧

| 組件 | 技術 | 備註 |
|-----|------|------|
| **API** | Open-Meteo | 免費，無需 key |
| **HTTP 客户端** | WebFetch / Python requests | Claude Code 內建 |
| **配置** | JSON | 簡單明瞭 |
| **報告** | HTML + CSS | 視覺化展示 |
| **數據** | JSON 文件 | 本地存儲 |

---

## 🚀 執行步驟概覽

### 第一步：建立目錄結構
```bash
mkdir -p practice/layer-{1,2,3,4}-{skill,agent,command,orchestration}
mkdir -p practice/outputs
```

### 第二步：Layer 1 → Layer 4 依次實現
每層包含：
1. 讀懂相關文檔
2. 分析現有實現
3. 創建自己的版本
4. 寫學習筆記

### 第三步：測試和驗證
```bash
# Layer 1: 測試 Skill 能否獲取溫度
# Layer 2: 測試 Agent 能否分析數據
# Layer 3: 測試 Command 能否協調流程
# Layer 4: 測試完整系統，查看 HTML 報告
```

### 第四步：提交練習
```bash
git add practice/layer-*
git commit -m "practice(weather-alert): complete layer 1-4 implementation"
git push origin practice/initial-setup -o no-repo-suggestions
```

---

## 📝 關鍵概念速查

### Skill（技能）
- **位置**：`.claude/skills/<name>/SKILL.md`
- **特點**：可復用、無狀態、接收輸入返回輸出
- **本演練**：`weather-fetcher` — 調用 API 獲取數據

### Agent（代理）
- **位置**：`.claude/agents/<name>.md`
- **特點**：獨立執行、有決策邏輯、可調用 Skills
- **本演練**：`weather-analyzer` — 分析數據並判斷

### Command（命令）
- **位置**：`.claude/commands/<name>.md`
- **特點**：用户入口、協調工作流、可交互
- **本演練**：`/weather-alert` — 用户觸發的命令

### Orchestration（協調）
- **概念**：Command → Agent → Skill 的完整鏈條
- **特點**：多層協作、信息流動、系統整合
- **本演練**：完整的天氣提醒系統

---

## ✅ 成功標準

演練完成時，你應該能夠：

- [ ] 理解 Skill 的定義和作用
- [ ] 理解 Agent 的隔離性和協調
- [ ] 理解 Command 如何組織工作流
- [ ] 實現完整的 4 層系統
- [ ] 生成功能性的 HTML 報告
- [ ] 解釋為什麼需要這 4 層分離

---

## 📚 參考文件

- `CLAUDE.md` — 項目總體指南
- `best-practice/claude-skills.md` — Skill 詳解
- `best-practice/claude-subagents.md` — Agent 詳解
- `best-practice/claude-commands.md` — Command 詳解
- `orchestration-workflow/orchestration-workflow.md` — 工作流詳解
- `orchestration-workflow/orchestration-workflow.svg` — 架構圖

---

## 💡 學習技巧

1. **邊讀邊寫** — 用 `notes.md` 記錄關鍵概念
2. **對比分析** — 把現有實現和你的實現對比
3. **逐層測試** — 不要等全部完成，每層都測試
4. **提出問題** — 不懂的地方先記下，後面逐層解答

---

## 🎯 下一步

準備好開始了嗎？

確認以下事項：
- [ ] 理解 4 層架構
- [ ] 接受 90 分鐘時間分配
- [ ] 準備好 Python + HTTP 環境

**請確認：你準備好開始 Layer 1 的演練嗎？**（Y/N）

一旦確認，我會：
1. ✓ 帶你完成 Layer 1 的完整實現
2. ✓ 邊做邊講解核心概念
3. ✓ 逐層推進到 Layer 4
4. ✓ 生成最終的天氣提醒系統

---

## 📞 提問

如果有任何疑問或想調整計劃，現在告訴我！

**準備好開始嗎？** 🚀
