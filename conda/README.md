```bash
conda list --show-channel-urls
```

```bash
conda list --explicit > explicit.txt
```


```bash
# Export the current conda environment as a yaml file
bash ../scripts/convert_conda_to_yaml_full.sh
```

```bash
bash ../scripts/filter_yaml.sh ./test.yaml ./my-output-full.yaml
```