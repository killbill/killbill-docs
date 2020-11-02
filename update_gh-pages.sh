#!/bin/bash -e

GH_REF=github.com/killbill/killbill-docs.git
BUILD=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`

cp -r build index.html $BUILD

pushd $BUILD
git clone --depth=5 --branch=gh-pages git://$GH_REF
popd

VERSION=$(cat $BUILD/killbill-docs/latest.txt)
mkdir -p $BUILD/killbill-docs/$VERSION
mkdir -p $BUILD/killbill-docs/latest
cp -f $BUILD/index.html $BUILD/build/selfcontained/* $BUILD/killbill-docs/$VERSION/
# This will also copy the manually generated files (*.xsd, ddl.sql)
cp -f $BUILD/killbill-docs/$VERSION/* $BUILD/killbill-docs/latest/

pushd $BUILD/killbill-docs
git config user.name "Kill Bill core team"
git config user.email "contact@killbill.io"
git add $VERSION
git add latest
git commit -m "Docs update"
git push -f gh-pages:gh-pages
popd
