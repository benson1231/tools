```bash
quarto render conda/conda.qmd
```


```bash
conda list --show-channel-urls
```

```bash
conda list --explicit > explicit.txt
```

# export conda env

```bash
# Export the current conda environment as a yaml file
bash ./scripts/convert_conda_to_yaml_full.sh ./conda/test/full-envs.yaml
# filter packages in incomplete.yaml from my-output-full.yaml
bash ./scripts/filter_yaml.sh ./conda/test/incomplete.yaml ./conda/test/full-envs.yaml ./conda/test/complete.yaml
```