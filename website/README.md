# Website

This website is rendered using **GitHub Actions** with **Quarto**, which processes the `.qmd` files located in the `docs/` directory to generate the static site. You can view the deployed site here: [https://benson1231.github.io/tools/](https://benson1231.github.io/tools/).

There are two types of `.qmd` files used in this project:

1. **Native documentation pages**
   These `.qmd` files are self-contained and include complete documentation written directly in Quarto. They can be rendered without any external preprocessing.

2. **Report wrapper pages**
   For analysis-intensive content, figures and results are first generated locally using R Markdown or other analysis tools. The rendered HTML outputs are saved to the `assets/` directory. Corresponding `.qmd` files then act as lightweight wrappers that embed these pre-rendered HTML reports (e.g., via iframes) and are rendered by Quarto as part of the website.