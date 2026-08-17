---
paths:
  - ".claude/commands/weather-alert.md"
  - "practice/layer-4-orchestration/config.json"
  - "practice/layer-4-orchestration/weather-alert-report.html"
---

# 添加新地区检查清单 (Add City Checklist)

当用户请求"添加[地区]"时，遵循此清单。AI MUST 验证每一层。

## 🎯 流程概览

```
用户说: "增加 [地区名]"
  ↓
AI 自动检查清单 (自动提示)
  ↓
执行 4 个变更步骤
  ↓
验证所有层已更新
  ↓
向用户反馈变更清单
```

## 📋 5 层变更清单

### Layer 1: Skill (weather-fetcher)
**文件**: `.claude/skills/weather-fetcher/SKILL.md`
- **检查点**: 无需修改（通用技能，不依赖特定城市）
- **状态**: ✓ 自动兼容

### Layer 2: Agent (weather-analyzer-agent)
**文件**: `.claude/agents/weather-analyzer-agent.md`
- **检查点**: 无需修改（通用代理，支持任何城市）
- **状态**: ✓ 自动兼容

### Layer 3: Command (weather-alert)
**文件**: `.claude/commands/weather-alert.md`
- **必须更新**: `cities` 数组
- **示例**: `["Taipei", "Dubai", "Tokyo", "Seoul"]`
- **验证**: `git diff` 显示城市被添加

### Layer 4a: Config (config.json)
**文件**: `practice/layer-4-orchestration/config.json`
- **必须更新**: `cities` 数组
- **字段**: `name`, `latitude`, `longitude`, `timezone`, `enabled`
- **验证**: JSON 有效性，坐标合理性

### Layer 4b: HTML Report (weather-alert-report.html)
**文件**: `practice/layer-4-orchestration/weather-alert-report.html`
- **必须更新**: 添加城市卡片 HTML 块
- **格式**: `<div class="city-card normal/heat_wave/cold_warning">`
- **更新统计摘要**: 重新计算"监控城市"数量

### Layer 4c: 日志 & 文档
**文件**: 
  - `practice/layer-4-orchestration/notes.md` (可选)
  - `practice/layer-4-orchestration/outputs/` (自动生成)
- **记录**: 添加地区的日期和原因
- **状态**: 下次运行时自动更新

---

## ⚙️ AI 自动执行的检查流程

当用户说 "增加 [地区]" 时，AI 应该：

```python
# 伪代码 - AI 的思维流程
def handle_add_city_request(city_name, details):
    
    # Step 1: 识别变更
    print("✓ 识别: 需要添加城市", city_name)
    
    # Step 2: 检查清单
    checklist = {
        "Layer 3 - Command": {
            "file": ".claude/commands/weather-alert.md",
            "action": f"在 cities 数组中添加 '{city_name}'",
            "required": True,
            "status": "待执行"
        },
        "Layer 4a - Config": {
            "file": "practice/layer-4-orchestration/config.json",
            "action": f"在 cities 对象中添加 {city_name} 记录",
            "required": True,
            "status": "待执行"
        },
        "Layer 4b - HTML": {
            "file": "practice/layer-4-orchestration/weather-alert-report.html",
            "action": f"添加 {city_name} 的城市卡片和更新统计",
            "required": True,
            "status": "待执行"
        }
    }
    
    # Step 3: 显示检查清单给用户
    print_checklist(checklist)
    
    # Step 4: 执行每个变更
    for layer, task in checklist.items():
        if task["required"]:
            execute_change(task)
            verify_change(task)
    
    # Step 5: 最终验证
    verify_all_layers_consistent()
    
    # Step 6: 生成报告
    generate_completion_report(checklist)
```

---

## 🔍 验证规则

### 一致性检查
```
Layer 3 cities == Layer 4 config cities
  ✓ 城市数量相同
  ✓ 城市名称完全匹配
  ✓ 启用/禁用状态一致
```

### 完整性检查
```
对于每个 enabled=true 的城市:
  ✓ 在 HTML 报告中有对应的卡片
  ✓ 有 latitude/longitude 坐标
  ✓ 有 timezone 信息
```

---

## 📝 用户交互示例

**用户输入:**
```
增加 Bangkok 到天气警报系统
```

**AI 自动响应:**
```
🔍 检测到添加城市请求: Bangkok

📋 将执行以下变更:

┌─ Layer 3: Command
│  ├─ 文件: .claude/commands/weather-alert.md
│  └─ 操作: 在 cities 数组添加 "Bangkok"

├─ Layer 4a: Config
│  ├─ 文件: config.json
│  └─ 操作: 添加 Bangkok 地理数据 (13.7563°N, 100.5018°E)

└─ Layer 4b: Report
   ├─ 文件: weather-alert-report.html
   └─ 操作: 添加 Bangkok 城市卡片

✓ 所有层级已识别
是否继续? [Y/n]
```

**执行后:**
```
✅ 变更完成

已更新的文件:
  ✓ .claude/commands/weather-alert.md
  ✓ practice/layer-4-orchestration/config.json
  ✓ practice/layer-4-orchestration/weather-alert-report.html

⚠️ 建议下一步:
  1. 运行 /weather-alert 命令测试新城市
  2. 验证 HTML 报告显示正确
  3. git add && git commit

一致性检查: ✓ 所有层级同步
```

---

## 🚨 常见问题提示

### AI 应该提醒的情况:

| 场景 | 提醒 |
|------|------|
| 用户只修改 Layer 3 | ⚠️ "你修改了 Layer 3，但 Layer 4 config 还是旧数据。HTML 不会更新。" |
| 用户手动修改 HTML | ⚠️ "HTML 是自动生成的，建议改 config.json，HTML 会自动生成。" |
| 城市名称不一致 | ⚠️ "Layer 3 是 'Bangkok'，Layer 4 是 'Bangkok, Thailand'。建议统一。" |
| 坐标无效 | ❌ "坐标超出范围 (±180°)。验证失败。" |

---

## 💡 实现建议

### 方案 1: 基于规则的 AI 提示（推荐）
将此检查清单放在 `.claude/rules/` 中，带 `paths:` 前缀。
当用户编辑相关文件时，Claude 自动加载此规则。

### 方案 2: 自动化验证脚本
```bash
# verify-layers.sh
# 检查所有 4 个 Layer 的城市列表一致性
```

### 方案 3: Git Hook
在 `pre-commit` hook 中运行验证，阻止不一致的提交。

---

## ✅ 总结

这个设计让 AI 能够：
1. **自动识别** — 用户说"增加地区"时理解需求
2. **主动提示** — 显示需要修改的所有地方
3. **智能执行** — 在所有 Layer 执行正确的变更
4. **主动验证** — 检查一致性，提醒问题
5. **用户透明** — 无需用户了解 Layer 1-4 细节
