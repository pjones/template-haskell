#!/usr/bin/env bash

# Script to rename files and update project name after creating a repo
# from a template repo.

set -eu
set -o pipefail

repo_name=$(basename "$(pwd)")
year=$(date +%Y)

mkdir -p src
mv hs-template-name.cabal "$repo_name.cabal"
sed -i -e "s/:YEAR:/$year/g" "$repo_name.cabal"

find . \
  -name .git -prune -o \
  -type f -exec sed -i -e "s/hs-template-name/$repo_name/g" '{}' ';'
