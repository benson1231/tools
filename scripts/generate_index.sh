#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="public"
REPORT_DIR="$OUTPUT_DIR/reports"

echo "==> Creating output directories..."
mkdir -p "$REPORT_DIR"

echo "==> Starting index.html generation..."

cat <<EOF > $OUTPUT_DIR/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Tools Reports</title>
<style>
  body { font-family: Arial; padding: 20px; max-width: 900px; margin: auto; }
  h1 { margin-bottom: 0; }
  h2 { margin-top: 40px; }
  .card { padding: 10px 15px; border: 1px solid #ddd; border-radius: 6px; margin: 10px 0; }
  a { text-decoration: none; font-size: 18px; color: #0366d6; }
  a:hover { text-decoration: underline; }
</style>
</head>
<body>
<h1>Tools Reports</h1>
<p>Automatically generated list of HTML reports.</p>
<hr>
EOF

echo "==> Scanning project directories..."

# Find all project-level directories at the repo root
PROJECTS=$(find . -maxdepth 1 -type d \
          -not -path "." -not -path "./public" -not -path "./scripts")

for project in $PROJECTS; do
  PROJ_NAME=$(basename "$project")
  echo "----> Checking project: $PROJ_NAME"

  # Find HTML files inside the project
  HTML_FILES=$(find "$project" -name "*.html")

  if [[ -z "$HTML_FILES" ]]; then
    echo "     No HTML files found in $PROJ_NAME -> skipping"
    continue
  fi

  echo "     Found HTML files, adding section to index..."

  # Add header section for this project
  echo "<h2>$PROJ_NAME</h2>" >> $OUTPUT_DIR/index.html

  # Create output folder: public/reports/<project>/
  TARGET_PROJ_DIR="$REPORT_DIR/$PROJ_NAME"
  mkdir -p "$TARGET_PROJ_DIR"
  echo "     Copying project files into $TARGET_PROJ_DIR"

  # Copy all project files (HTML, CSS, PNG, TSV, JS, etc.)
  cp -r "$project/"* "$TARGET_PROJ_DIR" 2>/dev/null || true

  # Add HTML links for this project
  for f in $HTML_FILES; do
    NAME=$(basename "$f")
    echo "     Adding link: $NAME"
    echo "<div class='card'><a href='./reports/$PROJ_NAME/$NAME'>$NAME</a></div>" >> $OUTPUT_DIR/index.html
  done

done

echo "</body></html>" >> $OUTPUT_DIR/index.html

echo "==> index.html generated successfully!"

echo ""
echo "==> Listing deployed contents under public/:"
echo "-------------------------------------------------"
ls -R $OUTPUT_DIR
echo "-------------------------------------------------"

echo "==> Done."
