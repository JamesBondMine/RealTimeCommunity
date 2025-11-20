#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PNG图片MD5修改工具
通过在PNG文件末尾添加自定义数据块来改变MD5值，同时保持图片正常显示
"""

import os
import struct
import zlib
import hashlib
import random
import time
from pathlib import Path


def calculate_md5(file_path):
    """计算文件的MD5值"""
    md5_hash = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            md5_hash.update(chunk)
    return md5_hash.hexdigest()


def create_text_chunk(keyword, text):
    """
    创建PNG tEXt数据块
    keyword: 关键字（Latin-1字符串）
    text: 文本内容（Latin-1字符串）
    """
    # tEXt chunk格式: keyword\0text
    chunk_data = keyword.encode('latin-1') + b'\x00' + text.encode('latin-1')
    
    # 计算CRC
    chunk_type = b'tEXt'
    crc = zlib.crc32(chunk_type + chunk_data) & 0xffffffff
    
    # 构建完整的chunk: length + type + data + crc
    length = len(chunk_data)
    chunk = struct.pack('>I', length) + chunk_type + chunk_data + struct.pack('>I', crc)
    
    return chunk


def modify_png_md5(png_path):
    """
    修改PNG文件的MD5值
    通过在IEND块之前插入一个tEXt块
    """
    # 读取原始文件
    with open(png_path, 'rb') as f:
        data = f.read()
    
    # 检查是否是有效的PNG文件
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        print(f"  ⚠️  不是有效的PNG文件: {png_path}")
        return False
    
    # 查找IEND块的位置
    iend_signature = b'IEND'
    iend_pos = data.rfind(iend_signature)
    
    if iend_pos == -1:
        print(f"  ⚠️  未找到IEND块: {png_path}")
        return False
    
    # IEND块前4字节是长度，IEND位置需要往前推4字节
    iend_start = iend_pos - 4
    
    # 生成随机文本数据块
    timestamp = str(time.time())
    random_data = str(random.randint(100000, 999999))
    text_chunk = create_text_chunk('Timestamp', f'{timestamp}-{random_data}')
    
    # 在IEND之前插入新的chunk
    new_data = data[:iend_start] + text_chunk + data[iend_start:]
    
    # 写入文件
    with open(png_path, 'wb') as f:
        f.write(new_data)
    
    return True


def process_directory(directory):
    """
    递归处理目录中的所有PNG文件
    """
    directory = Path(directory)
    
    # 查找所有PNG文件
    png_files = list(directory.rglob('*.png')) + list(directory.rglob('*.PNG'))
    
    if not png_files:
        print("❌ 未找到任何PNG文件")
        return
    
    print(f"📊 找到 {len(png_files)} 个PNG文件")
    print(f"📁 处理目录: {directory.absolute()}\n")
    
    success_count = 0
    failed_count = 0
    
    for i, png_file in enumerate(png_files, 1):
        relative_path = png_file.relative_to(directory)
        
        # 计算原始MD5
        original_md5 = calculate_md5(png_file)
        
        print(f"[{i}/{len(png_files)}] 处理: {relative_path}")
        print(f"  原始MD5: {original_md5}")
        
        # 修改PNG
        if modify_png_md5(png_file):
            # 计算新的MD5
            new_md5 = calculate_md5(png_file)
            print(f"  新MD5:   {new_md5}")
            
            if original_md5 != new_md5:
                print(f"  ✅ 成功修改")
                success_count += 1
            else:
                print(f"  ⚠️  MD5未改变")
                failed_count += 1
        else:
            failed_count += 1
        
        print()
    
    print("=" * 60)
    print(f"✅ 处理完成!")
    print(f"📊 成功: {success_count} 个文件")
    if failed_count > 0:
        print(f"⚠️  失败: {failed_count} 个文件")
    print("=" * 60)


def main():
    """主函数"""
    print("=" * 60)
    print("🖼️  PNG图片MD5修改工具")
    print("=" * 60)
    print()
    
    # 获取当前脚本所在目录
    current_dir = Path(__file__).parent
    
    # 确认操作
    print(f"将处理目录: {current_dir.absolute()}")
    print("\n⚠️  注意: 此操作将修改所有PNG文件!")
    response = input("是否继续? (yes/no): ").strip().lower()
    
    if response not in ['yes', 'y', '是']:
        print("❌ 操作已取消")
        return
    
    print("\n开始处理...\n")
    
    # 处理目录
    process_directory(current_dir)


if __name__ == '__main__':
    main()

