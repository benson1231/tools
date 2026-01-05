> This repository includes analysis materials derived from the `maftools` package.
Original `maftools` components are licensed under the MIT License by Anand Mayakonda.
See `LICENSE.maftools` for details.

```bash
mamba activate ngs-r

Rscript -e "rmarkdown::render(
  'maftools/maftools.Rmd',
  output_dir = 'website/ngs-r'
)"
```