---
# This loads into every session (no paths:) because it's needed for
# classifying ANY new requirement in the weather system
---

# 需求分類系統 (Requirement Classification System)

## 🎯 核心目的

當用戶提出新的需求時，AI 需要立即識別它屬於哪一類。
根據類型，自動加載相應的規則指導進行提問和實施。

---

## 📊 五大需求類型

### 1️⃣ 數據擴展型 (Data Extension Type)

**定義**: 添加新的數據源或監測指標

**特徵**:
- 影響 Layer 1 (Skill) - 新的數據獲取
- 影響 Layer 4a (Config) - 新的數據字段
- 影響 Layer 4b (HTML) - 新的數據顯示

**例子** (~20 種):
```
• 增加監測城市 (Add monitoring city)
• 增加溫度單位 (Add temperature unit)
• 增加降水數據 (Add rainfall data)
• 增加風速數據 (Add wind speed)
• 增加濕度數據 (Add humidity)
• 增加紫外線指數 (Add UV index)
• 增加空氣質量指數 (Add AQI)
• 增加能見度 (Add visibility)
• 增加露點溫度 (Add dew point)
• 增加海拔氣壓 (Add sea level pressure)
... 更多
```

**規則文件**: `.claude/rules/data-extension-questions.md`

**標準問題**:
```
Q1: 新數據是什麼？
Q2: 數據源是什麼？(Open-Meteo / 第三方 API)
Q3: 影響哪些 Layer？
Q4: 需要警報嗎？
Q5: 如何顯示？(數字 / 圖表 / 指標)
```

---

### 2️⃣ 邏輯修改型 (Logic Modification Type)

**定義**: 改變系統的計算或分析邏輯

**特徵**:
- 影響 Layer 2 (Agent) - 分析邏輯
- 影響 Layer 3 (Command) - 配置參數
- 可能影響 Layer 4a (Config) - 新的閾值

**例子** (~15 種):
```
• 修改熱浪警報閾值 (Modify heat wave threshold)
• 修改冷警警報閾值 (Modify cold warning threshold)
• 添加新警報等級 (Add alert levels)
• 修改警報公式 (Modify alert calculation)
• 添加組合告警 (Add combined alerts)
• 修改警報優先級 (Modify alert priority)
• 添加趨勢分析 (Add trend analysis)
• 修改統計計算 (Modify statistics calculation)
• 添加預測功能 (Add forecasting)
... 更多
```

**規則文件**: `.claude/rules/logic-modification-questions.md`

**標準問題**:
```
Q1: 修改什麼邏輯？
Q2: 新的邏輯如何定義？
Q3: 影響哪些告警類型？
Q4: 如何向後相容？
Q5: 需要新的配置參數嗎？
```

---

### 3️⃣ 顯示修改型 (Display Modification Type)

**定義**: 改變用戶界面或數據顯示方式

**特徵**:
- 主要影響 Layer 4b (HTML)
- 可能影響 Layer 4a (Config) - 顯示設置
- 不影響數據或邏輯

**例子** (~20 種):
```
• 改變城市卡片佈局 (Modify city card layout)
• 添加新圖表類型 (Add chart types)
• 修改顏色方案 (Modify color scheme)
• 改變排序方式 (Change sorting)
• 添加城市搜索 (Add city search)
• 添加篩選功能 (Add filtering)
• 改變響應式設計 (Modify responsive design)
• 添加暗黑模式 (Add dark mode)
• 改變字體大小 (Modify font sizes)
• 添加圖標 (Add icons)
... 更多
```

**規則文件**: `.claude/rules/display-modification-questions.md`

**標準問題**:
```
Q1: 修改 HTML 的哪個部分？
Q2: 新設計是什麼樣的？
Q3: 是否需要新的配置選項？
Q4: 是否影響現有功能？
Q5: 需要測試哪些場景？
```

---

### 4️⃣ 集成型 (Integration Type)

**定義**: 與第三方服務或系統集成

**特徵**:
- 影響 Layer 1 (Skill) - 新的 API 或服務
- 可能影響所有層
- 需要處理認證和錯誤

