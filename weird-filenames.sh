#!/bin/bash

# weird-filenames.sh
#
# At a certain point, it\s easier to clearlist all filenames as
# being \Names\ according to Bash syntax rules.

  #<> Debugging
  #set -x #<>
  set -euo pipefail #<>



# Variables

T0=$( date '+%s' )        export T0       # Time
II=0                      export II       # Index
Clr0=$( tput sgr0 )       export Clr0     # Colors  - B&W
Clr5=$( tput setaf 5 )    export Clr5     #         - Blue
Clr46=$( tput setaf 46 )  export Clr46    #         - Yellow
in_clr=y                  export in_clr   # CLI Options - In color
grp_clr='--color=always'  export grp_clr  #             - 
parms_ch=y                export parms_ch #             - Process CLI parms
pr_all=n                  export pr_all   #             - Full report
pr_per=y                  export pr_per   #             - Interactive



# CLI Options

: Define _Fn_help_
function _Fn_help_ (){
  printf '\n\tweird-filenames.sh\n'
  printf '\t  -A  Automated   / print full report\n'
  printf '\t  -G  Grayscale   / no color\n'
  printf '\t  -I  Interactive / print per test [Default]\n'
  printf '\t  -h  Help\n\n'
  builtin exit 002
}

if [[ $# -gt 0 ]]
then
  pos_parms=( ) ii=0

  for pp in "$@"
  do
    pos_parms+=( [ii]=${pp##*-} )
    : $((  ii++  ))

  done \
    && unset pp

  while true
  do

    if [[ ${parms_ch} == n ]]
    then
      break
    fi
    parms_ch=n

    # Handle mashed up options, ie, '-AG' as '-A -G'
    for PP in "${!pos_parms[@]}"
    do

      # Get length of \PP
      len_pp=${#pos_parms[PP]}                  
    
      if [[ ${len_pp} -gt 1 ]]
      then
        : $? #<>

          pos_parms+=( ${pos_parms[PP]:0:1} )
          pos_parms+=( ${pos_parms[PP]:1}   )
          unset "pos_parms[PP]"
          parms_ch=y

      else
        : $? #<>
        continue
      fi
    done \
      && unset PP

  done

  # Note: using an associative array would be faster
  # Note: \sort -R\: ;-p
  mapfile -t pos_parms < <(
    printf '%s\n' "${pos_parms[@]}" \
      | sort \
      | uniq
  )

  for RR in "${!pos_parms[@]}"
  do
    case "-${pos_parms[RR]}" in
      -A    ) pr_all=y pr_per=n ;;
      -G    ) in_clr=n          ;;
      -[Hh] ) _Fn_help_         ;;
      -I    ) pr_per=y pr_all=n ;;
      *     ) _Fn_help_         ;;
    esac
  done \
    && unset RR
fi

  #exit "${LINENO}" #<>
  #echo "${!Clr*}" #<>
  #set -x #<>


# Enable Grayscale option, re CLI
if [[ ${in_clr} = n ]]
then
  # Note: intentional use of word splitting
  # shellcheck disable=SC2206
  colors=( ${!Clr*} )
  declare -n CC

  for CC in "${colors[@]}"
  do
    # shellcheck disable=SC2034
    CC=
    grp_clr='--color=never'
  done \
    && unset -n CC \
    && unset CC colors

    #declare -p ${!Clr*} #<>
fi  

  #exit "${LINENO}" #<>


# \sudo\ is required
reset
sudo -v



######### # # ######### # # #########
## Primary Functions
######### # # ######### # # #########

: Define _Fn_get_line_nos_

# This f\unction, if activated, will let the script print line numbers
#   indicating where the f\unction \Fn_get_files_ was called.
#
function _Fn_get_line_nos_ (){
  :;: "${Clr5}start ${FUNCNAME[0]}${Clr0}";:

  shopt -s expand_aliases
  alias _Fn_get_files_='_Fn_get_files_ "${LINENO}" '

  :;: "${Clr5}finish ${FUNCNAME[0]}${Clr0}" ;:
}
_Fn_get_line_nos_ #<>



: Define _Fn_print_elapsed_t_

