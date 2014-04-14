#!/bin/bash -e

source utils.sh

check_branch_exists $GH_PAGES
require_clean_work_tree "release"

source make.sh

mv $BUILD_DIR/* $TEMP_DIR
echo "Files staged in $TEMP_DIR"

git checkout $GH_PAGES && mv $TEMP_DIR/* . && git add . && git commit -s -m "Docs update" && git push origin $GH_PAGES && git checkout master
rm -rf $TEMP_DIR
