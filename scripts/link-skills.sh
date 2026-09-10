#!/bin/bash
# 把 ~/.skills-manager/skills 里的所有 skill 软链接到 harness 的 skill 根目录。
# 源目录新增 skill 后跑一次本脚本，harness 即可看到（已存在的跳过，断链自动清理）。
SRC="/Users/steven/.skills-manager/skills"
DST="$HOME/.agents/skills"
mkdir -p "$DST"

added=0
for d in "$SRC"/*/; do
  name=$(basename "$d")
  target="${d%/}"
  if [ -e "$DST/$name" ] || [ -L "$DST/$name" ]; then
    continue
  fi
  if ln -s "$target" "$DST/$name"; then
    echo "  + $name"
    added=$((added + 1))
  fi
done

removed=0
for l in "$DST"/*; do
  [ -L "$l" ] || continue
  if [ ! -e "$l" ]; then
    rm "$l" && echo "  - $(basename "$l")（源已删除，清理断链）"
    removed=$((removed + 1))
  fi
done

echo "完成：新增 $added 个，清理 $removed 个"
