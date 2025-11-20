#!/bin/bash

# iOS 类文件重命名脚本
# 用法: ./rename_class.sh <旧类名> <新类名>
# 示例: ./rename_class.sh ZAboutUsViewController AboutUsViewController

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查参数
if [ "$#" -ne 2 ]; then
    echo -e "${RED}错误: 需要提供旧类名和新类名${NC}"
    echo "用法: $0 <旧类名> <新类名>"
    echo "示例: $0 ZAboutUsViewController AboutUsViewController"
    exit 1
fi

OLD_CLASS_NAME=$1
NEW_CLASS_NAME=$2

# 获取脚本所在目录（项目根目录）
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}iOS 类文件重命名工具${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "项目路径: ${YELLOW}${PROJECT_ROOT}${NC}"
echo -e "旧类名: ${YELLOW}${OLD_CLASS_NAME}${NC}"
echo -e "新类名: ${YELLOW}${NEW_CLASS_NAME}${NC}"
echo ""

# 确认操作
read -p "$(echo -e ${YELLOW}是否继续重命名操作? [y/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}操作已取消${NC}"
    exit 1
fi

# 查找 .h 和 .m 文件
echo -e "\n${GREEN}步骤 1/4: 查找文件...${NC}"
H_FILE=$(find "$PROJECT_ROOT" -name "${OLD_CLASS_NAME}.h" -type f | grep -v "/Pods/" | head -1)
M_FILE=$(find "$PROJECT_ROOT" -name "${OLD_CLASS_NAME}.m" -type f | grep -v "/Pods/" | head -1)

if [ -z "$H_FILE" ] && [ -z "$M_FILE" ]; then
    echo -e "${RED}错误: 找不到 ${OLD_CLASS_NAME}.h 或 ${OLD_CLASS_NAME}.m 文件${NC}"
    exit 1
fi

if [ -n "$H_FILE" ]; then
    echo -e "  找到头文件: ${YELLOW}${H_FILE}${NC}"
fi

if [ -n "$M_FILE" ]; then
    echo -e "  找到实现文件: ${YELLOW}${M_FILE}${NC}"
fi

# 全局替换代码中的引用
echo -e "\n${GREEN}步骤 2/4: 全局替换代码引用...${NC}"

# 统计将要修改的文件数量
FILE_COUNT=$(find "$PROJECT_ROOT" \( -name "*.h" -o -name "*.m" -o -name "*.mm" -o -name "*.swift" -o -name "*.pbxproj" \) -type f ! -path "*/Pods/*" ! -path "*/.build/*" ! -path "*/DerivedData/*" | wc -l | tr -d ' ')
echo -e "  将扫描 ${YELLOW}${FILE_COUNT}${NC} 个文件..."

# 替换所有文件中的类名引用
MODIFIED_COUNT=0
while IFS= read -r file; do
    if grep -q "$OLD_CLASS_NAME" "$file" 2>/dev/null; then
        # 使用 perl 进行替换，更可靠
        perl -i -pe "s/\b${OLD_CLASS_NAME}\b/${NEW_CLASS_NAME}/g" "$file"
        MODIFIED_COUNT=$((MODIFIED_COUNT + 1))
        echo -e "    ${GREEN}✓${NC} 已更新: $(basename "$file")"
    fi
done < <(find "$PROJECT_ROOT" \( -name "*.h" -o -name "*.m" -o -name "*.mm" -o -name "*.swift" -o -name "*.pbxproj" \) -type f ! -path "*/Pods/*" ! -path "*/.build/*" ! -path "*/DerivedData/*")

echo -e "  共修改了 ${YELLOW}${MODIFIED_COUNT}${NC} 个文件"

# 重命名文件
echo -e "\n${GREEN}步骤 3/4: 重命名文件...${NC}"

if [ -n "$H_FILE" ]; then
    NEW_H_FILE="${H_FILE/${OLD_CLASS_NAME}.h/${NEW_CLASS_NAME}.h}"
    mv "$H_FILE" "$NEW_H_FILE"
    echo -e "  ${GREEN}✓${NC} ${OLD_CLASS_NAME}.h -> ${NEW_CLASS_NAME}.h"
fi

if [ -n "$M_FILE" ]; then
    NEW_M_FILE="${M_FILE/${OLD_CLASS_NAME}.m/${NEW_CLASS_NAME}.m}"
    mv "$M_FILE" "$NEW_M_FILE"
    echo -e "  ${GREEN}✓${NC} ${OLD_CLASS_NAME}.m -> ${NEW_CLASS_NAME}.m"
fi

# 检查是否需要更新 import 语句中的文件名
echo -e "\n${GREEN}步骤 4/4: 更新 import 语句...${NC}"
IMPORT_COUNT=0
while IFS= read -r file; do
    if grep -q "#import.*${OLD_CLASS_NAME}\.h" "$file" 2>/dev/null || grep -q "#include.*${OLD_CLASS_NAME}\.h" "$file" 2>/dev/null; then
        perl -i -pe "s/${OLD_CLASS_NAME}\.h/${NEW_CLASS_NAME}.h/g" "$file"
        IMPORT_COUNT=$((IMPORT_COUNT + 1))
        echo -e "    ${GREEN}✓${NC} 已更新 import: $(basename "$file")"
    fi
done < <(find "$PROJECT_ROOT" \( -name "*.h" -o -name "*.m" -o -name "*.mm" -o -name "*.pch" \) -type f ! -path "*/Pods/*" ! -path "*/.build/*" ! -path "*/DerivedData/*")

echo -e "  共更新了 ${YELLOW}${IMPORT_COUNT}${NC} 个 import 语句"

# 完成
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ 重命名完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${YELLOW}提示:${NC}"
echo -e "  1. 请在 Xcode 中重新打开项目"
echo -e "  2. 建议进行一次清理构建 (Clean Build)"
echo -e "  3. 如果使用 Git，请检查变更并提交"
echo -e "  4. 如果 Xcode 项目出现问题，可能需要手动移除旧文件引用并添加新文件\n"

# 显示可以撤销的 git 命令
if [ -d "$PROJECT_ROOT/.git" ]; then
    echo -e "${YELLOW}撤销方法 (如果使用 Git):${NC}"
    echo -e "  git checkout ."
    echo -e "  git clean -fd\n"
fi

