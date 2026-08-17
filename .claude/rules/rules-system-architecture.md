---
# This rule file loads into EVERY session (no paths:) because it explains
# the rules system itself - foundational knowledge
---

# `.claude/rules/` 系统架構 (Rules System Architecture)

## 🎯 Part 1: 官方定義 - `.claude/rules/` 是什麼？

### 定義（來自 CLAUDE.md）

```
".claude/rules/*.md with `paths:` YAML frontmatter are lazy-loaded 
only when Claude touches matching files; without frontmatter they 
load into every session like CLAUDE.md"
```

### 簡化解釋

`.claude/rules/` 是一個**智能指導系統**：

```
規則文件 (.claude/rules/*.md)
    ↓
包含 YAML frontmatter (paths: [...])
    ↓
根據觸發條件 lazy-load
    ↓
AI 按照規則提供指導
```

### 兩種規則文件類型

| 類型 | 文件 | 加載方式 | 何時應用 |
|------|------|--------|--------|
| **全局規則** | `CLAUDE.md` | 每次會話 | 所有工作 |
| **條件規則** | `add-city-checklist.md` | Lazy-load (paths:) | 編輯特定文件時 |

---

## 🤖 Part 2: AI 怎麼知道要在這裡準備？

### 信息流（Information Flow）

**第一次（初始設置）：**

```
【Session 1: 用戶提出新需求】

用戶說: "增加地區"
    ↓
AI 加載 CLAUDE.md
    ↓
AI 讀到: "使用 .claude/rules/ 來指導複雜變更"
    ↓
AI 思考:
  "這個需求複雜嗎？"
  "需要涉及多個 Layer 嗎？"
  "→ 是的"
    ↓
AI 決定: 創建 .claude/rules/add-city-checklist.md
    ↓
【創建規則文件】
  - 定義完整的提問流程
  - 指定適用的 paths:
  - 提供實施檢查清單
    ↓
【執行規則】
  - 遵循規則中的提問流程
  - 完成所有修改
  - 驗證一致性
```

**第二次及以後（重複使用）：**

```
【Session 2: 用戶說"增加 Bangkok"】

用戶說: "增加 Bangkok"
    ↓
AI 檢查: 有沒有現存的規則？
    ↓
發現: .claude/rules/add-city-checklist.md 存在
    ↓
AI 加載該規則
    ↓
AI 按照規則執行（無需重新思考）
    ↓
【立即執行】 ← 更快、更一致
```

### 關鍵洞察

```
❌ AI 不是通過"自動檢測"知道的
✅ AI 是通過"項目文檔指導"知道的

信息來源順序:
  1. CLAUDE.md (最高優先級)
  2. 相關的 .claude/rules/*.md
  3. 項目中的示例
  4. 用戶的明確指示
```

---

## 🚀 Part 3: 100 種需求問題 - 如何處理？

### 挑戰

```
如果有 100 種不同的變更需求:
  • 增加地區
  • 增加數據字段
  • 修改警報閾值
  • 添加新 Layer
  • 集成第三方服務
  ... 等等 100 種

AI 怎麼知道每一種應該如何提問？

❌ 為每種創建單獨的規則文件？
   → 這樣會有 100 個文件，難以維護

✅ 使用"元規則系統"
   → 定義規則的規則
   → 定義提問的提問
   → 定義流程的流程
```

### 解決方案：元規則系統 (Meta-Rules System)

#### 第 1 層：全局規則 (CLAUDE.md)
```
定義: 什麼時候該用規則系統
```

#### 第 2 層：規則模板 (.claude/rules/requirement-classification.md)
```
定義: 如何分類不同的需求

需求類型分類:
  1. 數據擴展型 (增加地區/字段)
  2. 邏輯修改型 (改變警報規則)
  3. 顯示修改型 (改變 UI/報告)
  4. 集成型 (連接新服務)
  5. 性能優化型 (改善效率)
```

#### 第 3 層：類型專用規則 (.claude/rules/data-extension-questions.md)
```
定義: 對於"數據擴展"類型，應該問什麼

適用範圍:
  - 增加地區
  - 增加數據字段
  - 添加新城市
  - 擴展監控指標

標準問題:
  Q1: 新數據是什麼？
  Q2: 影響哪些 Layer？
  Q3: 需要修改哪些文件？
  Q4: 如何驗證？
```