# Print with each test header
#
# Usage: _Fn_print_elapsed_t_
#
function _Fn_print_elapsed_t_ (){
  :;: "${Clr5}start ${FUNCNAME[0]}${Clr0}";:

  local - now
  #set -x
  now=$((  $( date '+%s' ) - T0  ))

  printf '%02d:%02d:%02d\n' \
    $((  ( now - ( now % 60**2 ) ) / 60**2  )) \
    $((  ( ( now - ( now % 60 ) ) / 60 ) % 60  )) \
    $((  now % 60  ))

  :;: "${Clr5}finish ${FUNCNAME[0]}${Clr0}" ;:
}

  #sleep 3 #<>
  #_Fn_print_elapsed_t_ #<>
  #exit "${LINENO}" #<>



: Define _Fn_print_input_str_

# Print, input string
#
# Usage: _Fn_print_input_str_ "${input}"
#
function _Fn_print_input_str_ (){
  :;: "${Clr5}start ${FUNCNAME[0]}${Clr0}";:

  local - input
  #set -x
  input=$1

  printf '\t%bInput:%b\t%s\n' "${Clr5}" "${Clr0}" "${input}"

  :;: "${Clr5}finish ${FUNCNAME[0]}${Clr0}" ;:
}



: Define _Fn_get_files_

