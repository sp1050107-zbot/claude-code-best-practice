---
paths:
  - ".claude/commands/weather-alert.md"
  - "practice/layer-4-orchestration/config.json"
  - "practice/layer-4-orchestration/weather-alert-report.html"
---

# 添加下雨機率功能 - AI 智能問詢流程

當用戶請求"增加地區下雨機率"時，AI MUST 遵循此問詢流程。

## 🤖 AI 的分階段問詢

### Phase 1: 需求澄清（必須）

#### Q1.1 數據類型
```
用戶說: "增加下雨機率"

AI 問:
❓ "下雨機率"具體是指什麼？

  a) 📊 降水概率 (0-100% 百分比)
  b) 📈 降水等級 (無雨/小雨/中雨/大雨)
  c) 💧 降水量 (毫米)
  d) 🚨 降水警報 (是/否)
  e) 其他?

例子:
  • 台北: 45% 降水概率
  • 迪拜: 5% 降水概率
  • 東京: 68% 降水概率
```

#### Q1.2 顯示位置
```
AI 問:
❓ 這個信息應該在哪裡顯示？

  a) 📍 城市卡片內 (與溫度並行)
     ┌─ Taipei
     ├─ 🌡️ 29.1°C
     ├─ ☔ 45% 下雨
     └─ 🌤️ Normal
  
  b) 📊 單獨的降雨卡片
  c) 📈 統計摘要中
  d) 🎨 HTML 側邊欄
  e) 多個位置?

用戶選擇: __________
```

#### Q1.3 告警需求
```
AI 問:
❓ 是否需要降雨警報？

  a) ❌ 否，僅顯示數據
  b) ✅ 是，單一閾值
     • 超過 70% 時觸發"降雨預警"
  c) ✅ 是，多個閾值
     • > 50% = 中等降雨概率
     • > 80% = 高降雨風險

用戶選擇: __________
```

---

### Phase 2: 架構影響（關鍵）

#### Q2.1 數據源
```
AI 問:
❓ 降水數據從哪裡來？

  a) 📡 現有 API (Open-Meteo 已支持降水數據)
     → 不需要新 Skill，在 weather-fetcher 中擴展
  
  b) 🔗 第三方 API (如 WeatherAPI, DarkSky)
     → 需要創建新的 Skill
  
  c) 📊 用戶手動輸入
     → 需要新的 Config 字段

用戶選擇: __________

推薦: Option A (Open-Meteo 已支持)
```

#### Q2.2 Layer 1 - Skill 層
```
AI 問:
❓ Skill 層應該怎樣實現？

  a) 擴展現有 skill (weather-fetcher)
     文件: .claude/skills/weather-fetcher/SKILL.md
     修改: 添加 getRainfallProbability() 函數
  
  b) 創建新 skill (rainfall-fetcher)
     文件: .claude/skills/rainfall-fetcher/SKILL.md
     內容: 專門獲取降雨數據

推薦: Option A (保持簡潔)

如選 A:
  - weather-fetcher 返回: { temperature, rainfall_probability }
  - 無需修改 Skill 名稱或簽名
```

#### Q2.3 Layer 2 - Agent 層
```
AI 問:
❓ Agent 層應該怎樣實現？

  a) 擴展現有 agent (weather-analyzer-agent)
     分析: 溫度 + 下雨機率
     邏輯: 
       • 溫度 > 35°C → heat_wave
       • 降雨 > 70% → rainfall_alert
       • 同時 > 35°C 且 > 70% → extreme_conditions
  
  b) 創建新 agent (rainfall-analyzer-agent)
     職責: 僅分析降雨，與溫度分開

推薦: Option A (統一分析)

新的分析邏輯:
{
  "temperature": 29.1,
  "rainfall_probability": 45,
  "alerts": {
    "heat_wave": false,
    "rainfall_alert": false,
    "conditions": "normal"
  }
}
```

#### Q2.4 Layer 3 - Command 層
```
AI 問:
❓ Command 層應該怎樣修改？

  a) ✅ 修改現有 /weather-alert
     → 自動包含降雨數據
     → 用戶體驗: "增加下雨機率" 就是擴展
  
  b) 創建新命令 /rainfall-alert
     → 獨立的降雨監控
     → 用戶體驗: 需要運行兩個命令

推薦: Option A (統一命令)

修改:
  cities: ["Taipei", "Dubai", "Tokyo", "Seoul", "Bangkok"]
  thresholds: {
    heat_wave: 35,
    rainfall_alert: 70,  // ← 新增
    cold_warning: 0
  }
```

#### Q2.5 Layer 4a - Config 層
```
AI 問:
❓ config.json 應該怎樣擴展？

在每個城市對象中添加:

{
  "name": "Taipei",
  "latitude": 25.033,
  "longitude": 121.5654,
  "timezone": "Asia/Taipei",
  "rainfall_threshold": 70,  // ← 新增
  "enabled": true
}

或者在頂層添加全局設置:

{
  "thresholds": {
    "heat_wave": 35,
    "rainfall_alert": 70,  // ← 新增
    "cold_warning": 0
  }
}

推薦: 兩者都加 (全局 + 可覆寫)
```

