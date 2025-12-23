#!/usr/bin/env bash
set -euo pipefail
FULL_YAML="$1"

# 取得目前 conda 環境名稱
env_name="${CONDA_DEFAULT_ENV:-env}"

# 先收集 channels
declare -A ch

# 跑一次 conda list 收集 channels
mapfile -t conda_lines < <(conda list --show-channel-urls)

# 處理 channels（從第4行開始有 package ）
for line in "${conda_lines[@]:3}"; do
    read -r pkg ver build channel <<< "$line" || continue
    [[ -n "$channel" ]] && ch["$channel"]=1
done

# 開始輸出 YAML
{
    echo "name: $env_name"
    echo "channels:"
    [[ -n "${ch[conda-forge]+x}" ]] && echo "  - conda-forge"
    [[ -n "${ch[bioconda]+x}"    ]] && echo "  - bioconda"
    [[ -n "${ch[defaults]+x}"    ]] && echo "  - defaults"

    echo "dependencies:"
    for line in "${conda_lines[@]:3}"; do
        read -r pkg ver build channel <<< "$line" || continue
        [[ -z "$channel" ]] && continue
        echo "  - ${channel}::${pkg}=${ver}"
    done

} > $FULL_YAML
