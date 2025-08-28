#!/bin/bash

# find-weird-filenames.sh
#
# At a certain point, it\s easier to clearlist all filenames as
# being \Names\ according to Bash syntax rules.

  #set -x
  set -euo pipefail
  shopt -s globstar extglob


#
sudo -v


#
: Define _Fn_get_line_nos_
function _Fn_get_line_nos_ (){
  :;: "enter function ${FUNCNAME[0]}";:

  shopt -s expand_aliases
  alias _Fn_get_files_='_Fn_get_files_ "${LINENO}" '

  :;: "exit function ${FUNCNAME[0]}" ;:
}
_Fn_get_line_nos_



: Define _Fn_get_files_
# Usage: _Fn_get_files_ -$'\n'
#        _Fn_get_files_ --eval
#
function _Fn_get_files_ (){
  :;: "enter function ${FUNCNAME[0]}";:

    : ampersand: "$@"

  local - ec input lin nam #\
    #&& set -x

  if [[ $# -eq 3 ]]
  then
    : $?
    lin=$1
    nam=$2
    shift 2
  elif [[ $# -ne 2 ]]
  then
    : $?
    ec=$?
    printf 'Error, line %d: fn reqs x2 non-lineno arguments.\n' "${lin:-${LINENO}}"
    exit "0${ec}"
  else
    : $?
  fi

  input=$1
  local -a files
  files=( )

  if [[ ${input} == --[^-]* ]]
  then
    : $?
    _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"

  elif [[ ${input} == -[^-]* ]]
  then
    : $?
    _Fn_find_chars_ "${input}"

  elif [[ -z ${input} ]]
  then
    is_null=maybe

  else
    local ec=$?
    : "ec: $ec"
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' "${lin:-${LINENO}}"
    exit "0${ec}"
  fi

  printf 'Test name: %s\n' "${nam}"
  printf 'Input string: %s\n' "${input}"
  printf 'File count: %d\n' "${#files[@]}"
  : printf '<%s>\n' "${files[@]}"
  echo
  return 00

  :;: "exit function ${FUNCNAME[0]}" ;:
}


# Usage: _Fn_find_chars_ "${input}"
#
function _Fn_find_chars_ (){
  :;: "enter function ${FUNCNAME[0]}";:

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

  :;: "exit function ${FUNCNAME[0]}" ;:
}

# Usage: _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"
#
function _Fn_find_IFS_delimd_strings_ (){
  :;: "enter function ${FUNCNAME[0]}";:

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

  mapfile -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep -z --color=always  -Fe "${input}" 2> /dev/null; \
  )
  mapfile -C 1000000 -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep -z --color=always  \
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

  :;: "exit function ${FUNCNAME[0]}" ;:
}



# Characters illegal for filenames in Linux
# /
#_Fn_get_files_ -'/'
#_Fn_get_files_ forward-slash_hex '--\x2f'
#_Fn_get_files_ forward-slash_octal '--\057'

  #exit "${LINENO}"
  #set -x

# <NUL>
#_Fn_get_files_ null_ascii-c $'\\0'
_Fn_get_files_ null_hex '--\x00'

  exit "${LINENO}"
  set -x

# Execution contexts
# exec
_Fn_get_files_ exec_ascii --exec

  exit "${LINENO}"
  set -x

# eval
_Fn_get_files_ --eval

  exit "${LINENO}"
  set -x

# $((
_Fn_get_files_

# $(<
_Fn_get_files_

# ${|
_Fn_get_files_

# ${c
_Fn_get_files_

# ((
_Fn_get_files_

# ))
_Fn_get_files_

# $(
_Fn_get_files_

# ${
_Fn_get_files_

# `
_Fn_get_files_


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
