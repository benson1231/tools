# samtools

[samtools github]()

```bash
# create conda environment
mamba env create -f samtools/envs.yaml -y
mamba activate samtools-env
```

#### use quarto to render `html` file

```bash
quarto render samtools/samtools.qmd
```

```bash
# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n samtools-env -y
````