#### Q2.6 Layer 4b - HTML 層
```
AI 問:
❓ HTML 報告應該怎樣修改？

選項 A: 在城市卡片中添加降雨信息
┌─────────────────────┐
│ Taipei              │
│ 🌡️ 29.1°C           │
│ ☔ 45% 下雨          │ ← 新
│ 🌤️ Normal           │
└─────────────────────┘

選項 B: 添加降雨概況卡片
┌─────────────────────┐
│ ☔ 降雨概況          │ ← 新卡片
│                     │
│ Taipei: 45%         │
│ Dubai: 5%           │
│ Tokyo: 68%          │
│ Seoul: 30%          │
│ Bangkok: 52%        │
└─────────────────────┘

選項 C: 兩者都加

推薦: Option C (完整信息)
```

---

### Phase 3: 驗證策略（必須）

#### Q3.1 新增驗證項目
```
AI 問:
❓ verify-weather-layers.sh 應該檢查什麼？

新增檢查:

✓ 降雨數據完整性
  - 所有 enabled 城市都有 rainfall_probability 值
  - 數值範圍有效 (0-100%)

✓ 閾值一致性
  - config.json 的 rainfall_alert 阈值
  - HTML 統計中的閾值一致

✓ HTML 完整性
  - 所有城市卡片都顯示降雨機率
  - 降雨卡片（如果有）數據正確

✓ 告警邏輯
  - 降雨 > 70% 的城市標記為警報
  - 熱浪 + 降雨同時觸發時的邏輯正確

新的檢查指令:
  grep -c '"rainfall_probability"' config.json
  grep '"rainfall_alert"' weather-alert-report.html | wc -l
  // 等等
```

---

### Phase 4: 實施計畫（最終）

#### Q4.1 變更順序
```
AI 總結應該的實施順序:

Step 1: 擴展 weather-fetcher Skill
  文件: .claude/skills/weather-fetcher/SKILL.md
  操作: 添加 getRainfallProbability() 功能

Step 2: 擴展 weather-analyzer-agent
  文件: .claude/agents/weather-analyzer-agent.md
  操作: 添加降雨分析邏輯

Step 3: 擴展 weather-alert Command
  文件: .claude/commands/weather-alert.md
  操作: 添加降雨閾值配置

Step 4: 擴展 config.json
  文件: practice/layer-4-orchestration/config.json
  操作: 添加 rainfall_alert 閾值和各城市配置

Step 5: 更新 HTML 報告
  文件: weather-alert-report.html
  操作: 
    - 在城市卡片中添加降雨顯示
    - 添加新的降雨概況卡片
    - 更新統計摘要

Step 6: 改進驗證腳本
  文件: scripts/verify-weather-layers.sh
  操作: 添加降雨數據的驗證項目

Step 7: 測試
  執行: /weather-alert (應該包含所有降雨數據)
```

---

## 📝 AI 的完整提問模板

```
用戶: "我想增加地區下雨機率功能"

AI 的回應應該包含:

✅ Phase 1 回應 (實時，要求澄清)
  "我注意到這個需求會影響多個 Layer。
   讓我問幾個問題確保實現正確:
   
   Q1: 下雨機率的數據類型是？(a) 百分比 (b) 等級 ...
   Q2: 顯示位置是？(a) 城市卡片 (b) 獨立卡片 ...
   Q3: 需要告警嗎？(a) 否 (b) 是 ..."

✅ Phase 2 回應 (基於答案，提出架構建議)
  "根據您的回答，這個需求會影響:
   
   Layer 1 (Skill): 擴展 weather-fetcher ✓
   Layer 2 (Agent): 擴展 weather-analyzer-agent ✓
   Layer 3 (Command): 修改 weather-alert ✓
   Layer 4a (Config): 添加 rainfall_alert 字段 ✓
   Layer 4b (HTML): 更新城市卡片和統計 ✓"

✅ Phase 3 回應 (驗證策略)
  "為了確保質量，我會:
   
   1. 在每個 Step 後運行驗證
   2. 檢查降雨數據完整性
   3. 驗證閾值一致性
   4. 確保 HTML 顯示正確"

✅ Phase 4 回應 (最終確認)
  "實施計畫已準備好。
   
   總共需要修改 6 個文件，涉及 5 個 Layer。
   
   準備開始嗎？[Y/n]"
```

---

## 🎓 為什麼 AI 應該這樣問

| 問詢方式 | 好處 |
|---------|------|
| 提前澄清需求 | 避免實現錯誤方向 |
| 識別架構影響 | 發現跨層依賴 |
| 提出驗證策略 | 確保質量 |
| 透明化過程 | 用戶理解複雜性 |
| 主動提建議 | 減少用戶決策負擔 |

---

## ✨ 模式總結

**好的 AI 做法:**
```
用戶: "增加下雨機率"
AI: "這涉及 5 個 Layer。讓我問幾個問題..."
用戶: 回答問題
AI: "根據您的回答，計畫是..."
AI: 執行實施
AI: 驗證結果
結果: 完美實現，用戶滿意
```

**差的 AI 做法:**
```
用戶: "增加下雨機率"
AI: "好的，開始實現"
AI: [開始修改，不知道細節]
結果: 實現不對，需要修改，浪費時間
```
