#!/bin/bash

# iOS 图片资源重命名脚本
# 用法: ./rename_images.sh <文件夹名> <前缀>
# 示例: ./rename_images.sh login renamea

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查参数
if [ "$#" -ne 2 ]; then
    echo -e "${RED}错误: 需要提供文件夹名和前缀${NC}"
    echo "用法: $0 <文件夹名> <前缀>"
    echo "示例: $0 login renamea"
    exit 1
fi

FOLDER_NAME=$1
PREFIX=$2

# 获取脚本所在目录（项目根目录）
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Assets.xcassets 路径
ASSETS_PATH="${PROJECT_ROOT}/RealTimeCommunityPro/RealTimeCommunityPro/Main/Assets.xcassets"

# 目标文件夹路径
TARGET_FOLDER="${ASSETS_PATH}/${FOLDER_NAME}"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}iOS 图片资源重命名工具${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "项目路径: ${YELLOW}${PROJECT_ROOT}${NC}"
echo -e "资源路径: ${YELLOW}${ASSETS_PATH}${NC}"
echo -e "目标文件夹: ${YELLOW}${FOLDER_NAME}${NC}"
echo -e "添加前缀: ${YELLOW}${PREFIX}${NC}"
echo ""

# 检查 Assets.xcassets 路径是否存在
if [ ! -d "$ASSETS_PATH" ]; then
    echo -e "${RED}错误: Assets.xcassets 路径不存在${NC}"
    echo -e "路径: ${ASSETS_PATH}"
    exit 1
fi

# 检查目标文件夹是否存在
if [ ! -d "$TARGET_FOLDER" ]; then
    echo -e "${RED}错误: 目标文件夹不存在${NC}"
    echo -e "路径: ${TARGET_FOLDER}"
    exit 1
fi

# 确认操作
read -p "$(echo -e ${YELLOW}是否继续重命名操作? [y/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}操作已取消${NC}"
    exit 1
fi

# 统计变量
TOTAL_COUNT=0
RENAMED_COUNT=0
SKIPPED_COUNT=0

# 创建临时文件存储需要重命名的列表
TEMP_RENAME_LIST=$(mktemp)
trap "rm -f $TEMP_RENAME_LIST" EXIT

echo -e "\n${GREEN}步骤 1/3: 扫描图片资源并检查代码引用...${NC}"
echo ""

# 查找所有 .imageset 文件夹
while IFS= read -r imageset_path; do
    # 获取 imageset 文件夹名（不带路径）
    imageset_name=$(basename "$imageset_path")
    
    # 去掉 .imageset 后缀得到图片名
    image_name="${imageset_name%.imageset}"
    
    # 跳过已经有前缀的图片
    if [[ $image_name == ${PREFIX}_* ]]; then
        continue
    fi
    
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    
    # 在代码中搜索 ImgNamed(@"图片名") 的使用
    echo -e "${BLUE}检查:${NC} ${image_name}"
    
    # 搜索代码中是否有 ImgNamed(@"image_name") 或 ImgNamed(@"image_name.png") 的使用
    # 支持单引号和双引号，支持有空格的情况
    FOUND=false
    FOUND_WITHOUT_PNG=false
    FOUND_WITH_PNG=false
    
    # 检查不带 .png 的版本（双引号）
    if grep -r "ImgNamed(@\"${image_name}\")" "$PROJECT_ROOT" \
        --include="*.m" --include="*.mm" --include="*.swift" \
        --exclude-dir="Pods" --exclude-dir=".build" --exclude-dir="DerivedData" \
        -q 2>/dev/null; then
        FOUND=true
        FOUND_WITHOUT_PNG=true
    fi
    
    # 检查不带 .png 的版本（单引号）
    if grep -r "ImgNamed(@'${image_name}')" "$PROJECT_ROOT" \
        --include="*.m" --include="*.mm" --include="*.swift" \
        --exclude-dir="Pods" --exclude-dir=".build" --exclude-dir="DerivedData" \
        -q 2>/dev/null; then
        FOUND=true
        FOUND_WITHOUT_PNG=true
    fi
    
    # 检查带 .png 的版本（双引号）
    if grep -r "ImgNamed(@\"${image_name}\.png\")" "$PROJECT_ROOT" \
        --include="*.m" --include="*.mm" --include="*.swift" \
        --exclude-dir="Pods" --exclude-dir=".build" --exclude-dir="DerivedData" \
        -q 2>/dev/null; then
        FOUND=true
        FOUND_WITH_PNG=true
    fi
    
    # 检查带 .png 的版本（单引号）
    if grep -r "ImgNamed(@'${image_name}\.png')" "$PROJECT_ROOT" \
        --include="*.m" --include="*.mm" --include="*.swift" \
        --exclude-dir="Pods" --exclude-dir=".build" --exclude-dir="DerivedData" \
        -q 2>/dev/null; then
        FOUND=true
        FOUND_WITH_PNG=true
    fi
    
    if [ "$FOUND" = true ]; then
        if [ "$FOUND_WITHOUT_PNG" = true ] && [ "$FOUND_WITH_PNG" = true ]; then
            echo -e "  ${GREEN}✓${NC} 找到代码引用（不带.png 和 带.png），将会重命名"
        elif [ "$FOUND_WITHOUT_PNG" = true ]; then
            echo -e "  ${GREEN}✓${NC} 找到代码引用（不带.png），将会重命名"
        else
            echo -e "  ${GREEN}✓${NC} 找到代码引用（带.png），将会重命名"
        fi
        echo "${imageset_path}|${image_name}" >> "$TEMP_RENAME_LIST"
        RENAMED_COUNT=$((RENAMED_COUNT + 1))
    else
        echo -e "  ${YELLOW}⊘${NC} 未找到 ImgNamed 引用，跳过"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    fi
    echo ""
    
done < <(find "$TARGET_FOLDER" -name "*.imageset" -type d)

echo -e "${BLUE}扫描完成:${NC}"
echo -e "  总计: ${YELLOW}${TOTAL_COUNT}${NC} 个图片"
echo -e "  将重命名: ${GREEN}${RENAMED_COUNT}${NC} 个"
echo -e "  跳过: ${YELLOW}${SKIPPED_COUNT}${NC} 个"
echo ""

# 如果没有需要重命名的，直接退出
if [ $RENAMED_COUNT -eq 0 ]; then
    echo -e "${YELLOW}没有需要重命名的图片资源${NC}"
    exit 0
fi

# 步骤 2: 替换代码中的引用
echo -e "${GREEN}步骤 2/3: 替换代码中的引用...${NC}"
echo ""

CODE_MODIFIED_COUNT=0

while IFS='|' read -r imageset_path image_name; do
    new_image_name="${PREFIX}_${image_name}"
    
    echo -e "${BLUE}替换:${NC} ${image_name} -> ${new_image_name}"
    
    # 获取所有需要检查的文件（只查找一次，提高效率）
    declare -a files_to_check
    while IFS= read -r file; do
        files_to_check+=("$file")
    done < <(find "$PROJECT_ROOT" \( -name "*.m" -o -name "*.mm" -o -name "*.swift" \) -type f ! -path "*/Pods/*" ! -path "*/.build/*" ! -path "*/DerivedData/*")
    
    # 对每个文件进行替换
    for file in "${files_to_check[@]}"; do
        file_modified=false
        
        # 替换不带 .png 的版本（双引号）
        if grep -q "ImgNamed(@\"${image_name}\")" "$file" 2>/dev/null; then
            perl -i -pe "s/ImgNamed\\(@\"${image_name}\"\\)/ImgNamed(@\"${new_image_name}\")/g" "$file"
            file_modified=true
        fi
        
        # 替换不带 .png 的版本（单引号）
        if grep -q "ImgNamed(@'${image_name}')" "$file" 2>/dev/null; then
            perl -i -pe "s/ImgNamed\\(@'${image_name}'\\)/ImgNamed(@'${new_image_name}')/g" "$file"
            file_modified=true
        fi
        
        # 替换带 .png 的版本（双引号）
        if grep -q "ImgNamed(@\"${image_name}\.png\")" "$file" 2>/dev/null; then
            perl -i -pe "s/ImgNamed\\(@\"${image_name}\\.png\"\\)/ImgNamed(@\"${new_image_name}.png\")/g" "$file"
            file_modified=true
        fi
        
        # 替换带 .png 的版本（单引号）
        if grep -q "ImgNamed(@'${image_name}\.png')" "$file" 2>/dev/null; then
            perl -i -pe "s/ImgNamed\\(@'${image_name}\\.png'\\)/ImgNamed(@'${new_image_name}.png')/g" "$file"
            file_modified=true
        fi
        
        if [ "$file_modified" = true ]; then
            echo -e "    ${GREEN}✓${NC} 已更新: $(basename "$file")"
            CODE_MODIFIED_COUNT=$((CODE_MODIFIED_COUNT + 1))
        fi
    done
    
    # 清空数组
    unset files_to_check
    
    echo ""
    
done < "$TEMP_RENAME_LIST"

echo -e "  共修改了 ${YELLOW}${CODE_MODIFIED_COUNT}${NC} 个代码文件"
echo ""

# 步骤 3: 重命名 imageset 文件夹
echo -e "${GREEN}步骤 3/3: 重命名图片资源文件夹...${NC}"
echo ""

FOLDER_RENAMED_COUNT=0

while IFS='|' read -r imageset_path image_name; do
    new_image_name="${PREFIX}_${image_name}"
    new_imageset_path="${TARGET_FOLDER}/${new_image_name}.imageset"
    
    if [ -d "$imageset_path" ]; then
        mv "$imageset_path" "$new_imageset_path"
        echo -e "  ${GREEN}✓${NC} ${image_name}.imageset -> ${new_image_name}.imageset"
        FOLDER_RENAMED_COUNT=$((FOLDER_RENAMED_COUNT + 1))
    fi
    
done < "$TEMP_RENAME_LIST"

echo ""

# 完成
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ 重命名完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}统计信息:${NC}"
echo -e "  扫描图片总数: ${YELLOW}${TOTAL_COUNT}${NC}"
echo -e "  ${GREEN}重命名图片数: ${RENAMED_COUNT}${NC}"
echo -e "  ${YELLOW}跳过图片数: ${SKIPPED_COUNT}${NC}"
echo -e "  修改代码文件数: ${YELLOW}${CODE_MODIFIED_COUNT}${NC}"
echo ""
echo -e "${YELLOW}提示:${NC}"
echo -e "  1. 请在 Xcode 中重新打开项目"
echo -e "  2. 建议进行一次清理构建 (Clean Build)"
echo -e "  3. 如果使用 Git，请检查变更并提交"
echo ""

# 显示可以撤销的 git 命令
if [ -d "$PROJECT_ROOT/.git" ]; then
    echo -e "${YELLOW}撤销方法 (如果使用 Git):${NC}"
echo -e "  git checkout ."
    echo -e "  git clean -fd"
    echo ""
fi

