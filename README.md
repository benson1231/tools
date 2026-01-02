# tools

[![Tests](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml/badge.svg?branch=main)](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml)

本 repo 記錄資料科學與電腦科學相關工具的基本介紹、語法與實際輸出，並包含可以實做的環境，並可以透過 [使用github page建立之網站](https://benson1231.github.io/tools/) 快速讀取內容與查找指令。

## 創建環境

本 repo 之 `envs` 資料夾內包含 `bio-tools.yaml`，可用於 [conda]([./conda/README.md](https://benson1231.github.io/tools/reports/conda/conda.html)) 或 [mamba(推薦)](https://benson1231.github.io/tools/reports/mamba/mamba.html) 快速建立環境。

```bash
# create conda env
mamba env create -f envs/envs.yaml -y
mamba activate bio-tools

# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n bio-tools -y
```


# quarto

[quarto](https://quarto.org/docs/get-started/)

#### use quarto to render `html` file

```bash
quarto render quarto/quarto-python.qmd
quarto render quarto/quarto-r.qmd
quarto render quarto/quarto-bash.qmd
```

```bash
# create conda environment
mamba env create -f bio-tools.yaml -y
mamba activate bio-tools

# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n bio-tools -y
```

```bash
# create conda environment
mamba env create -f python-env.yaml -y
mamba activate python-env

# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n python-env -y
```

# 輸出 pdf

需先安裝LaTeX 

```bash
quarto install tinytex
```