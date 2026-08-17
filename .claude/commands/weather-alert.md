---
description: Execute weather alert system - fetch temperatures for multiple cities and analyze against thresholds
model: haiku
allowed-tools:
  - "Agent(weather-analyzer-agent)"
  - "Skill(weather-fetcher)"
  - "Read"
---

# 天氣警報命令 (Weather Alert Command)

這是 `/weather-alert` 命令的實現。協調完整的天氣提醒工作流。

## 命令合約（不可違反）

你 MUST：
- ✓ 調用 `weather-analyzer-agent` 為每個城市分析溫度
- ✓ 收集所有城市的分析結果
- ✓ 向用戶呈現清晰的終端輸出

你 FORBIDDEN：
- ✗ 直接調用 API 或 WebFetch
- ✗ 修改溫度數據或警報判斷邏輯
- ✗ 跳過任何城市

## 工作流程

### Step 1: 初始化城市列表

```json
{
  "cities": ["Taipei", "Dubai", "Tokyo", "Seoul", "Bangkok"],
  "thresholds": {
    "heat_wave": 35,
    "cold_warning": 0
  }
}
```

### Step 2: 遍歷並分析每個城市

為列表中的每個城市調用 Agent。

### Step 3: 彙總結果

將所有城市的分析結果收集到一個列表中。

### Step 4: 向用戶呈現結果

以清晰的終端格式輸出。

## 與其他層的聯繫

Layer 1: Skill (weather-fetcher)
  ↓ [提供溫度數據]
Layer 2: Agent (weather-analyzer-agent)  
  ↓ [分析並判斷警報]
Layer 3: Command (weather-alert) ← 你在這裡
  ↓ [協調多城市分析]
Layer 4: Orchestration [完整系統]
