#!/bin/sh


SCRIPTNAME=${0##*/}

usage() {
    echo "$SCRIPTNAME <URI (grep pattern)> <cache directory>."
}

get_cache_files() {
    find $2 -maxdepth 1 -type d | xargs  grep -ERl "^KEY:.*$1" | sort -u
} 

nginx_cache_purge_item() {
    local cache_files

    [ -d $2 ] || exit 2
    cache_files=$(get_cache_files "$1" $2)

    ## Act based on grep result.
    if [ -n "$cache_files" ]; then
        ## Loop over all matched items.
        for i in $cache_files; do
            [ -f $i ] || continue
            echo "Deleting $i from $2."
            rm $i
        done
    else
        echo "$1 is not cached."
        exit 3
    fi
}


## Check the number of arguments.
if [ $# -ne 2 ]; then
    usage
    exit 1
fi

nginx_cache_purge_item $1 $2


