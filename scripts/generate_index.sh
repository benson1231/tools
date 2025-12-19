#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="public"
REPORT_DIR="$OUTPUT_DIR/reports"

mkdir -p "$REPORT_DIR"

echo "Generating index.html..."

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

# 尋找所有專案資料夾，例如 maftools/、WGS/、RNAseq/
PROJECTS=$(find . -maxdepth 1 -type d \
          -not -path "." -not -path "./public" -not -path "./scripts")

for project in $PROJECTS; do
  PROJ_NAME=$(basename "$project")
  
  # 搜索該專案的 HTML
  HTML_FILES=$(find "$project" -name "*.html")
  
  if [[ -z "$HTML_FILES" ]]; then
    continue
  fi

  echo "<h2>$PROJ_NAME</h2>" >> $OUTPUT_DIR/index.html

  # 建立 reports/${project}/
  mkdir -p "$REPORT_DIR/$PROJ_NAME"
  
  # 複製整個專案資料夾（包含 .css / .html / .png 等）
  cp -r "$project/"* "$REPORT_DIR/$PROJ_NAME" 2>/dev/null || true

  # 為 index 建立連結
  for f in $HTML_FILES; do
    NAME=$(basename "$f")
    echo "<div class='card'><a href='./reports/$PROJ_NAME/$NAME'>$NAME</a></div>" >> $OUTPUT_DIR/index.html
  done

done

echo "</body></html>" >> $OUTPUT_DIR/index.html

echo "index.html generated successfully."
