for html in build/*.html; do
  echo Removing $html ...
  rm $html
done

for f in *.md; do
  echo Compiling $f ...
  out="build/${f%.md}.html"
  pandoc "$f" -o "$out" --css uyghur-theme.css --to html5 --from markdown --standalone
  
  sed -i '' 's/\.md"/.html"/g' "$out"
  sed -i '' "s/\.md'/.html'/g" "$out"
done
