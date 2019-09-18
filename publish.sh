
#!/bin/sh

cd ../gitbook_study

cp ./docs/asserts/img/favicon.ico ./_book/gitbook/images/favicon.ico
cp ./docs/asserts/img/apple-touch-icon-precomposed-152.png ./_book/gitbook/images/apple-touch-icon-precomposed-152.png

git add .
git commit -m '1'
git push

cp -r _book/* ../quding2012.github.io

cd ../quding2012.github.io
git add .
git commit -m '1'
git push


cp -r _book/* ../quding0308.coding.me

cd ../quding0308.coding.me
git add .
git commit -m '1'
git push
