# tools

[![Tests](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml/badge.svg?branch=main)](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml)

本 repo 記錄資料科學與電腦科學相關工具的基本介紹、語法與實際輸出，並包含可以實做的環境，並可以透過 [使用github page建立之網站](https://benson1231.github.io/tools/) 快速讀取內容與查找指令。

## clone this repo

若想要實際執行，請 clone 這個 repo:

```bash
git clone https://github.com/benson1231/tools.git
cd tools
```

並參考[環境文件](./envs/README.md)，建立可運行之環境

## render website

可以在本地安裝 [quarto](https://quarto.org/docs/get-started/)，也可以直接使用 [envs/local-quarto.yaml](./envs/local-quarto.yaml) 快速建立可運行環境。

```bash
quarto render ./website
```