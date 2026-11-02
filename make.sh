#!/bin/bash -e
# CI runs "bash make.sh", which ignores the -e in the shebang line
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Actual content
USERGUIDE_INPUT_DIR=$DIR/userguide
BUILD_DIR=$DIR/build
SELFCONTAINED_BUILD_DIR=$BUILD_DIR/selfcontained

DIR_OPTS="-B $USERGUIDE_INPUT_DIR -D $SELFCONTAINED_BUILD_DIR -a sourcedir=$USERGUIDE_INPUT_DIR -a imagesdir=$USERGUIDE_INPUT_DIR/assets"
EXTRA_OPTS="--trace -w --failure-level WARN -T html5 -a doctype=book -a data-uri -a source-highlighter=pygments"

SELFCONTAINED_BUILD="bundle exec asciidoctor $DIR_OPTS $EXTRA_OPTS"

# Setup
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR

# Copy assets
mkdir -p $SELFCONTAINED_BUILD_DIR/stylesheets $SELFCONTAINED_BUILD_DIR/javascripts
cp -rf stylesheets/* $SELFCONTAINED_BUILD_DIR/stylesheets
cp -rf javascripts/* $SELFCONTAINED_BUILD_DIR/javascripts

# -maxdepth 2 to avoid building the included files (userguide/*/includes)
for doc in `find $USERGUIDE_INPUT_DIR -maxdepth 2 -type f -name '*.adoc'`; do
  echo "Building $doc"
  $SELFCONTAINED_BUILD $doc
done

# Site-root files (robots.txt, sitemap.xml, _headers, _redirects, 404.html).
# update_gh-pages.sh and cloudflare_deploy.sh copy them to the root of the site.
ROOT_BUILD_DIR=$BUILD_DIR/root
mkdir -p $ROOT_BUILD_DIR
cp -f $DIR/static/robots.txt $DIR/static/_headers $DIR/static/_redirects $ROOT_BUILD_DIR/
# Cloudflare Pages serves the closest 404.html for any missing path, so the root copy uses absolute asset paths
sed -e "s#\(href=[\"']\)stylesheets/#\1/latest/stylesheets/#g" -e "s#\(src=[\"']\)javascripts/#\1/latest/javascripts/#g" \
  $SELFCONTAINED_BUILD_DIR/404.html > $ROOT_BUILD_DIR/404.html
# The /latest/ and /<version>/ copies of 404.html are published too: give them the same absolute asset paths
cp -f $ROOT_BUILD_DIR/404.html $SELFCONTAINED_BUILD_DIR/404.html
ruby $DIR/scripts/generate_sitemap.rb $SELFCONTAINED_BUILD_DIR $USERGUIDE_INPUT_DIR $ROOT_BUILD_DIR/sitemap.xml
