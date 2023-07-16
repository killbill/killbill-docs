#!/bin/bash -e

GH_REF=github.com/killbill/killbill-docs.git
BUILD=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`

cp -r build $BUILD

pushd $BUILD
git clone --depth=5 --branch=gh-pages https://$GH_REF
popd

VERSION=$(cat $BUILD/killbill-docs/latest.txt)
mkdir -p $BUILD/killbill-docs/$VERSION
mkdir -p $BUILD/killbill-docs/latest
cp -f $BUILD/build/selfcontained/index.html $BUILD/killbill-docs/
cp -f $BUILD/build/selfcontained/* $BUILD/killbill-docs/$VERSION/
# This will also copy the manually generated files (*.xsd, ddl.sql)
cp -f $BUILD/killbill-docs/$VERSION/* $BUILD/killbill-docs/latest/

pushd $BUILD/killbill-docs
git config user.name "Kill Bill core team"
git config user.email "contact@killbill.io"
git add $VERSION latest index.html
git commit -m "Docs update"
git push -f "https://${GH_TOKEN}:x-oauth-basic@${GH_REF}" gh-pages:gh-pages
popd
