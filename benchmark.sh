#!/bin/bash

abs_dirname() {
    local cwd="$(pwd)"
    local path="$1"

    while [ -n "$path" ]; do
	cd "${path%/*}"
	local name="${path##*/}"
	path="$(readlink "$name" || true)"
    done

    pwd -P
    cd "$cwd"
}

SCRIPT_DIR="$(abs_dirname "$0")"

param=$1
HTMLDIR=/var/www/html/logs
#LOG_BASE_DIR=/root/.tsung/log
CONFIG=$SCRIPT_DIR/conf/benchmark.xml

if [[ $# -ne 1 ]]; then
    echo "usage $0 (start|stop|status)"
    exit 1
fi

tsung -l $HTMLDIR -f $CONFIG $param

if [ "$param" == "start" ]; then
    logdir=`ls -lst ${HTMLDIR}/ |grep root |head -n 1 |awk '{print $10}'`
    cd $HTMLDIR/$logdir
    tsung_stats.pl --dygraph --stats ./tsung.log
    echo 
fi
