#!/bin/bash

# find-weird-filenames.s
#
# At a certain point, it's easier to clearlist all filenames be 
# "Names" according to Bash syntax rules. 

  set -x
  set -euo pipefail
  shopt -s globstar extglob



# Characters illegal for filenames in Linux
# /
# $'\0'

# Execution contexts
# exec
# eval
# $((
# $(<
# ${|
# ${c
# ((
# ))
# $(
# ${
# `

# Bash 5.2 Control operators (which are not also single metacharacters)
# ;;&
# ;;
# ||
# &&
# ;&
# |&

# Bash 5.2 Redirection operators (which are not also single metacharacters)
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

# POSIX-2024 Shell metacharacters

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

# POSIX-2024 Quoting characters
# $'
# $"
# /
# '
# "

# Shell comment characters
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

# Pathname expansion characters (globs)
# *
# ?
# [:
# :]
# [
# ]

# Bash 5.2 Extglobs
# 

# Tilde expansion characters (globs)
# ~+digit
# ~-digit
# ~digit
# ~+
# ~-
# ~

# Brace Expansion characters
# {,
# ,}
# ,

# Parameter Expansion characters
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
