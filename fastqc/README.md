# fastqc

[fastqc github](https://github.com/s-andrews/FastQC)

```bash
# create conda environment
mamba env create -f fastqc/envs.yaml -y
mamba activate fastqc-env
```

#### use quarto to render `html` file

```bash
quarto render fastqc/fastqc.qmd
```

```bash
# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n fastqc-env -y
````