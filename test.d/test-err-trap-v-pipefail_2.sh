#!/bin/bash -x
set -o pipefail

gh auth logout

trap_err(){ local - err_ec="$?"; : 'exit code:' "$err_ec"; }
trap trap_err ERR

trap_exit(){ local - exit_ec="$?"; : 'exit code:' "$exit_ec"; }
trap trap_exit EXIT

#gh auth status
#echo exit, gh auth status, $?

#get_gh_auth_stat=$( gh auth status )

count_gh_auth_checkmarks=$( gh auth status |& grep --only $'\xe2\x9c\x93' | wc -l )

echo foo $LINENO

builtin exit $LINENO

###
