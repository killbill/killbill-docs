#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USERGUIDE_INPUT_DIR=$DIR/userguide
FAQ_INPUT_DIR=$DIR/faq
BUILD_DIR=$DIR/build

rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR
asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/userguide_platform.adoc
asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/userguide_subscription.adoc
asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/userguide_payment.adoc
asciidoctor -B $FAQ_INPUT_DIR -D $BUILD_DIR $FAQ_INPUT_DIR/faq.adoc
#asciidoctor -B $USERGUIDE_INPUT_DIR -D $BUILD_DIR $USERGUIDE_INPUT_DIR/bitcoin.adoc
echo "open $BUILD_DIR/userguide_payment.html $BUILD_DIR/userguide_platform.html $BUILD_DIR/userguide_subscription.html $BUILD_DIR/faq.html"
