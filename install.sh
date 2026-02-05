#!/bin/bash
#
# YYCLink AI Skills 一键下载/更新脚本 (Linux/Mac)
# 自动从 Gitee 下载或更新所有 Skill 仓库
# 如果本地已存在，则执行 git pull 更新
# 如果不存在，则执行 git clone 克隆
#

set -e

# 颜色定义
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

CONFIG_FILE="skills.json"
FORCE=false

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -c|--config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  -f, --force       强制重新克隆（删除后重新下载）"
            echo "  -c, --config      指定配置文件（默认: skills.json）"
            echo "  -h, --help        显示帮助"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
echo -e "${CYAN}   YYCLink AI Skills - 下载/更新工具${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
echo ""

# 检查配置文件
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo -e "${RED}❌ 配置文件不存在: $CONFIG_FILE${NC}"
    exit 1
fi

# 检查 jq
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠️  未找到 jq，尝试使用原始方式解析...${NC}"
    USE_JQ=false
else
    USE_JQ=true
fi

# 读取技能数量
if [[ "$USE_JQ" == true ]]; then
    SKILL_COUNT=$(jq '.skills | length' "$CONFIG_FILE")
    echo -e "${YELLOW}📋 发现 $SKILL_COUNT 个 Skills:${NC}"
    jq -r '.skills[] | "   • \(.name) - \(.description)"' "$CONFIG_FILE"
else
    # 简单的 grep 解析
    SKILL_COUNT=$(grep -c '"name":' "$CONFIG_FILE" || echo "0")
    echo -e "${YELLOW}📋 发现约 $SKILL_COUNT 个 Skills${NC}"
fi

echo ""

# 统计变量
CLONED=0
PULLED=0
FAILED=0

# 处理每个技能
process_skill() {
    local skill_name="$1"
    local repository="$2"
    local description="$3"
    
    echo -e "${GRAY}───────────────────────────────────────────────${NC}"
    
    # 强制模式：删除后重新克隆
    if [[ "$FORCE" == true ]] && [[ -d "$skill_name" ]]; then
        echo -e "${YELLOW}🗑️  强制模式：删除 $skill_name${NC}"
        rm -rf "$skill_name"
    fi
    
    if [[ -d "$skill_name" ]]; then
        # 已存在，执行更新
        echo -e "${YELLOW}📦 $skill_name 已存在，正在更新...${NC}"
        
        if [[ -d "$skill_name/.git" ]]; then
            cd "$skill_name"
            if git pull; then
                echo -e "${GREEN}✅ 更新成功${NC}"
                ((PULLED++))
            else
                echo -e "${RED}⚠️  更新失败${NC}"
                ((FAILED++))
            fi
            cd .. > /dev/null
        else
            echo -e "${RED}⚠️  $skill_name 不是 git 仓库，跳过${NC}"
            ((FAILED++))
        fi
    else
        # 不存在，执行克隆
        echo -e "${CYAN}📥 $skill_name 下载中...${NC}"
        
        if git clone "$repository" "$skill_name"; then
            echo -e "${GREEN}✅ 下载成功${NC}"
            ((CLONED++))
        else
            echo -e "${RED}❌ 下载失败${NC}"
            ((FAILED++))
        fi
    fi
}

# 遍历处理技能
if [[ "$USE_JQ" == true ]]; then
    # 使用 jq 解析
    jq -c '.skills[]' "$CONFIG_FILE" | while read -r skill; do
        name=$(echo "$skill" | jq -r '.name')
        repo=$(echo "$skill" | jq -r '.repository')
        desc=$(echo "$skill" | jq -r '.description')
        process_skill "$name" "$repo" "$desc"
    done
else
    # 备用方案：手动解析（简化版）
    echo -e "${YELLOW}⚠️  建议安装 jq 以获得更好的体验${NC}"
    echo -e "${YELLOW}   Mac: brew install jq${NC}"
    echo -e "${YELLOW}   Ubuntu/Debian: sudo apt-get install jq${NC}"
    echo ""
    
    # 提取仓库地址并克隆
    grep -o '"repository": "[^"]*"' "$CONFIG_FILE" | while read -r line; do
        repo=$(echo "$line" | sed 's/.*"repository": "\(.*\)".*/\1/')
        name=$(basename "$repo" .git)
        process_skill "$name" "$repo" ""
    done
fi

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
echo -e "${CYAN}   完成统计${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}   新下载: $CLONED${NC}"
echo -e "${YELLOW}   已更新: $PULLED${NC}"
if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}   失败:   $FAILED${NC}"
else
    echo -e "${GRAY}   失败:   $FAILED${NC}"
fi
echo -e "${CYAN}═══════════════════════════════════════════════${NC}"

# 列出本地 Skills
echo ""
echo -e "${YELLOW}📁 本地 Skills:${NC}"
for dir in skill-*/; do
    if [[ -d "$dir" ]]; then
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo -e "${GRAY}   📂 ${dir%/} ($size)${NC}"
    fi
done

exit $FAILED
