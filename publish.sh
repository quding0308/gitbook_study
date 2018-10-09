
#!/bin/sh

cd ../gitbook_study
git add .
git commit -m '1'
git push

cp -r _book/* ../quding2012.github.io

cd ../quding2012.github.io
git add .
git commit -m '1'
git push
