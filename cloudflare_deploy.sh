#!/usr/bin/env bash

# Check if Gemfile exists (no need to build on gh-pages)
if [ -f Gemfile ]
then
    ./make.sh
    cp -fr build/selfcontained/* build/
    mv build/selfcontained build/latest
else
    rm -f .gitignore latest.txt *.sh

    ALL_BUILT_FILES_TMP_DIR=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`
    mv * $ALL_BUILT_FILES_TMP_DIR/

    mkdir -p build/latest
    mv $ALL_BUILT_FILES_TMP_DIR/* build/
    # For relative links
    cp -r build/javascripts build/latest/
    cp -r build/stylesheets build/latest/
fi
