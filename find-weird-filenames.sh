#!/bin/bash

# find-weird-filenames.sh
#
# At a certain point, it\s easier to clearlist all filenames be 
# \Names\ according to Bash syntax rules. 

  set -x
  set -euo pipefail
  shopt -s globstar extglob



sudo -v 


# Usage: _Fn_find_chars_ "${input}"
#
function _Fn_find_chars_ (){
  local input
  input=$1

  mapfile -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0
  )
}

# Usage: _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"
#
function _Fn_find_IFS_delimd_strings_ (){
  local input loc
  input=$1
  loc=$2

  if [[ ${input} == --?* ]]
  then
    input=${input#--}
  else
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n'
    exit "${lin:-${LINENO}}"
  fi

  mapfile -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2>&1 \
      | grep -Ez                \
        -e  '\<'"${input}"'\>'  \
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
        -e $'\n'"${input}"$'\n'
  )
}


# Usage: _Fn_get_files_ -$'\n'
#        _Fn_get_files_ --eval
#
function _Fn_get_files_ (){
  local - \
    && set -x
  
  if [[ $# -eq 2 ]]
  then
    local lin
    lin=$1
    shift
  elif [[ $# -ne 1 ]]
  then
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n'
    exit "${lin:-${LINENO}}"
  fi

  local input
  input=$1
  local -a files
  file=( )

  if [[ ${input} =~ ([A-Za-z]+) ]]
  then
    _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"
  else
    _Fn_find_chars_ "${input}"
  fi

  printf '%d' "${#files[@]}"
  return 00
}


#
#
function _Fn_get_line_nos_ (){
  shopt -s expand_aliases
  alias _Fn_get_files='_Fn_get_files_ "${LINENO}" '
}
_Fn_get_line_nos_



# Characters illegal for filenames in Linux
# /
_Fn_get_files_ '/'

# <NUL>
_Fn_get_files_ $'\0'

# Execution contexts
# exec
_Fn_get_files_ "exec"

# eval
_Fn_get_files_ "eval"

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
