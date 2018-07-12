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
cp -f $BUILD/build/selfcontained/* $BUILD/killbill-docs/latest/

pushd $BUILD/killbill-docs
git config user.name "Travis-CI"
git config user.email "travis@killbill.io"
git add $VERSION
git add latest
git commit -m "Docs update"
git push -fq "https://${GH_TOKEN}@${GH_REF}" gh-pages:gh-pages > /dev/null 2>&1
popd