#### 第 4 層：特定需求規則 (.claude/rules/add-city-checklist.md)
```
定義: 對於"增加地區"這個具體需求，應該:
  - 問什麼具體問題
  - 修改哪些具體文件
  - 如何具體驗證
```

### 視覺化：規則系統層級

```
【全局決策】
CLAUDE.md
  ↓
  "這是複雜的專案結構變更嗎？"
  ├─ 否 → 直接執行
  └─ 是 → 使用規則系統
        ↓
【需求分類】
requirement-classification.md
  ↓
  "這屬於哪一類需求？"
  ├─ 數據擴展型 → data-extension-questions.md
  ├─ 邏輯修改型 → logic-modification-questions.md
  ├─ 顯示修改型 → display-modification-questions.md
  ├─ 集成型 → integration-questions.md
  └─ 優化型 → optimization-questions.md
        ↓
【類型專用提問】
[Type-specific-questions.md]
  ↓
  標準提問流程
        ↓
【具體規則】
[specific-requirement-checklist.md]
  ↓
  對話、執行、驗證
```

---

## 📋 Part 4: 實踐 - 如何構建支持 100 種需求的系統

### Step 1: 分類需求（2-3 小時）

```
分析項目中所有可能的變更需求:

【數據擴展型】(~20 種)
  • 增加監測城市
  • 增加溫度單位
  • 增加降水數據
  • 增加風速數據
  • 增加濕度數據
  ... 等等

【邏輯修改型】(~15 種)
  • 修改警報閾值
  • 修改計算公式
  • 添加新告警級別
  ... 等等

【顯示修改型】(~20 種)
  • 改變城市卡片佈局
  • 添加新圖表
  • 修改顏色方案
  ... 等等

【集成型】(~25 種)
  • 集成第三方 API
  • 添加數據庫存儲
  • 集成警報服務
  ... 等等

【優化型】(~20 種)
  • 緩存優化
  • 查詢優化
  • 渲染優化
  ... 等等
```

### Step 2: 創建類型規則（每類 1-2 小時）

```
對於每個類型，創建規則文件:

.claude/rules/
├── requirement-classification.md
│   └─ 定義 5 大類型 + 識別邏輯
│
├── data-extension-questions.md
│   └─ 適用所有數據擴展需求
│   └─ 標準問題模板
│
├── logic-modification-questions.md
│   └─ 適用所有邏輯修改需求
│   └─ 標準檢查清單
│
├── display-modification-questions.md
│   └─ 適用所有 UI 修改需求
│   └─ 標準驗證步驟
│
├── integration-questions.md
│   └─ 適用所有第三方集成
│   └─ 標準集成檢查
│
└── optimization-questions.md
    └─ 適用所有性能優化
    └─ 基準測試清單
```

### Step 3: 創建具體規則（按需 15-30 分鐘）

```
當用戶提出新的具體需求時:

1. AI 識別類型 → 加載對應的類型規則
2. 類型規則指導 → 標準提問流程
3. 根據回答 → 創建具體規則文件
   
例:
  用戶: "增加相對濕度監測"
  ↓
  識別: 數據擴展型
  ↓
  加載: data-extension-questions.md
  ↓
  提問: 遵循標準問題
  ↓
  創建: .claude/rules/add-humidity-monitoring-checklist.md
  ↓
  執行: 按照具體規則
```

---

## 🎯 Part 5: 規則系統的完整工作流

### 完整示例：用戶提出第 100 個需求

```
【用戶請求】
用戶: "我想添加 AQI (空氣質量指數) 監測功能"

【AI 的思考過程】
Step 1: 這是複雜變更嗎？
  ✓ 是 → 使用規則系統
  
Step 2: 加載分類規則
  ✓ 加載 requirement-classification.md
  ✓ 識別: 這是"數據擴展型" + "集成型"混合
  
Step 3: 加載類型規則
  ✓ 加載 data-extension-questions.md
  ✓ 加載 integration-questions.md
  
Step 4: 執行標準提問
  ❓ "AQI 的數據源是什麼？"
  ❓ "需要修改哪些 Layer？"
  ❓ "如何驗證集成？"
  
Step 5: 根據回答創建具體規則
  ✓ 創建 .claude/rules/add-aqi-monitoring-checklist.md
  ✓ 定義具體的實施步驟
  
Step 6: 執行
  ✓ 按照具體規則實施
  ✓ 驗證所有 Layer 同步
  
【結果】
✅ 新功能完整實現
✅ 規則文件被保存
✅ 下次用戶再提同樣需求時
   AI 直接加載規則，無需重新思考
```

