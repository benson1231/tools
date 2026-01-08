```bash
mamba env create -f scripts/workflow/survival-analysis-r/envs/survival-analysis-r.yaml -y

mamba activate survival-analysis-r

Rscript -e "rmarkdown::render(
  'scripts/workflow/survival-analysis-r/survival-analysis-r.Rmd',
  output_dir = 'website/assets/survival-analysis-r'
)"
```