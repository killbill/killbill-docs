#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Actual content
# Actual content
USERGUIDE_INPUT_DIR=$DIR/userguide
# Common options
COMMON_OPTS="-a sourcedir=$USERGUIDE_INPUT_DIR -a imagesdir=$USERGUIDE_INPUT_DIR/assets"
# Selfcontained options
SELFCONTAINED_EXTRA_OPTS="$COMMON_OPTS -T html5 -a stylesheet=kb.css -a stylesdir=../stylesheets -a source-highlighter=pygments -a pygments-style=monokai"

BUILD_DIR=$DIR/build
SELFCONTAINED_BUILD_DIR=$BUILD_DIR/

SELFCONTAINED_BUILD="bundle exec asciidoctor --trace $SELFCONTAINED_EXTRA_OPTS -B $USERGUIDE_INPUT_DIR -D $SELFCONTAINED_BUILD_DIR -a doctype=book -a data-uri -a linkcss! -a homepage=https://killbill.io"


# Setup
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR

# Copy assets
mkdir -p $SELFCONTAINED_BUILD_DIR/stylesheets $SELFCONTAINED_BUILD_DIR/javascripts
cp -rf stylesheets/* $SELFCONTAINED_BUILD_DIR/stylesheets
cp -rf javascripts/* $SELFCONTAINED_BUILD_DIR/javascripts

# -maxdepth 2 to avoid building the included files (userguide/*/includes)
for doc in `find $USERGUIDE_INPUT_DIR -type f -name '*.adoc' -maxdepth 2`; do
  echo "Building $doc"
  $SELFCONTAINED_BUILD $doc
done
