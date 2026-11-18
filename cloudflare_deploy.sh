#!/usr/bin/env bash

# Check if Gemfile exists (no need to build on gh-pages)
if [ -f Gemfile ]
then
    ./make.sh
    cp -fr build/selfcontained/* build/
    mv build/selfcontained build/latest
    # Site-root files (see make.sh); the root 404.html replaces the copy from selfcontained
    cp -fr build/root/* build/
    rm -rf build/root
else
    rm -f .gitignore latest.txt *.sh

    ALL_BUILT_FILES_TMP_DIR=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`
    mv * $ALL_BUILT_FILES_TMP_DIR/

    mkdir -p build/latest
    mv $ALL_BUILT_FILES_TMP_DIR/* build/
fi
