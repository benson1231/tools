#!/usr/bin/env bash
set -euo pipefail

FILTER_FILE="${1:-}"

# 若有提供 YAML → 解析出 dependencies 裡所有的套件名稱
declare -A filter_pkgs

if [[ -n "$FILTER_FILE" ]]; then
    while IFS= read -r line; do
        # 解析像 "  - conda-forge::python=3.10" → 抓 "python"
        pkg=$(echo "$line" | sed -n 's/^[[:space:]]*-[[:space:]]*[a-zA-Z0-9_-]*::\([a-zA-Z0-9_.-]*\)=.*$/\1/p')
        if [[ -n "$pkg" ]]; then
            filter_pkgs["$pkg"]=1
        fi
    done < "$FILTER_FILE"
fi

# 產生 YAML
conda list --show-channel-urls | awk \
    -v env="$CONDA_DEFAULT_ENV" \
    -v hasFilter="$([[ ${#filter_pkgs[@]} -gt 0 ]] && echo 1 || echo 0)" \
    -v filterList="$(printf "%s " "${!filter_pkgs[@]}")" '
BEGIN {
    print "name: " env
    print "channels:"

    # 將 filter list 放進 array
    n = split(filterList, f, " ")
    for (i=1; i<=n; i++) {
        if (f[i] != "") filter[f[i]] = 1
    }
}

NR > 3 && NF >= 4 {
    ch[$NF] = 1
}

END {
    if (ch["conda-forge"]) print "  - conda-forge"
    if (ch["bioconda"])    print "  - bioconda"
    if (ch["defaults"])    print "  - defaults"

    print "dependencies:"
}

# 實際列 dependencies
NR > 3 && NF >= 4 {
    pkg = $1
    sub(/\..*$/, "", pkg)   # 避免 python.3_10 這種狀況，只取前面

    # 若有 filter → 只輸出 filter 中的 packages
    if (hasFilter == 1) {
        if (pkg in filter) {
            printf("  - %s::%s=%s\n", $NF, $1, $2)
        }
    } else {
        printf("  - %s::%s=%s\n", $NF, $1, $2)
    }
}
' > my-output.yaml
