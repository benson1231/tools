# tools

[![Tests](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml/badge.svg?branch=main)](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml)

本 repo 記錄資料科學與電腦科學相關工具的基本介紹、語法與實際輸出，並包含可以實做的環境，並可以透過 [使用github page建立之網站](https://benson1231.github.io/tools/) 快速讀取內容與查找指令。

## 創建環境

本 repo 之 `envs` 資料夾內包含 `envs.yaml`，可用於 [conda](https://benson1231.github.io/tools/env-tools/conda.html) 或 [mamba(推薦)](https://benson1231.github.io/tools/env-tools/mamba.html) 快速建立環境。

```bash
# create conda env
mamba env create -f envs/envs.yaml -y
mamba activate bio-tools

# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n bio-tools -y
```

## use quarto to render website

[download quarto](https://quarto.org/docs/get-started/)

```bash
quarto render ./website
```