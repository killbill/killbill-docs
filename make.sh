#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Actual content
USERGUIDE_INPUT_DIR=$DIR/userguide
# Common options
COMMON_OPTS="-a sourcedir=$USERGUIDE_INPUT_DIR,imagesdir=$USERGUIDE_INPUT_DIR/assets"
# Selfcontained options
SELFCONTAINED_EXTRA_OPTS="$COMMON_OPTS -T html5 -a stylesheet=kb.css -a stylesdir=../stylesheets"

BUILD_DIR=$DIR/build
SELFCONTAINED_BUILD_DIR=$BUILD_DIR/selfcontained

SELFCONTAINED_BUILD="asciidoctor $SELFCONTAINED_EXTRA_OPTS -B $USERGUIDE_INPUT_DIR -D $SELFCONTAINED_BUILD_DIR -r asciidoctor-diagram -a doctype=book,toc,toclevels=6,data-uri,linkcss!,source-highlighter=pygments,homepage=http://killbill.io"

# Setup
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR

for dir in `find $USERGUIDE_INPUT_DIR -maxdepth 1 -type d \! -name assets \! -name common`; do
  for doc in `find $dir -maxdepth 1 -type f`; do
    echo "Building $doc"
    $SELFCONTAINED_BUILD $doc
  done
done