---

## 💡 Part 6: 規則系統的三個關鍵概念

### 概念 1: 懶加載 (Lazy Loading)

```
❌ 加載所有 100 個規則文件到每次會話
   → 上下文浪費
   → 不相關的規則造成干擾

✅ 只加載相關規則
   paths: [".claude/commands/weather-alert.md", "config.json"]
   
   這樣規則只在編輯相關文件時加載
   ✓ 節省上下文
   ✓ 減少干擾
   ✓ 提高效率
```

### 概念 2: 規則層級 (Rule Hierarchy)

```
全局規則 (指導 100% 項目)
    ↓
類型規則 (指導特定類型的需求)
    ↓
具體規則 (指導特定的單一需求)

層級越低 → 越具體 → 越有效
```

### 概念 3: 規則複用 (Rule Reuse)

```
第 1 個數據擴展需求:
  • 創建規則
  • 實施變更
  ✓ 規則被保存

第 2 個數據擴展需求:
  • 加載第 1 個規則
  • 因為流程相同，可直接複用
  ✓ 無需重新思考

第 100 個數據擴展需求:
  • 100% 利用現存規則
  • 0 分鐘思考時間
  ✓ 純粹執行
```

---

## 📊 Part 7: 為什麼這個系統能處理無限多的需求

### 當前狀態（無規則系統）

```
需求數量: 1 個
AI 工作: 100% (思考 + 執行)
耗時: 30 分鐘

需求數量: 100 個
AI 工作: 100% × 100 = 10,000% (全部重新思考)
耗時: 3000 分鐘 (50 小時!)
```

### 規則系統狀態

```
需求數量: 1 個
AI 工作: 100% (思考 + 執行)
耗時: 30 分鐘

需求數量: 2-10 個
AI 工作: 30% + 100% (思考 1 次 + 執行 10 次)
耗時: 10 分鐘 + 300 分鐘

需求數量: 100 個
AI 工作: 30% + 100% (思考 5 類 + 執行 100 次)
耗時: 150 分鐘 + 3000 分鐘

相同流程的需求: 只需 10 分鐘 (純執行，無思考)
```

### 數學模型

```
【無規則系統】
總時間 = N × (思考時間 + 執行時間)
       = 100 × (20 分鐘 + 10 分鐘)
       = 3000 分鐘

【規則系統】
總時間 = (分類時間) + (創建規則時間) + N × (執行時間)
       = 50 分鐘 + (5類 × 30分鐘) + 100 × (10 分鐘)
       = 50 + 150 + 1000
       = 1200 分鐘

節省: 2000 分鐘 (60% 減少)
```

---

## ✅ Part 8: 如何驗證系統有效

### 檢查清單

- [ ] CLAUDE.md 包含規則系統說明
- [ ] 存在 requirement-classification.md
- [ ] 至少 5 個類型規則文件
- [ ] 每個新需求創建具體規則文件
- [ ] 規則文件包含 paths: 前缀
- [ ] 規則被 lazy-load (不加載無關規則)
- [ ] 相同類型的需求複用規則
- [ ] AI 按照規則提問和執行
- [ ] git 歷史顯示規則文件的演進

---

## 🎓 總結

### 三個問題的答案

#### Q1: `.claude/rules/` 是什麼？
```
答: 它是一個智能指導系統
    • 全局規則 (CLAUDE.md) - 每次加載
    • 條件規則 (.claude/rules/*.md) - Lazy-load
    • 指導 AI 如何處理複雜變更
```

#### Q2: AI 怎麼知道要在這裡準備？
```
答: 通過項目文檔指導
    • CLAUDE.md 告訴 AI 使用規則系統
    • 現存規則是示例
    • AI 根據經驗學習和創建新規則
    → 不是自動知道，而是被教會的
```

#### Q3: 100 種需求怎麼辦？
```
答: 使用元規則系統 (Meta-Rules)
    • 分類需求為 5-10 大類
    • 每類創建 1 個類型規則
    • 具體需求複用類型規則
    • 100 個需求 → 只需 5-10 個規則文件
    → 規則 ÷ 需求 = 1:10 的比例
```

### 核心原則

```
規則系統的力量:
  ✓ 可擴展: 支持無限多的需求
  ✓ 可維護: 變更只需修改規則，不修改執行
  ✓ 可複用: 相同流程的需求複用規則
  ✓ 可學習: AI 和人類都能學習規則
```
