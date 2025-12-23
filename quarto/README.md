# quarto

[quarto](https://quarto.org/docs/get-started/)

```bash
# create conda environment
mamba env create -f quarto/envs/quarto-test-env.yaml -y
mamba activate quarto-test-env
```

#### use quarto to render `html` file

```bash
quarto render quarto/quarto-python/quarto-python.qmd
quarto render quarto/quarto-r/quarto-r.qmd
quarto render quarto/quarto-bash/quarto-bash.qmd
```

```bash
# exit conda environment
mamba deactivate
# remove conda environment
mamba env remove -n quarto-test-env -y
````