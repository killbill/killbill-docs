#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Actual content
USERGUIDE_INPUT_DIR=$DIR/userguide
BUILD_DIR=$DIR/build
SELFCONTAINED_BUILD_DIR=$BUILD_DIR/selfcontained

DIR_OPTS="-B $USERGUIDE_INPUT_DIR -D $SELFCONTAINED_BUILD_DIR -a sourcedir=$USERGUIDE_INPUT_DIR -a imagesdir=$USERGUIDE_INPUT_DIR/assets"
EXTRA_OPTS="--trace -w --failure-level WARN -T html5 -a doctype=book -a data-uri"

SELFCONTAINED_BUILD="bundle exec asciidoctor $DIR_OPTS $EXTRA_OPTS"

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
