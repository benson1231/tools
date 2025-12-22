# quarto

[quarto](https://quarto.org/docs/get-started/)

```bash
cd quarto
mamba env create -f envs/quarto-test-env.yaml -y
mamba activate quarto-test-env
```

```bash
quarto render quarto-python.qmd
quarto render quarto-r.qmd
quarto render quarto-bash.qmd
```

```bash
mamba deactivate
mamba env remove -n quarto-test-env -y
````