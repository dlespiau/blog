#!/bin/bash -e

hugo

if [ -z "$CI" ]; then

# Not on CI
git_url="git@github.com:dlespiau/dlespiau.github.io.git"

else

# CI
git_url="https://${GITHUB_TOKEN}@github.com/dlespiau/dlespiau.github.io.git"

echo "==> setting up git"
git config --global user.email "damien.lespiau+bot@gmail.com"
git config --global user.name "Release Bot"

fi

echo "==> cloning site"
git clone $git_url deploy

echo "==> deploying site"
cp -r public/* deploy/
(cd deploy && git add . && git commit -m "automatic site publication" && git push)
rm -rf deploy
