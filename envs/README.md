# 創建環境

`envs` 資料夾中包含環境 `yaml` file，可用於 [conda](https://benson1231.github.io/tools/env-tools/conda.html) 或 [mamba(推薦)](https://benson1231.github.io/tools/env-tools/mamba.html) 快速建立環境。

---

## 創建 local 端 quarto 環境

```bash
mamba env create -f envs/local-quarto.yaml -y
mamba activate local-quarto
```

---

## 創建 ngs 工具環境

```bash
mamba env create -f envs/ngs-tools.yaml -y
mamba activate ngs-tools
```

---

## 退出與刪除環境

```bash
# exit conda environment
mamba deactivate

# remove conda environment (replace `ENV-NAME` to your environment name)
mamba env remove -n ENV-NAME -y
```