# This f\unction runs regardless of whether a\liases are enabled; it
#   calls one of two sub-f\unctions.
#
# Usage: _Fn_get_files_ -$'\n'
#        _Fn_get_files_ --eval
#
# Bug? without the \function keyword, bash r\eads Fn definition as alias
#   call?
function _Fn_get_files_ (){
  :;: "${Clr5}start ${FUNCNAME[0]}${Clr0}";:

  local - ec ff input lin nam
  #set -x #<>

    : arobase: "$@" #<>

  # Process positional parameters
  #   If aliases are enabled, there\ll be x3
  if [[ $# -eq 3 ]]
  then
    : $? #<>
    lin=$1
    nam=$2
    shift 2

  # Otherwise, there\ll be x2, so not having x2 is an error
  elif [[ $# -ne 2 ]]
  then
    ec=$?
    : "ec: $ec" #<>
    printf 'Error, lines %d:%d: fn reqs x2 non-lineno arguments.\n' \
      "${lin:-${LINENO}}" "${LINENO}"
    builtin exit "0${ec}"

  # There are x2 pos-parms; \nam is assigned.
  else
    : $? #<>
    nam=$1
    shift
  fi

  # Print per-test header
  printf '\n%bTest:%b %d\n'   "${Clr5}" "${Clr0}" "$((  ++II  ))"
  printf '\t%bName:%b\t%s\n'  "${Clr5}" "${Clr0}" "${nam}"
  printf '\t%bTime:%b\t%s\n'  "${Clr5}" "${Clr0}" "$( _Fn_print_elapsed_t_ )"

  # More variables
  input=$1
  lin=${lin:=}
  local -a files
  files=( )

  # Hardcoded leading hyphens are used to signal which sub-f\unction
  #   is used; two hyphens to search for strings delimited by the
  #   default value of IFS (ie, \Words\)...
  if [[ ${input} == --[^-]* ]]
  then
    : $? #<>
    _Fn_fnd_IFS_delimd_strings_ "${input}" "${lin}"
    input=${input#--}

  # ...and one hyphen to search for non-\word\ tokens.
  elif [[ ${input} == -[^-]* ]]
  then
    : $? #<>
    _Fn_fnd_chars_ "${input}"
    input=${input#-}

  # The <null> byte is a special case.
  elif [[ -z "${input}" ]]
  then
    : $? #<>
    input=$'\\0'

  # Error handling
  else
    local ec=$?
    : "ec: $ec" #<>
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' \
      "${lin:-${LINENO}}"
    builtin exit "0${ec}"
  fi

  # Reset array indices
  files=( "${files[@]}" )

  # Note, printing of the input string is performed in the two
  #   sub-functions, after the value of \input is fully processed.


  # Print, count of found files. If there\s more than one, use yellow.
  local file_count limit yn
  file_count="${#files[@]}"
  limit=${file_count}
  yn=skip

  printf '\t%bCount:%b\t' "${Clr5}" "${Clr0}"

  if [[ ${file_count} -gt 0 ]]
  then
    : $? #<>
    printf '%b%d%b\n' "${Clr46}" "${file_count}" "${Clr0}"

  elif [[ ${file_count} -eq 0 ]]
  then
    : $? #<>
    limit=0
    printf '0\n'

  else
    local ec=$?
    : "ec: $ec" #<>
    printf 'Error, line %d: unreachable code.\n' \
      "${lin:-${LINENO}}"
  fi

    #<> Debug: Set the loop limit for how many file names to print to
    #<>   something r\eadable
    #if [[ "${#files[@]}" -ge 10 ]]; then limit=10; #<>
    #fi #<>

  # Print, each file with index number
  if [[ ${limit} != 0 ]]
  then
    # Bug: \nounset\ doesn\t allow for a gap between \ff\ and \=0\
    for ((  ff=0;  ff <= ( $limit - 1 );  ff++  ))
    do
        #declare -p ff #<>

      printf '\t%d:\t<%s>\n' "${ff}" "${files[$ff]}" \
        | grep -s "${grp_clr}" -Fe "${input}" 2> /dev/null
    done \
      && unset ff

    # Pause to check
    if   [[ ${pr_all} == n ]] \
      || [[ ${pr_per} == y ]]
    then

      printf '\nNext test? [Y/n]\n'
      read -N 1 -r -s -t 600 yn

      case "${yn}" in
        n) builtin exit 000 ;;
        *) :;;
      esac
    fi
  fi

  :;: "${Clr5}finish ${FUNCNAME[0]}${Clr0}" ;:
}



: Define _Fn_fnd_chars_

# Look for strings of certain characters.
#
# Usage: _Fn_fnd_chars_ "${input}"
#
function _Fn_fnd_chars_ (){
  :;: "${Clr5}start ${FUNCNAME[0]}${Clr0}";:

  local - ec input
  #set -x #<>
  input=$1

  # Handle hyphen prefixes
  if [[ ${input} == -[^-]* ]]
  then
    : $? #<>
    input=${input#-}

  else
    ec=$?
    : "ec: $ec" #<>
    printf 'Error, line %d: input is malformed.\n' "${lin:-${LINENO}}"
    builtin exit "0${ec}"
  fi

  # Print, input string
  _Fn_print_input_str_ "${input}"

  # Search
  mapfile -d "" -t files < <(
    sudo find / -nowarn -name '*'"${input}"'*' -print0 2> /dev/null \
  )

  :;: "${Clr5}finish ${FUNCNAME[0]}${Clr0}" ;:
}



: Define _Fn_fnd_IFS_delimd_strings_

# Look for \word\s.
#
# Usage: _Fn_fnd_IFS_delimd_strings_ "${input}" "${lin}"
#
function _Fn_fnd_IFS_delimd_strings_ (){
  :;: "${Clr5}start ${FUNCNAME[0]}${Clr0}";:

  local - ec input loc
  #set -x #<>
  input=$1
  loc=$2

  if [[ ${input} == --[^-]* ]]
  then
    : $? #<>
    input=${input#--}

  else
    ec=$?
    : "ec: $ec" #<>
    printf 'Error, line %d: fn reqs x1 non-lineno argument.\n' \
      "${loc:-${LINENO}}"
    builtin exit "0${ec}"
  fi

  # Print, input string
  _Fn_print_input_str_ "${input}"

  # Gather
  mapfile -C 0000000 -d "" -t files < <(
    sudo find -nowarn / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep "${grp_clr}" -sz \
        -Fe     "${input}"      2> /dev/null
  )

  mapfile -C 1000000 -d "" -t files < <(
    sudo find -nowarn / -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep "${grp_clr}" -swz \
        -Fe     "${input}"      2> /dev/null
  )

  mapfile -C 2000000 -d "" -t files < <(
    sudo find / -nowarn -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep "${grp_clr}" -sz \
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
    sudo find / -nowarn -name '*'"${input}"'*' -print0 2> /dev/null \
      | grep "${grp_clr}" -swz \
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

  :;: "${Clr5}finish ${FUNCNAME[0]}${Clr0}" ;:
}



######### # # ######### # # #########
## Tests
######### # # ######### # # #########

  #set -x #<>

# Characters illegal f\or filenames in Linux
# /
_Fn_get_files_ forward-slash_ascii '-/'
##_Fn_get_files_ forward-slash_hex '--\x2f'
##_Fn_get_files_ forward-slash_octal '--\057'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# <NUL>
# Note: leading hyphen breaks <null>
_Fn_get_files_ null_ascii-c "$( printf $'\0' )"
##_Fn_get_files_ null_hex     '--\x00'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# Execution contexts
# exec
_Fn_get_files_ exec_ascii --exec
##_Fn_get_files_ exec_hex-1 '--\x65x78x65x63'
##_Fn_get_files_ exec_hex-2 '--\x65786563'
##_Fn_get_files_ exec_octal '--\145170145143'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# eval
_Fn_get_files_ eval_ascii --eval
##_Fn_get_files_ eval_hex-1 '--\x65x76x61x6c'
##_Fn_get_files_ eval_hex-2 '--\x6576616c'
##_Fn_get_files_ eval_octal '--\145166141154'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# $((
_Fn_get_files_ arith-expan-1_ascii '-$(('

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# $(<
_Fn_get_files_ com-sub-1_ascii '-$(<'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# ${|
_Fn_get_files_ com-sub-2_ascii '-${|'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# ${c
_Fn_get_files_ com-sub-3_ascii '-${c'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# ((
_Fn_get_files_ arith-expan-2a_ascii '-(('

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# ))
_Fn_get_files_ arith-expan-2b_ascii '-))'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# $(
_Fn_get_files_ com-sub-4_ascii '-$('

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# ${
_Fn_get_files_ com-sub-5_ascii '-${'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# `
_Fn_get_files_ backtick_ascii '-`'
##_Fn_get_files_ backtick_hex   '--\x60'
##_Fn_get_files_ backtick_octal '--\140'

  #builtin exit "${LINENO}" #<>
  #set -x #<>


# Bash 5.2 Control operators (which are not also single metac\haracters)
# ;;&
_Fn_get_files_ case-1_ascii '-;;&'

# ;;
_Fn_get_files_ case-2_ascii '-;;'

# ||
_Fn_get_files_ if-or_ascii '-||'

# &&
_Fn_get_files_ if-and_ascii '-&&'

# ;&
_Fn_get_files_ case-3_ascii '-;&'

# |&
_Fn_get_files_ redir-01_ascii '-|&'


# Bash 5.2 Redirection operators (which are not also single metac\haracters)
# <&digit-
_Fn_get_files_ redir-02_ascii '-<&[0-9]+-'

# >&digit-
_Fn_get_files_ redir-03_ascii '-<&[0-9]+-'

# <&-
_Fn_get_files_ redir-04_ascii '-<&-'

# >&-
_Fn_get_files_ redir-05_ascii '->&-'

# <<<
_Fn_get_files_ redir-06_ascii '-<<<'

# &>>
_Fn_get_files_ redir-07_ascii '-&>>'

# <<-
_Fn_get_files_ redir-08_ascii '-<<-'

# <<
_Fn_get_files_ redir-09_ascii '-<<'

# >>
_Fn_get_files_ redir-10_ascii '->>'

# <&
_Fn_get_files_ redir-11_ascii '-<&'

# >&
_Fn_get_files_ redir-12_ascii '->&'

# >|
_Fn_get_files_ redir-13_ascii '->|'

# >&
_Fn_get_files_ redir-14_ascii '->&'

# &>
_Fn_get_files_ redir-15_ascii '-&>'


# POSIX-2024 Shell metac\haracters

# <newline> $'\n'
_Fn_get_files_ newline_ascii "-$'\\n'"

# <tab> $'\t'
_Fn_get_files_ tab_ascii "-$'\\t'"

# <space> " "
_Fn_get_files_ space_ascii "-$' '"

# &
_Fn_get_files_ ampersand_ascii '-&'

# |
_Fn_get_files_ pipe_ascii '-|'

# ;
_Fn_get_files_ semi-colon_ascii '-;'

# <
_Fn_get_files_ left-arrow_ascii '-<'

# >
_Fn_get_files_ right-arrow_ascii '->'

# (
_Fn_get_files_ left-parenthesis_ascii '-('

# )
_Fn_get_files_ right-parenthesis_ascii '-)'


# POSIX-2024 Shell line continuation
# \$'\n'
_Fn_get_files_ line-continuation_ascii "-\\$'\\n'"


# POSIX-2024 Quoting c\haracters
# $'
_Fn_get_files_ ansi-c-quoting_ascii "-$'"

# $"
_Fn_get_files_ locale-translation_ascii '-$"'

# \
_Fn_get_files_ backslash_ascii '-\'

# '
_Fn_get_files_ single-quote_ascii "-'"

# "
_Fn_get_files_ double-quote_ascii '-"'


# Shell comment c\haracters
# '#' hash comment
_Fn_get_files_ hash_ascii '-#'

# ': ' colon comment(rare)
_Fn_get_files_ colon_ascii '-:'


# Bash 5.2 Reserved Words
# function
#_Fn_get_files_ _ascii '-'

# coproc
#_Fn_get_files_ _ascii '-'

# select
#_Fn_get_files_ _ascii '-'

# until
#_Fn_get_files_ _ascii '-'

# while
#_Fn_get_files_ _ascii '-'

# case
#_Fn_get_files_ _ascii '-'

# done
#_Fn_get_files_ _ascii '-'

# elif
#_Fn_get_files_ _ascii '-'

# else
#_Fn_get_files_ _ascii '-'

# esac
#_Fn_get_files_ _ascii '-'

# then
#_Fn_get_files_ _ascii '-'

# time
#_Fn_get_files_ _ascii '-'

# for
#_Fn_get_files_ _ascii '-'

# [[
#_Fn_get_files_ _ascii '-'

# ]]
#_Fn_get_files_ _ascii '-'

# do
#_Fn_get_files_ _ascii '-'

# if
#_Fn_get_files_ _ascii '-'

# in
#_Fn_get_files_ _ascii '-'

# fi
#_Fn_get_files_ _ascii '-'

# {
_Fn_get_files_ left_brace_ascii '-{'

# }
_Fn_get_files_ right_brace_ascii '-}'

# !
_Fn_get_files_ bang_ascii '-!'


# Pathname expansion c\haracters (globs)
# *
_Fn_get_files_ asterisk_ascii "-$'*'"

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# ?
_Fn_get_files_ question_ascii "-$'?'"

# [:
_Fn_get_files_ collation-class-1_ascii '-[:'

# :]
_Fn_get_files_ collation_class-2_ascii '-:]'

  #builtin exit "${LINENO}" #<>
  #set -x #<>

# [
_Fn_get_files_ left_bracket_ascii '-['

# ]
_Fn_get_files_ right_bracket_ascii '-]'

  #builtin exit "${LINENO}" #<>
  #set -x #<>


# Bash 5.2 Extglobs
#

# Tilde expansion c\haracters (globs)
# ~+digit
#_Fn_get_files_ _ascii '-'

# ~-digit
#_Fn_get_files_ _ascii '-'

# ~digit
#_Fn_get_files_ _ascii '-'

# ~+
_Fn_get_files_ tilde-1_ascii '-~+'

# ~-
_Fn_get_files_ tilde-2_ascii '-~-'

# ~
_Fn_get_files_ tilde-3_ascii '-~'


# Brace Expansion c\haracters
# {,
_Fn_get_files_ brace-expansion-1_ascii '-{,'

# ,}
_Fn_get_files_ brace-expansion-2_ascii '-,}'

# ,
#_Fn_get_files_ comma_ascii '-,'


# Parameter Expansion c\haracters
# ${
_Fn_get_files_ param-expans-1_ascii '-${'


# Bash 5.2 Special Parameters
# $*
_Fn_get_files_ sp_asterisk_ascii '-$*'

# $@
_Fn_get_files_ sp_arobase_ascii '-$@'

# $#
_Fn_get_files_ sp_hash_ascii '-$#'

# $?
_Fn_get_files_ sp_question_ascii '-$?'

# $-
_Fn_get_files_ sp_dash_ascii '-$-'

# $$
_Fn_get_files_ sp_dollar_ascii '-$$'

# $!
_Fn_get_files_ sp_bang_ascii '-$!'

# $0
_Fn_get_files_ sp_zero_ascii '-$0'


# Others
# _
#_Fn_get_files_ underscore_ascii '-_'

# %
_Fn_get_files_ percent_ascii '-%'

# ^
_Fn_get_files_ carrat_ascii '-^'

# =
_Fn_get_files_ equals_ascii '-='

# +
_Fn_get_files_ plus_ascii '-+'

# .
_Fn_get_files_ period_ascii "-$'.'"

# /
_Fn_get_files_ backslash_ascii "-$'\'"


# Bourne Special Builtins

# Bash 5.2 Shell Builtins


builtin exit 000
