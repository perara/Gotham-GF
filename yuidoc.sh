yuidoc ./** --syntaxtype coffee -e .coffee --outdir docs --themedir ../Backend/node_modules/yuidoc-bootstrap-theme --helpers ../Backend/node_modules/yuidoc-bootstrap-theme/helpers/helpers.js
mv ./docs ../tmp_docs
git checkout gh-pages
mv ../tmp_docs/* ./
git checkout master