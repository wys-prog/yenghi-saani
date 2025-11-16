#!/bin/bash

# Remove all existing HTML files
echo "Cleaning build directory..."
find build -name "*.html" -type f -exec rm -v {} \;

# Compile all Markdown files recursively
echo "Compiling Markdown files..."
find lessons -name "*.md" | while read -r f; do
  # Determine relative path
  rel_path="${f#lessons/}"         # e.g. subdir/file.md
  dir_path=$(dirname "$rel_path")  # e.g. subdir
  filename=$(basename "$f" .md)
  
  # Make corresponding build directory
  out_dir="build/$dir_path"
  mkdir -p "$out_dir"
  
  # Output file
  out="$out_dir/$filename.html"
  echo "Compiling $f -> $out"
  
  pandoc "$f" -o "$out" --css /themes/uyghur-theme.css --to html5 --from markdown --standalone
  
  # Fix links to other markdown files
  sed -i '' 's/\.md"/.html"/g' "$out"
  sed -i '' "s/\.md'/.html'/g" "$out"
done

# Generate a single index.html at build/
echo "Generating single index.html..."
index_file="build/index.html"
echo '<link rel="stylesheet" href="/themes/uyghur-theme.css" /><h1>Home page — Yenghi-saani</h1>' > "$index_file"
cat templates/header.html >> "$index_file"
echo "<h2>Table of content</h2>" >> "$index_file"
echo "<ul>" >> "$index_file"

# Loop over all html files recursively, except index.html
find build -name "*.html" ! -name "index.html" | while read -r f; do
    # Get relative path to build/
    rel_path="${f#build/}"
    echo "<li><a href=\"$rel_path\">$rel_path</a></li>" >> "$index_file"
done

echo "</ul>" >> "$index_file"
echo "Done!"
