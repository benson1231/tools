# quarto

[quarto](https://quarto.org/docs/get-started/)

```bash
mamba env create -f envs/quarto-test-env.yaml -y
mamba activate quarto-test-env
```

```bash
quarto render quarto-test.qmd
```

```bash
mamba deactivate
mamba env remove -n quarto-test-env -y
````