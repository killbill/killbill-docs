#!/bin/bash -e

source utils.sh

JAVADOC_DIR=javadoc

check_branch_exists $GH_PAGES
require_clean_work_tree "javadocs"

function generate_javadocs () {
        repo=$1
        tag=$2

        pushd $TEMP_DIR

        git clone git@github.com:killbill/$repo.git
        pushd $repo

        if [ -z $tag ]; then
                tag=$(git describe --abbrev=0 --tags)
        fi

        git checkout -b $tag $tag
        mvn javadoc:aggregate

        cp -r target/site/apidocs $TEMP_DIR/$tag

        popd
        rm -rf $repo

        popd
}

generate_javadocs killbill-api
generate_javadocs killbill-plugin-api

git checkout $GH_PAGES

mkdir -p $JAVADOC_DIR
mv -f $TEMP_DIR/* $JAVADOC_DIR
rm -rf $TEMP_DIR

pushd $JAVADOC_DIR
rm -f index.*

cat<<eos > index.adoc
= JavaDocs
:data-uri:
:linkcss!:

eos

for tag in `ls -1 . | grep -v index.adoc`; do
  echo "* link:$tag/index.html[$tag]" >> index.adoc
done

popd

asciidoctor $JAVADOC_DIR/index.adoc
rm -f $JAVADOC_DIR/index.adoc

git add . && git commit -s -m "JavaDocs update" && git push origin $GH_PAGES && git checkout master
