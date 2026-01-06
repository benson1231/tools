> This repository includes analysis materials derived from the `maftools` package.
Original `maftools` components are licensed under the MIT License by Anand Mayakonda.
See `LICENSE.maftools` for details.

```bash
mamba env create -f envs/ngs-r/maftools.yaml -y

mamba activate maftools

Rscript -e "rmarkdown::render(
  'website/ngs-r/maftools/maftools.Rmd',
  output_dir = 'website/ngs-r/maftools/'
)"
```