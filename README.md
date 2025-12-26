# tools

本 repo 記錄資料科學與電腦科學相關工具的基本介紹、語法與實際輸出，並包含可以實做的環境，並可以透過 [github page建立之網站](https://benson1231.github.io/tools/) 快速讀取內容與查找指令。

## 創建環境

本 repo 之 `envs` 資料夾內包含 `bio-tools.yaml`，可用於 [conda]([./conda/README.md](https://benson1231.github.io/tools/reports/conda/conda.html)) 或 [mamba(推薦)](https://benson1231.github.io/tools/reports/mamba/mamba.html) 快速建立環境。

```bash
# create conda env
mamba env create -f envs/bio-tools.yaml -y
mamba activate bio-tools
```

## 離開環境與移除環境

測試結束後，可透過以下指令退出並刪除環境

```bash
# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n bio-tools -y
````