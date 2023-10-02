#!/bin/bash -x

set -o pipefail

trap_err(){ local - ec="$?"; : 'exit code:' "$ec"; }

get_gh_auth_stat=$( gh auth status )

count_gh_auth_checkmarks=$( gh auth status |& grep --only $'\xe2\x9c\x93' | wc -l )

builtin exit $LINENO

