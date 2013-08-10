#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INPUT_DIR=$DIR/userguide
BUILD_DIR=$DIR/build

rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR
asciidoctor -B $INPUT_DIR -D $BUILD_DIR $INPUT_DIR/userguide.adoc
echo "open $BUILD_DIR/userguide.html"
