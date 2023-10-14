#!/bin/bash -x

gh auth logout

set -o pipefail

trap_err(){ local - ec="$?"; : 'exit code:' "$ec"; }
trap trap_err ERR

get_gh_auth_stat=$( gh auth status )

count_gh_auth_checkmarks=$( gh auth status |& grep --only $'\xe2\x9c\x93' | wc -l )

builtin exit $LINENO

###

[liveuser@localhost-live LiveUsb]$ ./test/test-err-trap-v-pipefail.sh
+ gh auth logout
not logged in to any hosts
+ set -o pipefail
+ trap trap_err ERR
++ gh auth status
You are not logged into any GitHub hosts. Run gh auth login to authenticate.
+ get_gh_auth_stat=
++ trap_err
++ local - ec=1
++ : 'exit code:' 1
++ gh auth status
++ grep --only ✓
++ wc -l
+ count_gh_auth_checkmarks=0
++ trap_err
++ local - ec=1
++ : 'exit code:' 1
+ builtin exit 14

