# tools

[![Tests](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml/badge.svg?branch=main)](https://github.com/benson1231/tools/actions/workflows/deploy-pages.yml)

This repository documents a collection of **data science and computer science tools**, including their core concepts, command-line usage, and representative outputs.
It also provides runnable environments for hands-on experimentation, and a GitHub Pages–hosted website for quick reference and command lookup:

👉 [https://benson1231.github.io/tools/](https://benson1231.github.io/tools/)

---

## Repository Structure and Design Philosophy

This repository adopts a **decoupled architecture** that clearly separates **computation**, **artifacts**, and **presentation**.

* **`website/docs/`**
  Contains Quarto (`.qmd`) files used for documentation, tutorials, and methodological explanations.

---

## Clone This Repository

To run the tools locally, clone this repository:

```bash
git clone https://github.com/benson1231/tools.git
cd tools
mkdir results/
```

Please refer to the environment documentation in [`envs/README.md`](./envs/README.md) to set up a runnable environment.

---

## Render the Website

To build the website locally, install [Quarto](https://quarto.org/docs/get-started/) or create a ready-to-use environment using [`envs/quarto.yaml`](./envs/quarto.yaml).

```bash
quarto render ./website
```

---

## If you want run the codes in your machine

See `envs/` folder

```bash
mamba env create -f envs/ENV-YAML-FILE -y
mamba activate ENV-NAME
```

example:

```bash
mamba env create -f envs/ngs-tools.yaml -y
mamba activate ngs-tools
```

## 退出與刪除環境

```bash
# exit conda environment
mamba deactivate

# remove conda environment (replace `ENV-NAME` to your environment name)
mamba env remove -n ENV-NAME -y
```





```mermaid
flowchart TD
    A[Raw count matrix<br/>(integer counts)] --> B[DESeqDataSet]
    
    B --> C[DESeq()<br/>• estimateSizeFactors<br/>• estimateDispersions<br/>• NB GLM fitting]
    
    %% Differential expression
    C --> D[results()<br/>Wald / LRT test]
    
    D --> E[GSEA ranking<br/>• stat (recommended)<br/>• log2FC (no shrink)]
    
    %% LFC shrinkage
    D --> F[lfcShrink()<br/>apeglm / ashr / normal]
    F --> Fnote[[Effect size stabilization<br/>for interpretation & plots only]]
    
    %% Visualization branch
    C --> G[VST / rlog<br/>blind = FALSE]
    
    G --> H[removeBatchEffect<br/>(limma)]
    
    H --> I[PCA / MDS]
    H --> J[Heatmap / clustering]
    
    %% Notes
    E -.-> Enote[[Use raw DE statistics<br/>DO NOT use LFC shrinkage for GSEA]]
    H -.-> Hnote[[Batch correction<br/>for visualization only]]
    
    %% Styling
    classDef important fill:#fdecea,stroke:#d33,stroke-width:1px;
    classDef process fill:#eef3fb,stroke:#4a6fe3,stroke-width:1px;
    classDef note fill:#f7f7f7,stroke:#999,stroke-dasharray: 5 5;
    
    class A,B,C,D,E,F,G,H,I,J process
    class Fnote,Enote,Hnote note
```