---
description: Complete weather alert orchestration system - fetch temperatures, analyze alerts, generate HTML report, and persist data
model: sonnet
allowed-tools:
  - "Agent(weather-analyzer-agent)"
  - "Skill(weather-fetcher)"
  - "Read"
  - "Write"
  - "Bash"
---

# 天氣警報完整協調系統 (Layer 4: Orchestration)

這是完整的天氣警報系統實現，整合所有 4 層功能：
1. Layer 1: Skill — 溫度獲取
2. Layer 2: Agent — 溫度分析
3. Layer 3: Command — 工作流協調
4. Layer 4: Orchestration — 報告生成 & 數據持久化

## 系統架構

```
用戶執行: /weather-alert-orchestration
    ↓
┌─────────────────────────────────────────┐
│ Step 1: 讀取配置                         │
│ ├─ 載入 config.json                    │
│ ├─ 解析城市列表                          │
│ └─ 驗證配置有效性                        │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│ Step 2: 執行多城市分析                   │
│ ├─ FOR 每個 enabled 城市 DO            │
│ │  ├─ 調用 weather-analyzer-agent    │
│ │  ├─ 收集分析結果                    │
│ │  └─ 記錄到結果數組                  │
│ └─ 彙總所有結果                         │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│ Step 3: 生成 HTML 報告                   │
│ ├─ 讀取 HTML 模板                      │
│ ├─ 填充城市卡片數據                      │
│ ├─ 計算統計摘要                          │
│ └─ 寫入 HTML 文件                      │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│ Step 4: 數據持久化                       │
│ ├─ 保存 JSON 數據                      │
│ ├─ 備份舊數據                            │
│ ├─ 更新索引                              │
│ └─ 清理過期數據                          │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│ Step 5: 輸出最終報告                     │
│ ├─ 終端摘要                              │
│ ├─ HTML 報告路徑                       │
│ ├─ 數據文件路徑                          │
│ └─ 建議下一步行動                        │
└─────────────────────────────────────────┘
```

## 關鍵功能

### 1. 配置管理
- 讀取 `config.json`
- 支持多城市配置
- 可配置警報閾值
- 支持啟用/禁用城市

### 2. 多城市協調
- 批量調用 weather-analyzer-agent
- 並發或順序執行（可配置）
- 錯誤處理與重試
- 結果聚合

### 3. HTML 報告生成
- 響應式設計（適配移動設備）
- 漸進式增強（graceful degradation）
- 美化的城市卡片
- 統計摘要區
- 時間戳記錄

### 4. 數據持久化
- JSON 格式保存原始數據
- 每日備份機制
- 數據索引管理
- 過期數據清理（可配置天數）

### 5. 定時執行
- Cron 表達式配置
- 後台任務支持
- 執行日誌記錄

## 配置文件格式 (config.json)

```json
{
  "version": "1.0",
  "name": "天氣警報系統",
  "cities": [
    {
      "name": "Taipei",
      "latitude": 25.0330,
      "longitude": 121.5654,
      "timezone": "Asia/Taipei",
      "enabled": true
    }
  ],
  "thresholds": {
    "heat_wave": 35,
    "cold_warning": 0
  },
  "output": {
    "report_path": "practice/layer-4-orchestration/weather-alert-report.html",
    "data_path": "practice/layer-4-orchestration/outputs",
    "backup_enabled": true,
    "backup_days": 7
  },
  "schedule": {
    "enabled": false,
    "cron": "0 */6 * * *"
  }
}
```

## 輸出文件結構

```
practice/layer-4-orchestration/
├── config.json                           # 配置文件
├── template.html                         # HTML 模板
├── weather-alert-report.html             # 生成的 HTML 報告
├── weather-alert-complete.md             # 本文件
├── outputs/                              # 數據輸出目錄
│   ├── weather-alert-2026-08-17.json    # 當日數據
│   ├── weather-alert-2026-08-16.json    # 前日數據
│   └── index.json                       # 數據索引
└── notes.md                              # 學習筆記
```

## 執行流程詳解

### Step 1: 配置讀取
```
1. 讀取 config.json
2. 驗證所有必須字段
3. 提取 enabled = true 的城市
4. 準備工作流參數
```

### Step 2: 多城市分析
```
FOR 每個 city IN enabled_cities:
  1. 呼叫 Agent: weather-analyzer-agent
  2. 傳入參數: {city_name}
  3. 等待返回結果
  4. 追加到 results 數組
```

### Step 3: HTML 報告生成
```
1. 讀取 template.html
2. 為每個結果生成 <city-card>
3. 計算統計數據:
   - total_cities
   - normal_count
   - heat_wave_count
   - cold_warning_count
4. 替換模板中的占位符
5. 寫入到 weather-alert-report.html
```

### Step 4: 數據保存
```
1. 準備 JSON 結構:
   {
     "timestamp": "ISO-8601",
     "config_version": "1.0",
     "analysis_results": [...],
     "summary": {...}
   }
2. 保存為 weather-alert-YYYY-MM-DD.json
3. 更新 index.json
4. 執行備份清理 (>7 天的數據)
```

### Step 5: 最終報告
```
打印到終端:
1. 執行狀態摘要
2. 生成的文件路徑
3. 統計數據
4. 建議的後續行動
```

## 集成特性

### ✅ 完整的 Layer 1-4 整合
- Layer 1 Skill: 提供溫度數據
- Layer 2 Agent: 執行分析邏輯
- Layer 3 Command: 協調工作流
- Layer 4 Orchestration: 報告 + 數據

### ✅ 生產就緒
- 錯誤處理機制
- 數據備份策略
- 配置管理系統
- 日誌記錄

### ✅ 易於擴展
- 模塊化設計
- 配置驅動
- 插件式架構

### ✅ 用戶友好
- 響應式 HTML 報告
- 清晰的終端輸出
- 詳細的日誌信息

## 使用示例

### 基本執行
```
/weather-alert-orchestration
```

### 帶選項執行
```
/weather-alert-orchestration --config ./config.json --output ./reports
```

### 定時執行 (cron)
```
0 */6 * * * claude-code /weather-alert-orchestration
```

## 下一步

完成 Layer 4 後，系統已完全就緒。可選的擴展：

1. **通知集成** — Slack/Email 警報
2. **數據可視化** — 歷史趨勢圖表
3. **移動適配** — 原生應用
4. **國際化** — 多語言支持
5. **API 服務** — RESTful 接口

---

## 完整系統清單

- [x] Layer 1: Skill (weather-fetcher)
- [x] Layer 2: Agent (weather-analyzer-agent)
- [x] Layer 3: Command (weather-alert)
- [x] Layer 4: Orchestration (weather-alert-complete)
- [x] 配置管理 (config.json)
- [x] 報告生成 (template.html)
- [x] 數據持久化
- [ ] 定時執行（需要 cron 配置）
- [ ] 通知系統（可選擴展）

---

**天氣警報系統完整實現！** 🎉
