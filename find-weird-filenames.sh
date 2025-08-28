#!/bin/bash

# find-weird-filenames.sh
#
# At a certain point, it\s easier to clearlist all filenames be 
# \Names\ according to Bash syntax rules. 

  set -x
  set -euo pipefail
  shopt -s globstar extglob



sudo -v 


#
#
function _Fn_get_line_nos_ (){
  shopt -s expand_aliases
  alias _Fn_get_files_='_Fn_get_files_ "${LINENO}" '
}
_Fn_get_line_nos_



# Usage: ecco STRING
#
#ecco(){
  #printf '%b' "$1" \
    #| xxd -ps
#
  #printf '%b' "$1" \
    #| cat -A
#}
#export -f ecco


# Usage: _Fn_get_files_ -$'\n'
#        _Fn_get_files_ --eval
#
function _Fn_get_files_ (){
  local - ec input lin \
    && set -x
  
  if [[ $# -eq 2 ]]
  then
    : $?
    lin=$1
    shift
  elif [[ $# -ne 1 ]]
  then
    : $?
    ec=$?
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' "${lin:-${LINENO}}"
    exit "0${ec}"
  else
    : $?
  fi

  input=$1
  #ecco "${input}" \
    #| awk '
  #NR==1 {
      #line1=$0
    #} 
  #NR==2 {
      #line2=$0
      #exit
    #} 
  #END {
      #if (line1==line2) 
        #print "Lines are identical"
      #else 
        #print "Lines are different"
    #}'
    #return 101

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

  printf 'File count: %d\n' "${#files[@]}"
  printf '<%s>\n' "${files[@]}"
  return 00
}


# Usage: _Fn_find_chars_ "${input}"
#
function _Fn_find_chars_ (){
  local ec input - \
    && set -x
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
}

# Usage: _Fn_find_IFS_delimd_strings_ "${input}" "${lin}"
#
function _Fn_find_IFS_delimd_strings_ (){
  local ec input loc - \
    && set -x
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
    sudo find / -name '*'"${input}"'*' -print0 2>&1 \
      | grep -z --color=always  \
        -Fe     "${input}" 2> /dev/null

    sudo find / -name '*'"${input}"'*' -print0 2>&1 \
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
}



# Characters illegal for filenames in Linux
# /
#_Fn_get_files_ -'/'
_Fn_get_files_ '--\x2f'

  exit "${LINENO}"
  set -x

# <NUL>
#_Fn_get_files_ $'\\0'
_Fn_get_files_ --x00

  exit "${LINENO}"
  set -x

# Execution contexts
# exec
_Fn_get_files_ --exec

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
