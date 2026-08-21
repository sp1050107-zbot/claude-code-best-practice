# Claude Code 最佳實踐 — 練習指南

> 基於 `shanraisshan/claude-code-best-practice` 的學習路徑
> 
> 分支：`practice/initial-setup` | 學習者：sp1050107-zbot

---

## 🎯 練習目標

通過實際操作學習 Claude Code 的核心概念：
- ✓ Skills（技能）— 可復用的指令集
- ✓ Subagents（代理）— 獨立的工作單位
- ✓ Commands（命令）— 工作流入口點
- ✓ Orchestration（協調）— Command → Agent → Skill 架構

---

## 📚 學習路徑

### 第 1 層：基礎（技能 Skills）
**目標**：理解技能的核心概念和配置

**練習內容**：
- [ ] 讀懂 `best-practice/claude-skills.md`
- [ ] 分析 `.claude/skills/` 中的 3 個現有技能
- [ ] 創建筆記：`practice/layer-1-skills-notes.md`
- [ ] **實作任務**：建立你的第一個簡單技能

**預計時間**：30-45 分鐘

---

### 第 2 層：代理（Subagents）
**目標**：理解代理的獨立性和隔離

**練習內容**：
- [ ] 讀懂 `best-practice/claude-subagents.md`
- [ ] 分析 `.claude/agents/` 中的現有代理
- [ ] 創建筆記：`practice/layer-2-subagents-notes.md`
- [ ] **實作任務**：建立你的第一個簡單代理

**預計時間**：30-45 分鐘

---

### 第 3 層：命令（Commands）
**目標**：理解命令如何協調工作流

**練習內容**：
- [ ] 讀懂 `best-practice/claude-commands.md`
- [ ] 分析 `.claude/commands/weather-orchestrator.md`
- [ ] 創建筆記：`practice/layer-3-commands-notes.md`
- [ ] **實作任務**：建立你的第一個簡單命令

**預計時間**：30-45 分鐘

---

### 第 4 層：協調（Orchestration）
**目標**：實現完整的 Command → Agent → Skill 流程

**練習內容**：
- [ ] 讀懂 `orchestration-workflow/orchestration-workflow.md`
- [ ] 分析完整的 Weather 工作流實現
- [ ] 創建筆記：`practice/layer-4-orchestration-notes.md`
- [ ] **實作任務**：建立完整的協調工作流

**預計時間**：60 分鐘

---

## 🚀 快速開始 — 選擇你的第一個練習

### 推薦順序（適合初學者）
```
Layer 1 (Skills) → Layer 2 (Subagents) → Layer 3 (Commands) → Layer 4 (Orchestration)
```

### 快速通道（想快速看到成果）
```
直接從 Layer 4 (Orchestration) 開始，反向學習
```

---

## 📋 每層練習的結構

每層包含 3 個部分：

### A. 讀懂（Understanding）
文件位置和關鍵內容

### B. 分析（Analysis）
現有實現的技術細節

### C. 實作（Implementation）
建立你自己的版本

---

## 💾 提交規則

根據 CLAUDE.md 的指導，每個練習層應分開提交：

```bash
# Layer 1 完成後
git add practice/layer-1-*.md
git commit -m "practice(layer-1): study skills and create first skill"
git push origin practice/initial-setup -o no-repo-suggestions

# Layer 2 完成後
git add practice/layer-2-*.md
git commit -m "practice(layer-2): study subagents and create first agent"
git push origin practice/initial-setup -o no-repo-suggestions

# 依此類推...
```

---

## 🎓 關鍵概念速查表

| 概念 | 文件位置 | 用途 | 複雜度 |
|-----|---------|------|--------|
| **Skill** | `.claude/skills/<name>/SKILL.md` | 可復用指令 | ⭐ 簡單 |
| **Subagent** | `.claude/agents/<name>.md` | 獨立工作單位 | ⭐⭐ 中等 |
| **Command** | `.claude/commands/<name>.md` | 工作流入口 | ⭐⭐ 中等 |
| **Orchestration** | 組合上述三者 | 完整系統 | ⭐⭐⭐ 複雜 |

---

## 📖 推薦閱讀順序

1. **CLAUDE.md** — 項目總體指南
2. **best-practice/claude-skills.md** — 技能最佳實踐
3. **best-practice/claude-subagents.md** — 代理最佳實踐
4. **best-practice/claude-commands.md** — 命令最佳實踐
5. **orchestration-workflow/orchestration-workflow.md** — 協調工作流

---

## ✨ 練習技巧

- 📌 **邊讀邊寫筆記** — 加深理解
- 🔍 **對比分析** — 現有實現 vs 官方文檔
- 💡 **提出問題** — 記錄疑惑，逐層解決
- 🧪 **實驗優先** — 不怕犯錯，迭代學習

---

## 🎯 下一步

選擇開始的層級，我會帶你完成第一個練習。

**你想從哪層開始？**
- `Layer 1: Skills`（推薦新手）
- `Layer 2: Subagents`
- `Layer 3: Commands`
- `Layer 4: Orchestration`（想快速看到結果）
