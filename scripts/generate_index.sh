#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="public"
REPORT_DIR="$OUTPUT_DIR/reports"

mkdir -p "$REPORT_DIR"

# 找所有 html 檔案（排除 public/ 下的）
HTML_FILES=$(find . -name "*.html" -not -path "./public/*")

# 找所有 css 檔案（排除 public/ 下的）
CSS_FILES=$(find . -name "*.css" -not -path "./public/*")

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

# 複製 HTML
for f in $HTML_FILES; do
  NAME=$(basename "$f")
  echo "<div class='card'><a href='./reports/$NAME'>$NAME</a></div>" >> $OUTPUT_DIR/index.html
  cp "$f" "$REPORT_DIR/"
done

# 複製 CSS（讓 HTML 可以找到）
for c in $CSS_FILES; do
  cp "$c" "$REPORT_DIR/"
done

echo "</body></html>" >> $OUTPUT_DIR/index.html

echo "index.html generated successfully."
