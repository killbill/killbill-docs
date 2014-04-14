TEMP_DIR=$(mktemp -d /tmp/output.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }
GH_PAGES=gh-pages

check_branch_exists () {
        if ! git show-ref --verify --quiet refs/heads/$1 >/dev/null
        then
                echo >&2 "Checkout branch $1 first"
                exit 1
        fi
}

require_clean_work_tree () {
        git rev-parse --verify HEAD >/dev/null || exit 1
        git update-index -q --ignore-submodules --refresh
        err=0

        if ! git diff-files --quiet --ignore-submodules
        then
                echo >&2 "Cannot $1: You have unstaged changes."
                err=1
        fi

        if ! git diff-index --cached --quiet --ignore-submodules HEAD --
        then
                if [ $err = 0 ]
                then
                    echo >&2 "Cannot $1: Your index contains uncommitted changes."
                else
                    echo >&2 "Additionally, your index contains uncommitted changes."
                fi
                err=1
        fi

        if [ $err = 1 ]
        then
                test -n "$2" && echo >&2 "$2"
                exit 1
        fi
}
