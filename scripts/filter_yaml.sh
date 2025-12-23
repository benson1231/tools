#!/usr/bin/env bash
set -euo pipefail

FILTER_YAML="$1"
FULL_YAML="$2"
OUTPUT_YAML="$3"

# ============================================================
# Step 1：讀取 filter.yaml 的 package 名稱（無論格式如何）
# ============================================================
declare -A keep

while IFS= read -r line; do
    line="${line#- }"
    line="${line#*::}"
    pkg="${line%%=*}"

    if [[ "$pkg" =~ ^[A-Za-z0-9._-]+$ ]]; then
        keep["$pkg"]=1
    fi
done < <(grep -Eo '[- ]+[A-Za-z0-9._:-]+' "$FILTER_YAML" | sed 's/^[[:space:]-]*//')

# ============================================================
# Step 2：從 full.yaml 過濾 package，並統一縮排格式
# ============================================================

{
echo "dependencies:"

grep -E '^\s*-\s*' "$FULL_YAML" | \
while IFS= read -r dep; do
    dep_clean="${dep#"${dep%%[!- ]*}"}"   # 去掉全部前置空白
    dep_clean="${dep_clean#- }"           # 去掉 "- "

    pkg="${dep_clean#*::}"
    pkg="${pkg%%=*}"

    if [[ -n "${keep[$pkg]+x}" ]]; then
        echo "  - $dep_clean"
    fi
done

} > "$OUTPUT_YAML"

echo "✔ Done. Filtered output written to: $OUTPUT_YAML"
