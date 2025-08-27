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

# Usage: _Fn_find_words_ "${input}"
#
function _Fn_find_words_ (){
  local input
  input=$1
  mapfile -d "" -t files < <(
    sudo find / -name '*'"${input}"'*' -print0 2>&1 \
      | grep -Eze '\<'"${input}"'\>'
  )
}


# Usage: _Fn_get_files_ $'\n'
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
    _Fn_find_words_ "${input}"
  else
    _Fn_find_chars_ "${input}"
  fi

  printf '%d' "${#files[@]}"
  return 00
}


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
