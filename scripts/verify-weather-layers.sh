#!/bin/bash
# verify-weather-layers.sh
# 验证天气系统所有 Layer (1-4) 的一致性
# 作用: 确保添加地区时，所有 Layer 都被更新

set -e

echo "🔍 开始验证天气系统各层一致性..."
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 初始化计数器
ERRORS=0
WARNINGS=0

# Layer 3: 从 weather-alert.md 提取城市列表
echo "📋 Layer 3: 读取命令层城市列表..."
LAYER3_CITIES=$(grep -A 20 '"cities":' ./.claude/commands/weather-alert.md | grep -o '"[A-Za-z]*"' | sed 's/"//g' | tr '\n' ',' | sed 's/,$//')
echo "   Layer 3 城市: $LAYER3_CITIES"
echo ""

# Layer 4: 从 config.json 提取城市列表
echo "📋 Layer 4: 读取编排层城市列表..."
LAYER4_CITIES=$(grep -o '"name": "[^"]*"' ./practice/layer-4-orchestration/config.json | grep -v "description\|label" | sed 's/"name": "//g' | sed 's/"//g' | awk '{if(NR>2) printf "%s,", $0; else printf "%s,", $0}' | sed 's/,$//')
echo "   Layer 4 城市: $LAYER4_CITIES"
echo ""

# Layer 4b: 从 HTML 报告检查城市卡片
echo "📋 Layer 4b: 检查 HTML 报告中的城市卡片..."
HTML_CITIES=$(grep -o '<div class="city-name">[^<]*</div>' ./practice/layer-4-orchestration/weather-alert-report.html | sed 's/<[^>]*>//g' | tr '\n' ',' | sed 's/,$//')
echo "   HTML 中的城市: $HTML_CITIES"
echo ""

# 一致性检查: Layer 3 vs Layer 4 config
echo "🔄 检查: Layer 3 vs Layer 4 config..."
if [ "$LAYER3_CITIES" = "$LAYER4_CITIES" ]; then
    echo -e "${GREEN}✓ 通过${NC}: 城市列表一致"
else
    echo -e "${RED}✗ 失败${NC}: Layer 3 和 Layer 4 城市列表不一致"
    echo "   Layer 3: $LAYER3_CITIES"
    echo "   Layer 4: $LAYER4_CITIES"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 统计摘要检查
echo "📊 检查: HTML 报告统计摘要..."
CITY_COUNT_IN_HTML=$(echo "$HTML_CITIES" | grep -o ',' | wc -l)
CITY_COUNT_IN_HTML=$((CITY_COUNT_IN_HTML + 1))

CITY_COUNT_IN_SUMMARY=$(grep -o '<div class="number">[0-9]*</div>' ./practice/layer-4-orchestration/weather-alert-report.html | head -1 | grep -o '[0-9]*')

if [ "$CITY_COUNT_IN_HTML" -eq "$CITY_COUNT_IN_SUMMARY" ]; then
    echo -e "${GREEN}✓ 通过${NC}: 统计摘要正确 ($CITY_COUNT_IN_SUMMARY 个城市)"
else
    echo -e "${YELLOW}⚠ 警告${NC}: 统计摘要可能需要更新"
    echo "   HTML 中找到: $CITY_COUNT_IN_HTML 个城市"
    echo "   摘要显示: $CITY_COUNT_IN_SUMMARY 个城市"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# 检查地理坐标
echo "🌍 检查: 城市地理坐标..."
COORDS_FOUND=$(grep -c '"latitude"' ./practice/layer-4-orchestration/config.json)
CITIES_FOUND=$(echo "$LAYER4_CITIES" | grep -o ',' | wc -l)
CITIES_FOUND=$((CITIES_FOUND + 1))

if [ "$COORDS_FOUND" -eq "$CITIES_FOUND" ]; then
    echo -e "${GREEN}✓ 通过${NC}: 所有城市都有地理坐标"
else
    echo -e "${RED}✗ 失败${NC}: 坐标数量与城市数量不匹配"
    echo "   城市数: $CITIES_FOUND"
    echo "   坐标数: $COORDS_FOUND"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 最终报告
echo "════════════════════════════════════════"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ 所有检查通过！所有 Layer 已同步。${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ 有 $WARNINGS 个警告，但核心一致性检查通过${NC}"
else
    echo -e "${RED}✗ 有 $ERRORS 个错误需要修复${NC}"
    echo ""
    echo "修复建议:"
    echo "  1. 运行 /weather-alert 命令获取最新数据"
    echo "  2. 确保 Layer 3 和 Layer 4 的城市列表一致"
    echo "  3. 重新生成 HTML 报告"
    exit 1
fi
echo "════════════════════════════════════════"
