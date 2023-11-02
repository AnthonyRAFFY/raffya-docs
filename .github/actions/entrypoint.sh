#!/bin/sh

set -x
set -e

echo "Building mkdocs static pages..."

chmod -R a+w "${GITHUB_WORKSPACE}"

pip install -r requirements.txt

mkdocs build

echo "Build complete"