**例子** (~25 種):
```
• 集成數據庫存儲 (Database integration)
• 集成郵件警報 (Email alerts)
• 集成短信警報 (SMS alerts)
• 集成 Slack 通知 (Slack integration)
• 集成 Webhook (Webhook support)
• 集成地圖服務 (Map services)
• 集成天氣符號 (Weather icons)
• 集成多語言 (Internationalization)
• 集成用戶認證 (User authentication)
• 集成數據導出 (Data export)
... 更多
```

**規則文件**: `.claude/rules/integration-questions.md`

**標準問題**:
```
Q1: 集成什麼外部服務？
Q2: 認證方式是什麼？
Q3: 如何處理失敗？
Q4: 需要新的 Skill 嗎？
Q5: 如何測試集成？
```

---

### 5️⃣ 優化型 (Optimization Type)

**定義**: 改進系統性能或可維護性

**特徵**:
- 不改變功能，只改進效率
- 影響範圍廣（可能涉及多層）
- 需要基準測試

**例子** (~20 種):
```
• 緩存優化 (Caching optimization)
• 查詢優化 (Query optimization)
• 渲染優化 (Render optimization)
• 代碼重構 (Code refactoring)
• 配置合併 (Config consolidation)
• 規則系統優化 (Rules system optimization)
• 文檔改進 (Documentation improvement)
• 測試覆蓋增加 (Test coverage)
• 構建優化 (Build optimization)
• 內存優化 (Memory optimization)
... 更多
```

**規則文件**: `.claude/rules/optimization-questions.md`

**標準問題**:
```
Q1: 優化什麼方面？
Q2: 目標是什麼？(速度 / 內存 / 可維護性)
Q3: 當前的基準是什麼？
Q4: 目標改進是多少？
Q5: 如何測量改進？
```

---

## 🔍 Part 2: 如何識別需求類型？

### 決策樹 (Decision Tree)

```
【新需求來了】

問題 1: 是否添加新數據？
  ├─ 是 → 數據擴展型 ✓
  └─ 否 → 問題 2

問題 2: 是否修改計算/分析邏輯？
  ├─ 是 → 邏輯修改型 ✓
  └─ 否 → 問題 3

問題 3: 是否只改變顯示？
  ├─ 是 → 顯示修改型 ✓
  └─ 否 → 問題 4

問題 4: 是否集成外部服務？
  ├─ 是 → 集成型 ✓
  └─ 否 → 問題 5

問題 5: 是否改進性能？
  ├─ 是 → 優化型 ✓
  └─ 否 → 【混合型】可能涉及多種
```

### 實施方式

```
【AI 的分類邏輯】

def classify_requirement(user_request: str) -> RequirementType:
    
    # 分析用戶請求的關鍵字
    keywords_map = {
        "data_extension": ["增加", "監測", "添加", "新數據", "城市"],
        "logic_modification": ["修改", "閾值", "警報", "計算", "規則"],
        "display_modification": ["顯示", "佈局", "顏色", "圖表", "卡片"],
        "integration": ["集成", "API", "服務", "連接", "導出"],
        "optimization": ["優化", "性能", "快", "效率", "重構"]
    }
    
    for req_type, keywords in keywords_map.items():
        if any(kw in user_request for kw in keywords):
            return req_type
    
    return "mixed"  # 可能是混合需求
```

---

## 📋 Part 3: 規則文件映射

### 規則文件結構

```
.claude/rules/
├── rules-system-architecture.md (這個文件)
│   └─ 解釋規則系統如何工作
│
├── requirement-classification.md (當前文件)
│   └─ 如何分類需求
│
└── [Type-specific rules]
    ├── data-extension-questions.md
    │   └─ 適用所有數據擴展需求
    │
    ├── logic-modification-questions.md
    │   └─ 適用所有邏輯修改需求
    │
    ├── display-modification-questions.md
    │   └─ 適用所有顯示修改需求
    │
    ├── integration-questions.md
    │   └─ 適用所有集成需求
    │
    └── optimization-questions.md
        └─ 適用所有優化需求

└── [Specific requirement checklists]
    ├── add-city-checklist.md (paths: [...])
    │   └─ 只在編輯特定文件時加載
    │
    ├── add-rainfall-feature-questions.md (paths: [...])
    │   └─ 懶加載
    │
    ├── add-aqi-monitoring-checklist.md (paths: [...])
    │   └─ 新需求創建的具體規則
    │
    ... 每個具體需求一個文件 ...
```

