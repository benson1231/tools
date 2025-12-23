# fastp

[fastp]()

```bash
# create conda environment
mamba env create -f fastp/envs.yaml -y
mamba activate fastp-env
```

#### use quarto to render `html` file

```bash
quarto render fastp/fastp.qmd
```

```bash
# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n fastp-env -y
````