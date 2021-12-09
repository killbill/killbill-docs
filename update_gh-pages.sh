#!/bin/bash -e

GH_REF=github.com/killbill/killbill-docs.git
BUILD=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`

cp -r build $BUILD

pushd $BUILD
git clone --depth=5 --branch=gh-pages git://$GH_REF
popd

VERSION=0.24
mkdir -p $BUILD/killbill-docs/$VERSION
cp -f $BUILD/build/selfcontained/* $BUILD/killbill-docs/$VERSION/


pushd $BUILD/killbill-docs
git config user.name "Kill Bill core team"
git config user.email "contact@killbill.io"
git add $VERSION
git commit -m "Docs update (redesign)"
git push -f "https://${GH_TOKEN}:x-oauth-basic@${GH_REF}" gh-pages:gh-pages
popd
