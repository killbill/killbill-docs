#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USERGUIDE_INPUT_DIR=$DIR/userguide
FAQ_INPUT_DIR=$DIR/faq
BUILD_DIR=$DIR/build

rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR
asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/userguide.adoc
asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/payments.adoc
asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/bitcoin.adoc
asciidoctor -B $FAQ_INPUT_DIR -D $BUILD_DIR $FAQ_INPUT_DIR/faq.adoc
echo "open $BUILD_DIR/userguide.html $BUILD_DIR/faq.html $BUILD_DIR/payments.html"
