# Contributing Guidelines

This repository follows a strict **separation-of-concerns** principle.
All contributions should respect the boundaries between computation, artifacts, and presentation.

---

## Adding a New Tool or Analysis

When adding a new tool, workflow, or analysis, please follow the steps below.

### 1. Write Analysis Code

- Place all executable code under `scripts/`
  - `scripts/bash/`
  - `scripts/r/`
  - `scripts/python/`
- Scripts must be runnable independently of Quarto

---

### 2. Generate Outputs

- All `html` outputs **must** be written to `website/assets/`

Do not write outputs to the repository root or documentation directories.

---

### 3. Add Documentation

- Create documentation pages under `website/docs/`
- Use Quarto (`.qmd`) for:
  - Tool descriptions
  - Command-line usage examples
  - Methodological explanations

**Important:**  
`.qmd` files must not execute analysis code (R, Python, Bash).

---

### 4. Add Report Wrappers (If Needed)

If an analysis produces a rendered HTML report:

- Place the HTML file in `website/assets/`
- Embed the HTML output using an iframe

Example:

```html
<iframe src="../assets/example/report.html"
        style="width:100%; height:90vh; border:none;">
</iframe>
