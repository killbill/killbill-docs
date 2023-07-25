#!/usr/bin/env bash

# Check if Gemfile exists (no need to build on gh-pages)
if [ -f Gemfile ]
then
    ./make.sh
else
    rm -f .gitignore latest.txt *.sh

    ALL_BUILT_FILES_TMP_DIR=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`
    mv * $ALL_BUILT_FILES_TMP_DIR/

    mkdir -p build/selfcontained
    mv $ALL_BUILT_FILES_TMP_DIR/* build/selfcontained/
fi