---

## 🔄 Part 4: 工作流程

### 第一次遇到類型的需求

```
【用戶請求】
"我想增加下雨機率"

【AI 分類】
↓ 分析請求
↓ 識別類型: 數據擴展型
↓ 加載 requirement-classification.md
↓ 加載 data-extension-questions.md

【AI 提問】
按照 data-extension-questions.md 的標準流程提問

【創建具體規則】
創建 .claude/rules/add-rainfall-feature-questions.md
保存具體的提問和實施步驟

【執行】
按照具體規則實施變更
```

### 第二次遇到相同類型的需求

```
【用戶請求】
"我想增加相對濕度監測"

【AI 分類】
↓ 分析請求
↓ 識別類型: 數據擴展型

【AI 加載規則】
加載 data-extension-questions.md
（複用之前建立的規則，無需重新思考）

【AI 提問】
使用相同的標準流程提問
（如果之前提過相同的問題，可以跳過）

【創建具體規則】
創建 .claude/rules/add-humidity-monitoring-checklist.md
但大部分邏輯複用之前的規則

【執行】
使用相似的實施步驟，只調整具體參數
```

---

## 🎯 Part 5: 實踐指南

### 如何使用這個分類系統

#### 對於 AI

```python
# 在處理新需求時
1. 加載 requirement-classification.md
2. 使用決策樹分類需求
3. 加載對應的[Type-specific rule]
4. 按照標準流程提問
5. 創建或複用[Specific checklist]
6. 執行變更
```

#### 對於用戶

```
只需說出需求，AI 自動：
✓ 分類需求
✓ 提問相關問題
✓ 執行實施
✓ 保存規則供未來使用
```

---

## 📊 統計：規則覆蓋

### 需求數量 vs 規則數量

```
需求類型      預計數量    規則文件數
───────────────────────────────
數據擴展        ~20        1 個類型規則
邏輯修改        ~15        1 個類型規則
顯示修改        ~20        1 個類型規則
集成            ~25        1 個類型規則
優化            ~20        1 個類型規則
───────────────────────────────
總計: 100 個需求    5 個類型規則

+ 具體需求規則 (按需創建)
  • 第 1 個需求: 創建規則 (~15 min)
  • 第 2-10 個需求: 複用規則 (~1-2 min 每個)
  • 第 11-100 個需求: 純執行 (~1 min 每個)

結果: 100 個需求只需 5 個核心規則 + 按需創建
```

---

## ✅ 驗證清單

- [ ] 能夠用決策樹分類新需求
- [ ] 存在 5 個類型規則文件
- [ ] 每個類型規則有標準問題
- [ ] 具體規則繼承自類型規則
- [ ] 規則文件正確使用 paths: 和懶加載
- [ ] AI 能自動選擇正確的規則
- [ ] 相同類型的需求複用規則
- [ ] 系統隨著需求增加而改進

---

## 🎓 總結

### 這個分類系統如何解決 100 種需求問題

```
❌ 問題: 100 種不同的需求
         每種都需要不同的提問方式

✅ 解決: 分類為 5 大類型
         每類用 1 個規則文件
         所有相同類型的需求複用規則

✅ 結果: 100 個需求
         5 個核心規則
         按需創建的具體規則
         完全可擴展且可維護
```

### 核心優勢

- **可擴展**: 新需求自動分類到現有規則
- **可維護**: 修改規則一次，影響該類所有需求
- **高效**: 相同類型的需求複用規則
- **學習**: AI 和人類都能從規則中學習
