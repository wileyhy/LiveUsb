#!/bin/bash

# find-weird-filenames.sh
#
# At a certain point, it\s easier to clearlist all filenames as
# being \Names\ according to Bash syntax rules.

  set -x
  set -euo pipefail
  #shopt -s globstar extglob


sudo -v
II=0                  export II
C5=$( tput setaf 5 )  export C5
C0=$( tput sgr0 )     export C0



: Define _Fn_get_line_nos_
# This f\unction, if activated, will let the script print line numbers
# indicating where the f\unction \Fn_get_files_ was called
_Fn_get_line_nos_ (){
  :;: "${C5}start ${FUNCNAME[0]}${C0}";:

  shopt -s expand_aliases
  alias _Fn_get_files_='_Fn_get_files_ "${LINENO}" '

  :;: "${C5}finish ${FUNCNAME[0]}${C0}" ;:
}
#_Fn_get_line_nos_



: Define _Fn_get_files_
# Usage: _Fn_get_files_ -$'\n'
#        _Fn_get_files_ --eval
#
_Fn_get_files_ (){
  :;: "${C5}start ${FUNCNAME[0]}${C0}";:

    : ampersand: "$@"

  local - ec ff input lin nam #\
    #&& set -x

  if [[ $# -eq 3 ]]
  then
    : $?
    lin=$1
    nam=$2
    shift 2
  elif [[ $# -ne 2 ]]
  then
    ec=$?
    : "ec: $ec"
    printf 'Error, lines %d:%d: fn reqs x2 non-lineno arguments.\n' \
      "${lin:-${LINENO}}" "${LINENO}"
    exit "0${ec}"
  else
    : $?
    nam=$1
    shift
  fi

  printf '%bTest %d%b\n' "${C5}" "$((  ++II  ))" "${C0}"
  printf 'Test name:\t%s\n' "${nam}"

  input=$1
  local -a files
  files=( )

  if [[ ${input} == --[^-]* ]]
  then
    : $?
    _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"
    input=${input#--}

  elif [[ ${input} == -[^-]* ]]
  then
    : $?
    _Fn_find_chars_ "${input}"
    input=${input#-}

  elif [[ -z "${input}" ]]
  then
    input=$'\\0'

  else
    local ec=$?
    : "ec: $ec"
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' "${lin:-${LINENO}}"
    exit "0${ec}"
  fi

  printf 'Input string:\t%s\n' "${input}"
  printf 'File count:\t%d\n' "${#files[@]}"
  for ff in "${!files[@]}"
  do
    printf '\t%d:\t<%s>\n' "${ff}" "${files[ff]}" \
      | grep -s --color=always -e "${input}" 2> /dev/null
  done \
    && unset ff
  echo
  return 00

  :;: "${C5}finish ${FUNCNAME[0]}${C0}" ;:
}


: Define _Fn_find_chars_
# Usage: _Fn_find_chars_ "${input}"
#
_Fn_find_chars_ (){
  :;: "${C5}start ${FUNCNAME[0]}${C0}";:

  local ec input - #\
    #&& set -x
  input=$1

  if [[ ${input} == -[^-]* ]]
  then
    : $?
    input=${input#-}
  else
    ec=$?
    : "ec: $ec"
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' "${lin:-${LINENO}}"
    exit "0${ec}"
  fi

  mapfile -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0
  )

  :;: "${C5}finish ${FUNCNAME[0]}${C0}" ;:
}


: Define _Fn_find_IFS_delimd_strings_
# Usage: _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"
#
_Fn_find_IFS_delimd_strings_ (){
  :;: "${C5}start ${FUNCNAME[0]}${C0}";:

  local ec input loc - #\
    #&& set -x
  input=$1
  loc=$2

  if [[ ${input} == --[^-]* ]]
  then
    : $?
    input=${input#--}
  else
    ec=$?
    : "ec: $ec"
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' "${loc:-${LINENO}}"
    exit "0${ec}"
  fi

  # Gather
  mapfile -C 0000000 -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep --color=always -sz \
        -Fe     "${input}"      2> /dev/null
  )

  mapfile -C 1000000 -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep --color=always -swz \
        -Fe     "${input}"      2> /dev/null
  )

  mapfile -C 2000000 -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep --color=always -sz \
        -Ee '\<'"${input}"'\>'  \
        -e  '\b'"${input}"'\b'  \
        -e  '\W'"${input}"'\W'  \
        -e     " ${input} "     \
        -e     " ${input}"$'\t' \
        -e     " ${input}"$'\n' \
        -e $'\t'"${input} "     \
        -e $'\t'"${input}"$'\t' \
        -e $'\t'"${input}"$'\n' \
        -e $'\n'"${input} "     \
        -e $'\n'"${input}"$'\t' \
        -e $'\n'"${input}"$'\n' 2> /dev/null
  )

  mapfile -C 3000000 -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep --color=always -swz \
        -Ee '\<'"${input}"'\>'  \
        -e  '\b'"${input}"'\b'  \
        -e  '\W'"${input}"'\W'  \
        -e     " ${input} "     \
        -e     " ${input}"$'\t' \
        -e     " ${input}"$'\n' \
        -e $'\t'"${input} "     \
        -e $'\t'"${input}"$'\t' \
        -e $'\t'"${input}"$'\n' \
        -e $'\n'"${input} "     \
        -e $'\n'"${input}"$'\t' \
        -e $'\n'"${input}"$'\n' 2> /dev/null
  )

  :;: "${C5}finish ${FUNCNAME[0]}${C0}" ;:
}



######### # # ######### # # #########
## Tests
######### # # ######### # # #########

# Characters illegal f\or filenames in Linux
# /
_Fn_get_files_ forward-slash_ascii '-/'
_Fn_get_files_ forward-slash_hex '--\x2f'
_Fn_get_files_ forward-slash_octal '--\057'

  #exit "${LINENO}"
  #set -x

# <NUL>
# Note: leading hyphen breaks <null>
_Fn_get_files_ null_ascii-c "$( printf $'\0' )"
_Fn_get_files_ null_hex '--\x00'

  #exit "${LINENO}"
  #set -x

# Execution contexts
# exec
_Fn_get_files_ exec_ascii --exec
_Fn_get_files_ exec_hex-1 '--\x65x78x65x63'
_Fn_get_files_ exec_hex-2 '--\x65786563'
_Fn_get_files_ exec_octal-1 '--\145\170\145\143'
_Fn_get_files_ exec_octal-2 '--\145170145143'

  exit "${LINENO}"
  set -x

# eval
_Fn_get_files_ eval_ascii --eval
_Fn_get_files_ eval_hex-1 '--\x65x76x61x6c'
_Fn_get_files_ eval_hex-2 '--\x6576616c'
_Fn_get_files_ eval_octal-1 '--\145\166\141\154'
_Fn_get_files_ eval_octal-2 '--\145166141154'

  exit "${LINENO}"
  set -x

# $((
_Fn_get_files_ arith-expan-1_ascii '-$(('

# $(<
_Fn_get_files_ com-sub-1_ascii '-$(<'

# ${|
_Fn_get_files_ com-sub-2_ascii '-${|'

# ${c
_Fn_get_files_ com-sub-3_ascii '-${c'

# ((
_Fn_get_files_ arith-expan-2a_ascii '-(('

# ))
_Fn_get_files_ arith-expan-2b_ascii '-))'

# $(
_Fn_get_files_ com-sub-4_ascii '-$('

# ${
_Fn_get_files_ com-sub-5_ascii '-${'

# `
_Fn_get_files_ backtick_ascii '-`'
_Fn_get_files_ backtick_hex '--\x60'
_Fn_get_files_ backtick_octal '--\140'


# Bash 5.2 Control operators (which are not also single metac\haracters)
# ;;&
# ;;
# ||
# &&
# ;&
# |&

# Bash 5.2 Redirection operators (which are not also single metac\haracters)
# <&digit-
# >&digit-
# <&-
# >&-
# <<<
# &>>
# <<-
# <<
# >>
# <&
# >&
# >|
# >&
# &>

# POSIX-2024 Shell metac\haracters

# <newline> $'\n'
# <tab> $'\t'
# <space> " "
# &
# |
# ;
# <
# >
# (
# )

# POSIX-2024 Shell line continuation
# \$'\n'

# POSIX-2024 Quoting c\haracters
# $'
# $"
# /
# '
# "

# Shell comment c\haracters
# '#'
# ': ' (rare)

# Bash 5.2 Reserved Words
# function
# coproc
# select
# until
# while
# case
# done
# elif
# else
# esac
# then
# time
# for
# [[
# ]]
# do
# if
# in
# fi
# {
# }
# !

# Pathname expansion c\haracters (globs)
# *
# ?
# [:
# :]
# [
# ]

# Bash 5.2 Extglobs
#

# Tilde expansion c\haracters (globs)
# ~+digit
# ~-digit
# ~digit
# ~+
# ~-
# ~

# Brace Expansion c\haracters
# {,
# ,}
# ,

# Parameter Expansion c\haracters
# ${

# Bash 5.2 Special Parameters
# $*
# $@
# $#
# $?
# $-
# $$
# $!
# $0

# Others
# _
# %
# ^
# =
# +
# :
# .
# /

# Bourne Special Builtins

# Bash 5.2 Shell Builtins
#


exit 000
