#!/bin/bash
#!/bin/env -iS bash

## LiveUsb1
#+ version 1.2

#! Note, Putting a \LN=$nameref_Lineno\, ie, LINENO or \main_lineno=$nameref_Lineno\ assignment
#!   preceding an \exit\ command lets the value of LN or main_lineno
#!   match the line number of the \exit\ command.
#! Note, idempotent script
#! Note, the symbol \<>\ marks code as for debugging purpoeses only
#! Note, ...undocumented feature??
#!     Use \env -i\ or else the script\s execution environment will
#!   inherit any exported anything, including and especially functions,
#!   from its caller, e.g., any locally defined functions (such as \rm\)
#!   which might be intended to shadow any builtins or commands or to
#!   supplant any of the aliases which some of the various Linux
#!   distributions often define and provide for users\ convenience.
#!   These exported functions which are received from the caller\s
#!   environment get printed above the script\s shebang in xtrace when
#!   xtrace and vebose are both enabled on the shebang line. ...but
#!   exported variables do not print.
#!     ...also, using \env\ messes up vim\s default bash-colorizations
#! Note, style, function definition syntax, \(){ :\ makes plain xtrace
#!   easier to read.  ...but it makes the script harder to read....
#! Note, style, \! [[ -e\ doesn\t show the \!\ in xtrace, whereas
#!   \[[ ! -e\ does, and yet, for \grep\.....
#! Note, timestamps, \find\, \stat\ and \[[\ (and \ls\) don\t effect
#!   ext4 timestamps, as tested, but idempotent \chown\ and \chmod\ do,
#!   and of course \touch\ does; if there\s no change in the file,
#!   \rsync\ doesn\t, but if the file changes, it does. Also, \btime\
#!   on ext4 still isn\t consistent. \grep\ has no effect on times.
#!   \cp -a\ effects mes even if file contents do not change.
#!
#! Reportable bug.
#!     \command -p kill $AA\ executes the bash builtin, judging by the
#!   output of \command -p kill\ without any operands. The output of
#!   \$( type -P kill )\ without operands is the same as the output of
#!   /usr/bin/kill without operands. The documentation is ...somewhat
#!   unclear on these points. \help command\: \Runs COMMAND with ARGS
#!   suppressing shell function lookup....\ It seems that what is
#!   intended is, \...suppressing shell function lookup, but still
#!   allowing builtins to be executed,\ and possibly also aliases and
#!   keywords, though I haven\t tested those. The description of the
#!   \-p\ option is particularly misleading: \use a default value for
#!   PATH that is guaranteed to find all of the standard utilities.\
#!   That \guarantee\ sounds as if use of the \-p\ option \shall\
#!   (using the POSIX defition of the word) result in a binary utility
#!   being used, when actually that is not the case.
#!     Binary \kill\ has a few options not available with the builtin,
#!   such as \--timeout\, which can be used to avoid writing an extra
#!   for loop...
#!
#!       sudo -- $( type -P kill ) --verbose \
#!           --timeout 1000 HUP \
#!           --timeout 1000 USR1 \
#!           --timeout 1000 TERM \
#!           --timeout 1000 KILL -- $WW
#!
#!     Otherwise, it would be useful, IMO, if \kill --help\ showed the
#!   help file for /bin/kill, since using that syntax most likely
#!   indicates that intention  :-\
#!
#! ToDo, lock file, bc ^z
#! ToDo, add colors to xtrace comments
#! ToDo, systemd services to disable, bluetooth, cups,
#!   [ systemd-resolved ? ]
#! ToDo, systemd services to possibly enable, sshd, sssd


## Start the script
function _fn_start_script_ ()
{

  ## Get & print script start time
  unset     script_start_time
            script_start_time=$( date +%H:%M:%S )
  readonly  script_start_time

  ## Print script start time
  printf '%s - Executing %s \n' "${script_start_time}" "$0"

  ## Set up non-debug shell options
  hash -r
  shopt -s expand_aliases
  umask 077
}
_fn_start_script_


##
function _fn_setup_aliases_ ()
{
  : "${Color_Comment} Line ${nameref_Lineno}, Aliases, non-debug ${Color_AttributesOff}"
  unset       nameref_Lineno
  unset -n    nameref_Lineno
  local -gnx  nameref_Lineno=L\INENO

  : "${Color_SubComent} Line ${nameref_Lineno}, Aliases TOC, non-debug ${Color_AttributesOff}"

  ##  Alias name
  #+  ~~~~~~~~~~
  #+  _als_die_

  : "${Color_SubComent} Define alias _als_die_ onto function _fn_error_and_exit_() ${Color_AttributesOff}"
  unset       lineno__defin_of_alias_die
              lineno__defin_of_alias_die=$(( nameref_Lineno + 2  ))

  alias _als_die_=': "${Color_AliasFunctionBoundary}" Line ${nameref_Lineno}, alias _als_die_, begin, def Line ${lineno__defin_of_alias_die}

      _fn_error_and_exit_ ${nameref_Lineno}

      : "${Color_AliasFunctionBoundary}" Line ${nameref_Lineno}, alias _als_die_, end "${Color_AttributesOff}" '
}
_fn_setup_aliases_


## Enable debugging
function _fn_enable_debug_parameters_ ()
{

  ## Set up debug shell options
  local -

  : "$( tput setaf 12 ) Debugging $( tput sgr0 )"
  # shellcheck disable=SC1001
  #! Note, this assignment is repeated here; originally it\s located
  #!   in _fn_setup_vars()
  unset       nameref_Lineno
  unset -n    nameref_Lineno
  local -gnx  nameref_Lineno=L\INENO
  # shellcheck disable=SC2218
  {
    builtin set -o allexport
    builtin set -o noclobber
    builtin set -o nounset
    builtin set -o functrace
    builtin set -o errexit
    builtin set -o pipefail
  }

  ## Set up debug colors
  [[ -o xtrace ]] &&
    : "$( tput setaf 12 ) Set up colors for xtrace comments $( tput sgr0 )"
  unset       Color_AttributesOff
              Color_AttributesOff="$( tput sgr0 )"
  readonly    Color_AttributesOff

  ## Digit Color      ## Execution of code regarding...
  ##################################################################
  #  12 blue        ##    Explanatory comments, per major sections
  #  10 light_green ##    Explanatory comments, per-subsection
  # 226 yellow      ##    Explanatory comments, per-sub-subsection
  #  14 light_blue  ##    Aliases at function boundaries
  #  11 orange      ##    Function boundary lines in xtrace
  #   3 brown       ##    Aliases in xtrace
  #   4 purple      ##    Technical comments
  #   8 brick_red   ##    Errors

  ##          Array nm    ## Var sub-name   ## Digit / Color
  ###########################################################
  unset       assoc_arr_Colors
  declare -A  assoc_arr_Colors
              assoc_arr_Colors+=(
                            ["Comment"]="               12 blue"
                            ["SubComent"]="             10 light_green"
                            ["SubSbComent"]="          226 yellow"
                            ["AliasFunctionBoundary"]=" 14 light_blue"
                            ["FnctionBoundry"]="        11 orange"
                            ["XtraceOfAlias"]="          3 brown"
                            ["TechCmnt"]="               4 purple"
                            ["Errors"]="                 8 brick_red"
  )

  unset         II
  for           II in "${!assoc_arr_Colors[@]}"
  do
    unset -n    NN
    declare -n  NN=Color_${II}
    unset       DD
                DD=$( awk '{ print $1 }' <<< "${assoc_arr_Colors[$II]}" )

    # shellcheck disable=SC2034
    printf -v   NN '%b' "$( tput setaf "${DD}" )"
    readonly Color_"${II}"
    tput sgr0

  done
  unset -n      NN
  unset         DD II assoc_arr_Colors


  : "${Color_Comment} Variables, Function boundary parameters ${Color_AttributesOff}"
  unset         _var_function_boundary_short
                _var_function_boundary_short=" ~~~ ~~~ ~~~ "
  readonly      _var_function_boundary_short

  unset         _var_fnction_boundry_long
                _var_fnction_boundry_long+=${_var_function_boundary_short}
                _var_fnction_boundry_long+=${_var_function_boundary_short}
                _var_fnction_boundry_long+=${_var_function_boundary_short}
  readonly      _var_fnction_boundry_long

  unset         fn_lvl
                fn_lvl=0
}
_fn_enable_debug_parameters_


##
function _fn_enable_debug_aliases_ ()
{

  ##
  : "${Color_Comment} Line ${nameref_Lineno}, Aliases, debug ${Color_AttributesOff}"

  #! Bug, separate alias definitions to a subsection above function
  #!   definitions. Defining of alias B can occur before the defining
  #!   of function A which is contained within in (alias B).

  ##  Aliases, TOC
  : "${Color_SubComent} Line ${nameref_Lineno}, Aliases, debug - TOC ${Color_AttributesOff}"
  #+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #+  _als_call_fncton_
  #+  _als_debug_break_
  #+  _als_enble_locl_xtrce_
  #+  _als_enble_globl_xtrce_
  #+  _als_fnction_boundary_in_
  #+  _als_fnction_boundary_out_0_
  #+  _als_fnction_boundry_out_1_
  #+  _als__fn_pause_to_check__
  #+  _als_read_xtrce_state_and_enable_
  #+  _als_restore_xtrce_state_

  #! Note, as I recall, these variable assignments all need to be on
  #!   the first line of this array.


  ##
  : "${Color_SubComent} Define alias _als_call_fncton_ ${Color_AttributesOff}"

  ## Note, Usage:   -|_als_call_fncton_ [function name]
  #+   Reason: so that the alias can be added to a script via sed/awk.
  unset als_cl_fn__def_lineno
        als_cl_fn__def_lineno=$((  nameref_Lineno + 2  ))

  alias _als_call_fncton_='_="${Color_XtraceOfAlias} alias _als_call_fncton_, begin" \
    als_cl_fn__call_line=$nameref_Lineno \
    als_def_line=${als_cl_fn__def_lineno} \
    _="alias _als_call_fncton_, end ${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_debug_break_ ${Color_AttributesOff}"
  ## Note, this alias is in intended to function as a
  unset als_dbg_brk__def_lineno
        als_dbg_brk__def_lineno="$((  nameref_Lineno + 2  ))"

  alias _als_debug_break_='
    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_debug_break_, begin, def Line ${als_dbg_brk__def_lineno}

    : If xtrace is already enabled, then disable xtrace and exit the script

    if [[ -o xtrace ]]
    then
      builtin set - && printf "%b\n" "${Color_AttributesOff}"
      exti_code=101
      main_lineno="${nameref_Lineno}" builtin exit
    else
      printf "%b\n" "${Color_XtraceOfAlias} Line ${nameref_Lineno}, alias _als_debug_break_, begin, def Line ${als_dbg_brk__def_lineno}"
      _als_enble_globl_xtrce_
    fi

    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_debug_break_, end "${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_enble_globl_xtrce_ ${Color_AttributesOff}"
  ## Note, this alias is in intended to function as a
  unset als_enbl_glbl_xtr__def_lineno
        als_enbl_glbl_xtr__def_lineno=$((  nameref_Lineno + 2  ))

  alias _als_enble_globl_xtrce_='
    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_enble_globl_xtrce_, begin, def Line ${als_enbl_glbl_xtr__def_lineno}

    : If xtrace is already enabled, then exit the script

    if ! [[ -o xtrace ]]
    then
      printf "%b\n" "${Color_XtraceOfAlias} Line ${nameref_Lineno}, alias _als_enble_globl_xtrce_, begin, def Line ${als_enbl_glbl_xtr__def_lineno}"

      print_function_boundaries=do_prFnctionBoundrys
      export print_function_boundaries

      printf "%b Line %d, Enabling global xtrace %b\n" \
        "${Color_TechCmnt}" \
        "${nameref_Lineno}" \
        "${Color_AttributesOff}"

      builtin set -x
    fi

    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_enble_globl_xtrce_, end "${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_enble_locl_xtrce_ ${Color_AttributesOff}"
  unset als_enbl_loc_xtr__def_lineno
        als_enbl_loc_xtr__def_lineno=$(( nameref_Lineno + 2  ))

  alias _als_enble_locl_xtrce_='
    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_enble_locl_xtrce_, begin, def Line ${als_enbl_loc_xtr__def_lineno}
    #fn_def_lineno="${nameref_Lineno:-}"

    if ! [[ -o xtrace ]]
    then
      local -Ig print_function_boundaries=do_prFnctionBoundrys
      export print_function_boundaries

      printf "%b   Enabling function-local xtrace %b\n" \
        "${Color_TechCmnt}" \
        "${Color_AttributesOff}"
      local -
      builtin set -x

      : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_enble_locl_xtrce_, begin, def Line ${als_enbl_loc_xtr__def_lineno}, end
      : "${Color_XtraceOfAlias}" Line $fn_def_lineno, function definition: "${FUNCNAME[0]}()"
      : fn_lvl: ${fn_lvl}
      : local_hyphn: $local_hyphn
      : prev_cmd_exit_code: $prev_cmd_exit_code
    fi

    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_enble_locl_xtrce_, end "${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_fnction_boundary_in_ ${Color_AttributesOff}"
  ## Note, s\b all one line
  # shellcheck disable=SC2142
  unset als_fn_bdry_in__def_lineno
        als_fn_bdry_in__def_lineno=$((  nameref_Lineno + 2  ))

  alias _als_fnction_boundary_in_='_="${Color_FnctionBoundry} ${_var_fnction_boundry_long} function ${FUNCNAME[0]}() BEGINS ${_var_function_boundary_short} ${fn_lvl} to $(( ++fn_lvl )) ${Color_AliasFunctionBoundary}"
    _="${Color_AliasFunctionBoundary} alias _als_fnction_boundary_in_, begin"
    als_fn_bndry_in__call_line=${nameref_Lineno}
    als_def_line=${als_fn_bdry_in__def_lineno}
    fn_call_lineno=$(( ${als_cl_fn__call_line:-} +1))
    fn_def_lineno=${nameref_Lineno:-}
    local_hyphn=$-
    prev_cmd_exit_code=${exti_code:-$?}
    : alias _als_fnction_boundary_in_, end "${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_fnction_boundary_out_0_ ${Color_AttributesOff}"
  unset als_fn_bdry_out_0__def_lineno
        als_fn_bdry_out_0__def_lineno=$((  nameref_Lineno + 2  ))

  alias _als_fnction_boundary_out_0_='
    _="${Color_AliasFunctionBoundary} alias _als_fnction_boundary_out_0_ begin" \
      als_call_line=$nameref_Lineno \
      als_def_line=${als_fn_bdry_out_0__def_lineno}
    _="alias _als_fnction_boundary_out_0_, end"
    _="${Color_FnctionBoundry} ${_var_fnction_boundry_long} function ${FUNCNAME[0]}()  ENDS  ${_var_function_boundary_short} ${fn_lvl} to $(( --fn_lvl )) ${Color_AttributesOff}"
    '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als__fn_pause_to_check__ ${Color_AttributesOff}"
  unset als_ps2ck__def_lineno
        als_ps2ck__def_lineno=$((  nameref_Lineno + 2  ))

  alias _als__fn_pause_to_check__='
    : "${Color_AliasFunctionBoundary}" Line ${nameref_Lineno}, alias _als__fn_pause_to_check__, begin, def Line ${als_ps2ck__def_lineno}

    _fn_pause_to_check_ ${nameref_Lineno}

    : "${Color_AliasFunctionBoundary}" Line ${nameref_Lineno}, alias _als__fn_pause_to_check__, end "${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_read_xtrce_state_and_enable_ ${Color_AttributesOff}"
  unset als_xtr_read_on__def_lineno
        als_xtr_read_on__def_lineno=$((  nameref_Lineno +  2 ))

  alias _als_read_xtrce_state_and_enable_='
    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_read_xtrce_state_and_enable_, begin, def Line ${als_xtr_read_on__def_lineno}

    if [[ $- == *x* ]]
    then
      xtr_state=on
    else
      xtr_state=off
    fi
    export xtr_state

    builtin set -x

    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_read_xtrce_state_and_enable_, end "${Color_AttributesOff}" '
  #! \end alias definition\


  ##
  : "${Color_SubComent} Define alias _als_restore_xtrce_state_ ${Color_AttributesOff}"
  # shellcheck disable=SC2154
  unset als_xtr_rstr__def_lineno
        als_xtr_rstr__def_lineno=$((  nameref_Lineno + 2  ))

  alias _als_restore_xtrce_state_='
    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_restore_xtrce_state_, begin, def Line ${als_xtr_rstr__def_lineno}
    local -
    builtin set +x

    if [[ -z ${xtr_state} ]]
    then
      _als_die_ Some state must have been established
    elif [[ ${xtr_state} == on ]]
    then
      builtin set -x
    elif ! [[ ${xtr_state} == off ]]
    then
      _als_die_
    fi

    : "${Color_XtraceOfAlias}" Line ${nameref_Lineno}, alias _als_restore_xtrce_state_, end "${Color_AttributesOff}" '
  #! \end alias definition\


  : "${Color_SubComent} Line ${nameref_Lineno}, Aliases, Debug -  Complete ${Color_AttributesOff}"
}
_fn_enable_debug_aliases_


##
function _fn_enable_debug_functions_ ()
{
  : "${Color_Comment} Line ${nameref_Lineno}, Functions, Debug ${Color_AttributesOff}"
  : "${Color_SubComent} Line ${nameref_Lineno}, Functions, Debug -  TOC ${Color_AttributesOff}"

    ##  Function name
    #+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #+  _fn_enable_git_debug_settings_()
    #+  _fn_pause_to_check_()
    #+  _fn_set_()


  : "${Color_SubComent} Define _fn_enable_git_debug_settings_() ${Color_AttributesOff}"
  function _fn_enable_git_debug_settings_ ()
  {    _als_fnction_boundary_in_

    : "${Color_SubComent} Variables -- Global git debug settings ${Color_AttributesOff}"
    # shellcheck disable=SC2034
    {
      GIT_TRACE=true
      GIT_CURL_VERBOSE=true
      GIT_SSH_COMMAND=ssh\ -vvv
      GIT_TRACE_PACK_ACCESS=true
      GIT_TRACE_PACKET=true
      GIT_TRACE_PACKFILE=true
      GIT_TRACE_PERFORMANCE=true
      GIT_TRACE_SETUP=true
      GIT_TRACE_SHALLOW=true
    }
    [[ -f ~/.gitconfig ]] &&
      git config --global --list --show-origin --show-scope |
      cat -n

                                            _als_fnction_boundary_out_0_
  }


  : "${Color_SubComent} Define _fn_pause_to_check_() ${Color_AttributesOff}"
  ## Usage,   _fn_pause_to_check_ ${nameref_Lineno}
  function _fn_pause_to_check_ ()
  {                _als_fnction_boundary_in_

    local -I exti_code=101 ## Q, Why inherit attributes and values when you assign values anyway?

    local -a KK=( "$@" )
    local reply

    [[ -n ${KK[*]:0:1} ]] &&
      printf '\n%s, %s(), %s\n' "${scr_nm}" "${FUNCNAME[0]}" "${KK[@]}" >&2
    printf '\n[Y|y|(enter)|(space)] is yes\nAnything else is { no and exit }\n' >&2

    if ! read -N1 -p $'\nReady?\n' -rst 600 reply >&2
    then
      printf '\nExiting, line %d\n\n' "${KK}" >&2
      builtin exit
    fi

    case "${reply}" in
      Y* | y* | $'\n' | \  )
        printf '\nOkay\n\n' >&2
        ;; #
      * )
        printf '\nExiting, line %d\n\n' "${KK}" >&2
        builtin exit
        ;; #
    esac
    unset KK

    ## ToDo: copy out this construct to the rest of the functions, re bndry_cmd
    ## SAVE this block
    #local bndry_cmd
    #if [[ $hyphn =~ x ]]; then bndry_cmd=echo; else bndry_cmd=true; fi
    #"${bndry_cmd}"  "${fn_bndry} ${FUNCNAME[0]}()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
    _als_fnction_boundary_out_0_
  }

  : "${Color_SubComent} Define _fn_set_() ${Color_AttributesOff}"
  function _fn_set_()
  {                                  _als_fnction_boundary_in_
    ## The global variable $fn_lvl is pulled in from the global scope and is s\et to effect the global
    #+  scope as well
    local -Ig   fn_lvl
    local       local_hyphn
                local_hyphn=${local_hyphn:-"$-"}
    local -aIg  qui__
                qui__=( "${qui__[@]}" )
    local -aIg  ver__
                ver__=( "${ver__[@]}" )

    if [[ -o xtrace ]]
    then
                qui__=( [0]="--" )
                ver__=( [0]="--verbose" [1]="--" )
    else
                qui__=( [0]="--quiet" [1]="--" )
                ver__=( [0]="--" )
    fi
    export      qui__
    export      ver__

    _als_fnction_boundary_out_0_
  }

  : "${Color_Comment} Line ${nameref_Lineno}, Functions, Debug - Complete ${Color_AttributesOff}"
}
_fn_enable_debug_functions_

  _fn_set_ -x


##
: "${Color_SubComent} Define _fn_setup_variables_() ${Color_AttributesOff}"
function _fn_setup_variables_ ()
{            _als_fnction_boundary_in_
  :
  : "${Color_Comment} Line ${nameref_Lineno}, Variables ...likely to change or early-definition required ${Color_AttributesOff}"
  :
  : "${Color_SubComent} Variables, colors, non-debug ${Color_AttributesOff}"
  [[ -v Color_AliasFunctionBoundary ]]  || Color_AliasFunctionBoundary=${Color_AliasFunctionBoundary:=}
  [[ -v Color_AttributesOff ]]          || Color_AttributesOff=${Color_AttributesOff:=}
  [[ -v Color_SubComent ]]              || Color_SubComent=${Color_SubComent:=}
  [[ -v Color_SubSbComent ]]            || Color_SubSbComent=${Color_SubSbComent:=}
  [[ -v Color_Comment ]]                || Color_Comment=${Color_Comment:=}
  [[ -v Color_Errors ]]                 || Color_Errors=${Color_Error:=}
  [[ -v Color_FnctionBoundry ]]         || Color_FnctionBoundry=${Color_FnctionBoundry:=}
  [[ -v Color_TechCmnt ]]               || Color_TechCmnt=${Color_TechCmnt:=}
  [[ -v Color_XtraceOfAlias ]]          || Color_XtraceOfAlias=${Color_XtraceOfAlias:=}
  :
    builtin set -x
  :
  : "${Color_SubComent} Variables, Error handling ${Color_AttributesOff}"
  ## Bug, only way to export namerefs?  \declare -nx nameref_Lineno=...\
  ## Note, variable assignments, backslash escape bc  sed -i
  # shellcheck disable=SC1001
  local -gnx nameref_Lineno=L\INENO
  :
  : "${Color_SubComent} Variables, PATH ${Color_AttributesOff}"
  PATH='/usr/bin:/usr/sbin'
  export PATH
  :
  : "${Color_SubComent} Variables, Other environment variables ${Color_AttributesOff}"
  ## Note, Initialize some env vars found in sourced files, as a workaround for nounset
  ## Note, local style, inline comments, ie, \: foo ## Note, blah\, are useful for rebutting false positives
  #+  from ShellCheck
  LC_ALL=""
  PS1=""
  :
  ## Note, /etc/bashrc and /etc/profile.d/colorls.*sh on Fedora 38
  # shellcheck disable=SC2034
  local -g BASHRCSOURCED USER_LS_COLORS
  :
  : "${Color_SubComent} Variables, Login UID and GID ${Color_AttributesOff}"
  ## Note, ps(1), \The real group ID identifies the group of the user who created the process\ and \The
  #+   effective group ID describes the group whose file access permissions are used by the process\
  #+   See output of,  \ps ax -o euid,ruid,egid,rgid,pid,ppid,stat,cmd | awk \$1 !~ $2 || $3 !~ $4\\
  ## Note, sudo(1), \SUDO_UID: Set to the user-ID of the user who invoked sudo.\
  if [[ -z ${login_uid:=} ]]
  then
    login_uid=$( id -u "$( logname )" )
  fi
  :
  if [[ -z ${login_gid:=} ]]
  then
    login_gid=$( id -g "$( logname )" )
  fi
  :
  # shellcheck disable=SC2034
  {
    : "${Color_SubComent} Variables, Script metadata ${Color_AttributesOff}"
    global_hyphn=$-
    export global_hyphn
    :
    : "${Color_SubComent} Variables, Repo info ${Color_AttributesOff}"
    scr_repo_nm=LiveUsb
    scr_nm=LiveUsb1.sh
    datadir_basenm=skel-LiveUsb
    datdir_idfile=.${scr_repo_nm}_id-key
    readonly scr_repo_nm scr_nm datadir_basenm datdir_idfile
    :
    : "${Color_SubComent} Variables, File and partition data and metadata ${Color_AttributesOff}"
    sha256_of_repo_readme=67e18b59ecd9140079503836e2dda1315b8799395b8da67693479b3d970f0a1
    data_pttn_uuid=7fcfd195-01
    data_dir_id_sha256=7542c27ad7c381b059009e2b321155b8ea498cf77daaba8c6d186d6a0e356280
    readonly sha256_of_repo_readme data_pttn_uuid data_dir_id_sha256
    :
    : "${Color_SubComent} Variables, User info ${Color_AttributesOff}"
    user_real_name="Wiley Young"
    user_github_email_address=84648683+wileyhy@users.noreply.github.com
    user_github_gpg_key=0C83679F385F55F914D25A21CD85D53BBCB172C2
    readonly user_real_name user_github_email_address user_github_gpg_key
    :
    : "${Color_SubComent} Variables, Required RPM\s ${Color_AttributesOff}"
      list_of_minimum_reqd_rpms+=( [0]="ShellCheck"
                                   [1]="firewall-config"
                                   [2]="geany"
                                   [3]="gh"
                                   [4]="git"
                                   [5]="vim-enhanced" )
    readonly list_of_minimum_reqd_rpms
    :
    : "${Color_Comment} Line ${nameref_Lineno}, Files, Required files lists ${Color_AttributesOff}"
    :
    ## Note, the \indexed array,\ $arrays_of_conf_files , is a meta-array containing a list of names of more
    #+  \indexed arrays.\ The array names, $files_for_use_with_github_depth_* , each have the same format and
    #+  are numbered sequentially are created here on one line only and have values assigned to each of them
    #+  within the next ~50 lines. The list of index numbers is created just once, so the indices in the
    #+  assignment section below must match the indices created here.
      arrays_of_conf_files+=( [0]="files_for_use_with_github_depth_0"
                              [1]="files_for_use_with_github_depth_1"
                              [2]="files_for_use_with_github_depth_2"
                              [3]="files_for_use_with_github_depth_3" )
    readonly arrays_of_conf_files
    :
    : Unset each value of the array
    unset "${arrays_of_conf_files[@]}"
    :
    ## Note, this is really a lot of manually entered data ...of filenames -- it\s a lot to maintain. :-\
    #+  Wouldn\t it be better to just always keep the data directory... in proper intended order...?
    #+  But then the data dir can be changed and there wouldn\t be any process of making sure the DACs
    #+  are correct. On the other hand, it\s easier to maintain a simple s\et of files. ...but their state
    #+  wouldn\t necessarily have been documented, which is valuable in and of itself. Otherwise, if they
    #+  were changed accidentally, how would you know any change had occurred?
    ## ToDo
    #: "  Files, firefox"
    #files_for_use_with_github_depth_0+=( ~/.mozilla )
    :
    : "${Color_SubComent} Files, gh (cli) ${Color_AttributesOff}"
    files_for_use_with_github_depth_2+=( ~/.config/gh/{config.yml,gpg-agent.conf,hosts.yml,pubring.kbx,trustdb.gpg} )
    files_for_use_with_github_depth_3+=( ~/.config/gh/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev )
    files_for_use_with_github_depth_3+=( ~/.config/gh/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )
    : "${Color_SubComent} Files, gpg ${Color_AttributesOff}"
    files_for_use_with_github_depth_1+=( ~/.gnupg/{gpg-agent.conf,pubring.kbx,tofu.db,trustdb.gpg} )
    files_for_use_with_github_depth_2+=( ~/.gnupg/crls.d/DIR.txt )
    files_for_use_with_github_depth_2+=( ~/.gnupg/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev )
    files_for_use_with_github_depth_2+=( ~/.gnupg/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )
    : "${Color_SubComent} Files, ssh ${Color_AttributesOff}"
    files_for_use_with_github_depth_1+=( ~/.ssh/{id_ed25519{,.pub},known_hosts} )
    : "${Color_SubComent} Files, top ${Color_AttributesOff}"
    files_for_use_with_github_depth_2+=( ~/.config/procps/toprc )
    : "${Color_SubComent} Files, vim ${Color_AttributesOff}"
    files_for_use_with_github_depth_0+=( ~/.vimrc )
    : "${Color_SubComent}   End of Files lists ${Color_AttributesOff}"
    :
  }
  _als_fnction_boundary_out_0_
}


##
: "${Color_Comment} Line ${nameref_Lineno}, Variables ${Color_AttributesOff}"
_als_call_fncton_ _fn_setup_variables_


##
: "${Color_Comment} Line ${nameref_Lineno}, # Testing testing testing ${Color_AttributesOff}"

  builtin set -x #<>


##
: "${Color_Comment} Line ${nameref_Lineno}, Functions ${Color_AttributesOff}"


##
: "${Color_SubComent} Line ${nameref_Lineno}, Functions TOC ${Color_AttributesOff}"

  ##  Function name
  #+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #+  _fn_clone_repo_()
  #+  _fn_error_and_exit_()
  #+  _fn_get_pids_for_restarting_()
  #+  _fn_gh_auth_login_command_()
  #+  _fn_increase_disk_space_()
  #+  _fn_min_necc_packages_()
  #+  _fn_must_be_root_()
  #+  _fn_reqd_user_files_()
  #+  _fn_rsync_install_if_missing_()
  #+  _fn_setup_bashrc_()
  #+  _fn_setup_dnf_()
  #+  _fn_setup_gh_cli_()
  #+  _fn_setup_git_()
  #+  _fn_setup_gti_user_dirs_()
  #+  _fn_setup_gpg()
  #+  _fn_setup_network()
  #+  _fn_setup_ssh()
  #+  _fn_setup_systemd()
  #+  _fn_setup_temp_dirs()
  #+  _fn_setup_time()
  #+  _fn_setup_vim()
  #+  _fn_test_dns()
  #+  _fn_test_os()
  #+  _fn_trap_err()
  #+  _fn_trap_exit()
  #+  _fn_trap_return()
  #+  _fn_write_bashrc_strings()
  #+  _fn_write_ssh_conf()

: "${Color_SubComent} Define _fn_clone_repo_() ${Color_AttributesOff}"
function _fn_clone_repo_ ()
{                           _als_fnction_boundary_in_

  [[ ${PWD} = "${dev_d1}" ]] || {
    _als_die_
  }

  local AA
    AA=$(
      sha256sum "${dev_d1}/${scr_repo_nm}/README.md" |
        cut --delimiter=" " --fields=1
    )

  if  ! [[ -d ./${scr_repo_nm} ]] ||
      ! [[ -f ./${scr_repo_nm}/README.md ]] ||
      ! [[ ${AA} == "${sha256_of_repo_readme}" ]]
  then
    git clone --origin github "https://github.com/wileyhy/${scr_repo_nm}" || {
      _als_die_
    }
  fi
  unset AA
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_error_and_exit_() ${Color_AttributesOff}"
function _fn_error_and_exit_ ()
{                       _als_fnction_boundary_in_

  ## Some positional parameters must exist
  [[ $# -lt 1 ]] &&
    return 1

  ## The first positional parameter must be a digit, and should be the LINENO from where _fn_error_and_exit_() is called
  if ! [[ $1 = [0-9]* ]]
  then
    printf '\n%b:: %s :: %s' "${Color_Errors}" "${scr_nm}" "${FUNCNAME[@]}"
    printf '\n:: Error :: first positional parameter must be a line number %b\n\n' \
      "${Color_AttributesOff}"
    return 2
  fi

  local local_lineno
        local_lineno=$1
  shift

  printf '%b%s, Error, line %d, %s%b\n' \
    "${Color_Errors}" \
    "${scr_nm}" \
    "${local_lineno}" \
    "$*" \
    "${Color_AttributesOff}" >&2

  [[ ${prev_cmd_exit_code} = 0 ]] &&
    prev_cmd_exit_code=01

    ## <>
    exti_code=${prev_cmd_exit_code}
    LN=${local_lineno} builtin exit
                                                 _als_fnction_boundary_out_0_
}




## ToDo: add a \get_distro()\ function

: "${Color_SubComent} Define _fn_get_pids_for_restarting_() ${Color_AttributesOff}"
function _fn_get_pids_for_restarting_ ()
{              _als_fnction_boundary_in_

  # shellcheck disable=SC2034
  local dnf_o
  local pipline0 pipline1
  local -ga a_pids
  a_pids=()

  ## Note, this pipeline was broken out into its constituent commands in order to verify the values
  #+  mid-stream. Yes, some of the array names are in fact spelled uncorrectly.

  ## Note, this s\et of arrays could be a function, but \return\ can only return from one function level at
  #+  at time, or it could be a loop, but the array names and command strings would have to be in an
  #+  associative array, and that seems like adding complexity.

  ## ToDo, implement some improved commands,
  #+  dnf --assumeno --security upgrade 2>/dev/null | grep -e ^'Install ' -e ^'Upgrade '
  #+  dnf --assumeno --bugfix upgrade 2>/dev/null | grep -e ^'Install ' -e ^'Upgrade '
  #+  for II in 7656 11807 17897 72230; do ps_o=$( ps aux ); printf '\n%s\n' "$( grep -Ee "\<${II}\>" <<< "${ps_o}" )"; /bin/kill -s HUP "${II}"; sleep 2; done


  readarray -t dnf_o < <(
    sudo -- nice --adjustment=-20 -- dnf needs-restarting 2> /dev/null || {
      _als_die_
    }
  )
  if [[ ${#dnf_o[@]} -eq 0 ]]
  then
    return 0
  fi

    declare -p dnf_o # <>

  readarray -t pipline0 < <(
    printf '%s\n' "${dnf_o[@]}" |
      grep --invert-match --fixed-strings --regexp="/firefox/"
  )
  if [[ ${#pipline0[@]} -eq 0 ]]
  then
    return 0
  fi

  readarray -t pipline1 < <(
    printf '%s\n' "${pipline0[@]}" |
      awk '{ print $1 }'
  )
  if [[ ${#pipline1[@]} -eq 0 ]]
  then
    return 0
  fi

  readarray -t a_pids < <(
    printf '%s\n' "${pipline1[@]}" |
      grep --only-matching --extended-regexp ^"[0-9]*"$
  )
  if [[ ${#a_pids[@]} -eq 0 ]]
  then
    return 0
  fi
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_gh_auth_login_command_() ${Color_AttributesOff}"
function _fn_gh_auth_login_command_ ()
{                _als_fnction_boundary_in_

  if gh auth status >/dev/null 2>&1
  then
    gh auth logout
  fi

  ## Bug, output of \gh auth login\: \! Authentication credentials saved in plain text\

  ## Note, do not break this line with any backslashed newlines or it will fail and you\ll have to
  #+  refresh auth manually; using short options for just this reason
  gh auth login -p ssh -h github.com -s admin:public_key,read:gpg_key,admin:ssh_signing_key -w || {
    _als_die_
  }
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_increase_disk_space_() ${Color_AttributesOff}"
function _fn_increase_disk_space_ ()
{                  _als_fnction_boundary_in_
  builtin set -x # []

  ## Note, such as...   /usr/lib/locale /usr/share/i18n/locales /usr/share/locale /usr/share/X11/locale , etc.
  ## Note, for $dirs1 , find syntax based on Mascheck\s
  ## Note, for $dirs2 , use of bit bucket because GVFS ‘/run/user/1000/doc’ cannot be read, even by root
  ## Note, for $fsos3 , \--and\ is not POSIX compliant
  ## Note, for $fsos4 , sorts by unique inode and delimits by nulls

  declare -A Aa_fsos5
  readarray -d "" -t dirs1 < <(
    find -- /  \!  -path / -prune -type d -print0
  )

  readarray -d "" -t dirs2 < <(
    find -- "${dirs1[@]}" -type d -name "*locale*" \
      \!  -ipath "${mount_base__fedora}/*" -print0 2> /dev/null
  )

  readarray -d "" -t fsos3 < <(
    find -- "${dirs2[@]}" -type f -size +$((  2 ** 16  ))  \(  \
      \!  -ipath "*en_*" -a  \!  -ipath "*/.git/*"  \)  -print0
  )

  if (( ${#fsos3[@]} > 0 ))
  then
    ## Note, for loop is run in a process substitution subshell, so unsetting BB is unnecessary
    readarray -d "" -t fsos4 < <(
      {
        for BB in "${fsos3[@]}"
        do
          printf '%s\0' "$( stat --printf='%i %n\n' -- "${BB}" )"
        done
      } |
        sort --unique |
          tr --delete '\n'
    )

    ## Question, does this assoc array Aa_fsos5 need to be declared as such? (I don\t think so, but...)

    set -- "${fsos4[@]}"

    while true
    do
      [[ -z ${1:-} ]] &&
        break 1 # <> s\et-u

      # shellcheck disable=SC2190
      Aa_fsos5+=( "${1%% *}" "${1#* }")
      shift 1

      (( $# == 0 )) &&
        break 1
    done
  fi

  : "${Color_SubComent} If any larger local data files were found, then remove them interactively ${Color_AttributesOff}"
  if [[ -n ${!Aa_fsos5[*]} ]]
  then
    : "${Color_SubComent} Inform user of any found FSOs ${Color_AttributesOff}"
    printf '%s, Delete these files? \n' "${scr_nm}"
    declare -p Aa_fsos5
    sleep 3

    for AA in "${!Aa_fsos5[@]}"
    do
      HH=0
      II=0
      JJ="${Aa_fsos5[${AA}]#.}"
      printf '%s,   File %d, \n' "${scr_nm}" $(( ++II ))

      while true
      do
        if [[ -e ${JJ} ]]
        then
          local ls_out
          readarray -t ls_out < <(
            ls -l --all --human-readable --classify --inode --directory --zero "${JJ}"
          )

          local KK
            KK=$( realpath -e "${JJ}" )
          ## Note, \\x60\ is a \grave accent\.
          printf '%s, output of %bls%b, %s \n' "${scr_nm}" \
            '\x60' '\x60' "${KK}"
          printf '%s\n' "${ls_out[@]}"
          unset ls_out KK

          local yes_or_no
          yes_or_no=n
          read -r -p " > [yN] " -t 600 yes_or_no
          yes_or_no="${yes_or_no,,?}"

          case "${yes_or_no}" in
            0 | 1 )
                  printf '  Zero and one are ambiguous, please use letters. \n'
                  continue 1
                ;; #
            y | t )
                  printf '  %s %b %s %s \n' "Script," ' \x60rm -i\x60 ' \
                    "requires a typed [yN] response," \
                    "it defaults to do-not-delete if a user just presses [enter]."

                  if sudo -- "$( type -P rm )" --interactive --one-file-system \
                    --preserve-root=all "${ver__[@]}" "${JJ}"
                  then
                    unset "Aa_fsos5[${AA}]"
                    break 1
                  else
                    _als_die_ "Unknown error"
                  fi
                ;; #
            n | f )
                  printf '  Keeping this file. \n'
                  unset "Aa_fsos5[${AA}]"
                  break 1
                ;; #
            * )   HH=$(( ++HH )) # <> s\et-e, can be just  (( HH++ ))  when errexit\s off

                  if (( HH < 3 ))
                  then
                    printf '  Invalid response (%d), please try again. \n' "${HH}"

                  else
                    printf '  Keeping this file. \n'
                    unset "Aa_fsos5[${AA}]"
                    break 1
                  fi
                ;; #
          esac
        else
          break 1
        fi
      done
    done
  fi
  unset dirs1 dirs2 fsos3 fsos4 Aa_fsos5 AA HH II JJ KK yes_or_no
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_min_necc_packages_() ${Color_AttributesOff}"
function _fn_min_necc_packages_ ()
{                    _als_fnction_boundary_in_

  local XX

  ## Question? how many $a_pids arrays are there, and are they ever misused?

  for XX in "${list_of_minimum_reqd_rpms[@]}"
  do
    if ! rpm --query --quiet "${XX}"
    then
      sudo -- dnf --assumeyes install "${XX}"

      ## ToDo, comment out this use of $a_pids, re declaring and unsetting
      _fn_get_pids_for_restarting_

    fi
  done
  unset XX
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_must_be_root_() ${Color_AttributesOff}"
function _fn_must_be_root_ ()
{                         _als_fnction_boundary_in_

  if (( UID == 0 ))
  then
    _als_die_ "Must be a regular user and use sudo"
  elif sudo --validate
  then
    : validation succeeded
  else
    : validation failed
    _als_die_
  fi
                                                 _als_fnction_boundary_out_0_
}

  builtin set -x #<>

: "${Color_SubComent} Define _fn_reqd_user_files_() ${Color_AttributesOff}"
function _fn_reqd_user_files_ ()
{                      _als_fnction_boundary_in_
  _als_enble_locl_xtrce_

  ## Note, QQ must be declared as local before unsetting it inside the
  #+   function so that the \unset\ will effect the local variable
  ## Note, and yet, when locally declaring and assigning separately a
  #+   regular variable, ie, \local lsblk_out \n lsblk_out=\ the
  #+   assignment doesn\t need a preceding \local\
  ## Note, I\m using an array with $lsblk_out so I can work around
  #+   \s\et -u\ by using a \:=\ PE, and so that I can limit xtrace output
  #+   by testing for a shortened version of the output of \lsblk\. I.e.,
  #+   I\m testing the last line of the array, index \-1\, but this is
  #+   really just a practice, since a lot of times index zero gets unset
  #+   for whatever reason, but if there are any values in the array at
  #+   all, then index \-1\ is guaranteed to exist. ...unless the array is
  #+   completely empty...
  #+   but I don\t want to UNSET ie RESET the array on each loop...
  #+ In this script, index zero should exist, barring any future changes.
  #+   So, it\s a bit of future-proofing.

  : $'Vars, Is device identified by \x22\x24data_pttn_uuid\x22 attached to this machine? If so, get device path'
  local pttn_device_path
  pttn_device_path=$(
    lsblk --noheadings --output partuuid,path |
      awk --assign awk_var_ptn="${data_pttn_uuid}" '$1 ~ awk_var_ptn { print $2 }'
  )

  #! Note, error
  [[ -n ${pttn_device_path} ]] || {
    _als_die_ $'Necessary USB drive isn\t plugged in or its filesystem has changed.'
  }

  : "${Color_SubComent} Vars, get mountpoints and label ${Color_AttributesOff}"
  local mount_pt data_dir is_mounted
  local -a array_mt_pts
  readarray -t array_mt_pts < <(
    lsblk --noheadings --output mountpoints "${pttn_device_path}"
  )

  local YY
  for YY in "${!array_mt_pts[@]}"
  do
    [[ -z ${array_mt_pts[YY]} ]] &&
      unset "array_mt_pts[YY]"
  done
  unset YY

  case "${#array_mt_pts[@]}" in
    0 )
      : "${Color_SubComent} Zero matches ${Color_AttributesOff}"
      ## Note, \plugged in and not mounted\ means the LABEL would still be visible, if there is one, the USB
      #+  drive or the filesystem holding the data could change, and either change would rewrite the PARTUUID
      local pttn_label
      pttn_label=$(
        lsblk --noheadings --output label "${pttn_device_path}"
      )
      pttn_label=${pttn_label:=live_usb_tmplabel}
      mount_base__fedora=/run/media/root
      mount_pt=${mount_base__fedora}/${pttn_label}
      data_dir=${mount_pt}/${datadir_basenm}
      is_mounted=no
      unset pttn_label
      ;; #
    1 )
      : "${Color_SubComent} One match ${Color_AttributesOff}"
      mount_pt=${array_mt_pts[*]}
      data_dir=${mount_pt}/${datadir_basenm}
      is_mounted=yes
      ;; #
    * )
      : "${Color_SubComent} Multiple matches ${Color_AttributesOff}"
      _als_die_ "The target partition is mounted in multiple places"
      ;; #
  esac
  unset array_mt_pts

  : "${Color_SubComent} FS mounting must be restricted to root and/or liveuser ${Color_AttributesOff}"
  local mount_user
  mount_user=${mount_pt%/*} mount_user=${mount_user##*/}
  [[ ${mount_user} = @(root|liveuser) ]] || {
    _als_die_
  }
  unset mount_user

  : "${Color_SubComent} USB drive must be mounted ${Color_AttributesOff}"
  if [[ ${is_mounted} = "no" ]]
  then
    if ! [[ -d "${mount_pt}" ]]
    then
      sudo -- mkdir --parents -- "${mount_pt}" || {
        _als_die_
      }
    fi

    sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || {
      _als_die_
    }
    is_mounted=yes
    sync -f
  fi

  : $'FS mounting must auto- \x60umount\x60 after some time, and auto- \x60mount\x60 on access'
  if  mount |
        grep -Fe "${pttn_device_path}" |
        grep -q timeout
  then
    sudo -- mount -o remount,x-systemd.idle.timeout=10,nosuid,noexec,dev,nouser,ro -- "${pttn_device_path}"
    sync -f
  fi

  : "${Color_SubComent} Directories from mount-username directory to mount point must be readable via ACL, but not writeable ${Color_AttributesOff}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${mount_pt%/*}"
  sudo -- setfacl --remove-all --remove-default -- "${mount_pt}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${mount_pt}"

  : "${Color_SubComent} Data directory must already exist ${Color_AttributesOff}"
  if  ! [[ -d ${data_dir} ]] ||
      [[ -L ${data_dir} ]]
  then
    _als_die_
  fi

  : "${Color_SubComent} Data directory must be readable via ACL, but not writeable ${Color_AttributesOff}"
  sudo -- setfacl --remove-all --remove-default --recursive --physical -- "${data_dir}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${data_dir}"
  sudo -- find "${data_dir}" -type d -execdir setfacl --modify="u:${LOGNAME}:rx" --recursive --physical '{}' \; #
  sudo -- find "${data_dir}" -type f -execdir setfacl --modify="u:${LOGNAME}:r" '{}' \; #

  : "${Color_SubComent} Data directory verification info must be correct ${Color_AttributesOff}"
  local ZZ
  ZZ=$(
    sudo -- sha256sum -b "${data_dir}/${datdir_idfile}" |
      grep -o "${data_dir_id_sha256}"
  )

  if  ! [[ -f ${data_dir}/${datdir_idfile} ]] ||
      [[ -L ${data_dir}/${datdir_idfile} ]]
  then
    _als_die_
  fi

  if ! [[ ${ZZ} = ${data_dir_id_sha256} ]]
  then
    _als_die_
  fi
  unset ZZ

  : "${Color_SubComent} Capture previous umask and s\et a new one ${Color_AttributesOff}"
  local prev_umask
  read -r -a prev_umask < <(
    umask -p
  )
  umask 177

  : "${Color_SubComent} For each array of conf files and/or directories ${Color_AttributesOff}"
  local AA
  local -n QQ
  ## Note, It isn\t strictly necessary to declare QQ as a nameref here, since unsetting QQ (see below) removes
  #+  the nameref attribute, but I intend to use QQ as a nameref, so declaring QQ without a nameref attribute
  #+  would be confusing

  for AA in "${arrays_of_conf_files[@]}"
  do
    #: \Loop A - open \\\ \

    : "${Color_SubComent} Vars ${Color_AttributesOff}"
    ## Note, if I declare a local nameref, \local -n foo\, then on the next line just assign to the nameref
    #+  directly, \foo=bar\, then on the second loop \local -p QQ\ prints the former value of QQ. Perhaps
    #+  the second assignment statement, ie, \foo=bar\ without \local -n\ is global?
    ## Note, remember, namerefs can only be unset with the -n flag to the \unset\ builtin
    #unset -n QQ
    local -n QQ
    local -n QQ=${AA}   ## good code

    : "${Color_SubComent} For each conf file or dir ${Color_AttributesOff}"
    local BB

    : "${Color_SubComent} If the target conf file/dir does not exist ${Color_AttributesOff}"
    for BB in "${!QQ[@]}"
    do
      #: \    Loop A:1 - open \\\ \
      if ! [[ -e ${QQ[BB]} ]]
      then

        : "${Color_SubComent} Vars ${Color_AttributesOff}"
        local source_file
        source_file=${data_dir}/${QQ[BB]#~/}

        : "${Color_SubComent} If the source conf file/dir does not exist, then find it ${Color_AttributesOff}"
        if ! [[ -e ${source_file} ]]
        then

          : "${Color_SubComent} If the partition is not mounted which holds the data directory, then mount it ${Color_AttributesOff}"
          if [[ ${is_mounted} = no ]]
          then

            sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || {
              _als_die_
            }

            if  mount |
                  grep -q "${pttn_device_path}"
            then
              is_mounted=yes
            fi
          fi

          : "${Color_SubComent} If the source conf file/dir still does not exist, then throw an error ${Color_AttributesOff}"
          if ! [[ -e ${source_file} ]]
          then
            _als_die_ "${QQ[BB]}" "${source_file}"
          fi
        fi

        local dest_dir
        dest_dir=${QQ[BB]%/*}
        _fn_rsync_install_if_missing_  "${source_file}" "${dest_dir}"
        unset source_file dest_dir
      fi
      #: \    Loop A:1 - shut /// \
    done
    #: \Loops A:1 - complete === \

    unset BB
    unset -n QQ
    #: \Loop A - shut /// \
  done

  unset AA
  unset mount_pt data_dir is_mounted
  unset pttn_device_path
  #: \Loops A - complete === \

  : "${Color_SubComent} Restore previous umask ${Color_AttributesOff}"
  builtin "${prev_umask[@]}"
  unset prev_umask
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_rsync_install_if_missing_() ${Color_AttributesOff}"
function _fn_rsync_install_if_missing_ ()
{             _als_fnction_boundary_in_

    # <>
    if [[ -z $(declare -p data_dir) ]]
    then
      echo FOOL
      exit ${LINENO}
    fi

  local fn_target_dir fn_source_var
  fn_source_var=$1
  fn_target_dir=$2

  if [[ -e ${fn_target_dir} ]]
  then
    if ! [[ -d ${fn_target_dir} ]]
    then
      _als_die_ "${fn_target_dir}"
    fi
  else
    local fn_umask
    read -r -a fn_umask < <(
      umask -p
    )
    umask 077
    mkdir --parents "${ver__[@]}" "${fn_target_dir}"
    builtin "${fn_umask[@]}"
    unset fn_umask
  fi

  ## Bug, variable $data_dir is defined in a different function, _fn_reqd_user_files_().
  #+ See <> test above, ~line 812

  if [[ -z ${data_dir} ]]
  then
    local unset_local_var_rand5791
    unset_local_var_rand5791=yes

    local -a poss_dat_dirs
    readarray -d "" -t poss_dat_dirs < <(
      find / -type f -path "*${datadir_basenm}*" -name "${datdir_idfile}" -print0 2>/dev/null
    )

    local data_dir XX
    data_dir=$(
      for XX in "${poss_dat_dirs[@]}"
      do
        sha256sum -b "${XX}"
      done |
        awk -F'*' --assign "av_XX=${data_dir_id_sha256}" '$1 ~ av_XX { print $2 }'
      )
    unset XX poss_dat_dirs
  fi

  if ! [[ -e ${fn_target_dir}/${fn_source_var#*"${data_dir}"/} ]]
  then
    rsync --archive --checksum -- "${fn_source_var}" "${fn_target_dir}" || {
      _als_die_ "${fn_target_dir}"
    }
  fi

  : "${Color_SubComent} Unset a local variable defined and assigned in only this function, and not any variables by the same name... ${Color_AttributesOff}"
  #+  from any other scope
  [[ ${unset_local_var_rand5791:=} = "yes" ]] &&
    unset unset_local_var_rand5791 data_dir

  unset fn_source_var fn_target_dir
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_bashrc_() ${Color_AttributesOff}"
function _fn_setup_bashrc_ ()
{                         _als_fnction_boundary_in_

  : "${Color_SubComent} bashrc -- Do some backups ${Color_AttributesOff}"
  files_for_use_with_bash=( /root/.bashrc ~/.bashrc )

  for WW in "${files_for_use_with_bash[@]}"
  do
    hash -r

    : "${Color_SubComent} bashrc -- RC File must exist ${Color_AttributesOff}"
    if ! sudo -- "$(type -P test)" -f "${WW}"
    then
      _als_die_ "${WW}"
    fi

    ## Note, chmod changes the ctime, even with no change of DAC\s

    : "${Color_SubComent} bashrc -- ...of the array files_for_use_with_bash ${Color_AttributesOff}"
    if ! sudo -- "$(type -P test)" -e "${WW}.orig"
    then
      sudo -- rsync --archive --checksum "${ver__[@]}" "${WW}" "${WW}.orig"

      local AA
      AA=$( sudo -- stat -c%a -- "${WW}.orig" )
      if [[ ${AA} != 400 ]]
      then
        sudo -- chmod 400 "${ver__[@]}" "${WW}.orig"
      fi
      unset AA

      ## Note, Adding attr changes ctime once; removing attr changes ctime every time

      local BB
      BB=$( sudo -- lsattr -l -- "${WW}.orig" )
      if [[ ${BB} != immutable ]]
      then
        sudo -- chattr +i -- "${WW}.orig"
      fi
      unset BB
    fi

    : "${Color_SubComent} bashrc -- ...per-script-execution file backup ${Color_AttributesOff}"
    sudo -- rsync --archive --checksum "${ver__[@]}" "${WW}" "${WW}~" || {
      _als_die_ "${WW}"
    }
  done
  unset WW

  : "${Color_SubComent} bashrc -- Env parameters for bashrc ${Color_AttributesOff}"

  : "${Color_SubComent} bashrc -- PS0 -- Assign color code and duck xtrace ${Color_AttributesOff}"
  ## Note,  s\et [-|-x] , letting xtrace expand this  tput  command alters all xtrace colorization
  if [[ -o xtrace ]]
  then
    set -
    PS0=$(
      tput setaf 43
    )
    builtin set -x
  else
    PS0=$(
      tput setaf 43
    )
  fi

  : "${Color_SubComent} bashrc -- PROMPT_COMMAND -- Variables dependency -- level 1 -- ${Color_AttributesOff}"
  pc_regx="not found"$
  # shellcheck disable=SC2034
  prompt_colors_reset=$(
    tput sgr0
  )

  ## ToDo, append some additional definitions into bashrc
  #+    man() { "$( type -P man )" --nh --nj "$@"; }
  #+    export TMOUT=15

  : "${Color_SubComent} bashrc -- PROMPT_COMMAND -- Variables dependency -- level 2 -- ${Color_AttributesOff}"
  # shellcheck disable=SC2016
  prompt_cmd_0='printf "%b" "${prompt_colors_reset}" '

  : "${Color_SubComent} bashrc -- PROMPT_COMMAND -- Variables dependency -- level 3 -- ${Color_AttributesOff}"
  ## Note, PROMPT_COMMAND could have been inherited as a string variable
  unset PROMPT_COMMAND
  declare -a PROMPT_COMMAND
  PROMPT_COMMAND=( [0]="${prompt_cmd_0}" )

  if ! [[ "$( declare -pF __vte_prompt_command 2>&1 )" =~ ${pc_regx} ]]
  then
    PROMPT_COMMAND+=( __vte_prompt_command )
  fi

  : "${Color_SubComent} bashrc -- Other parameters ${Color_AttributesOff}"
  # shellcheck disable=SC2034
  {
    PS1="[\\u@\\h]\\\$ "
    BROWSER=$(
      command -v firefox
    )
    EDITOR=$(
      command -v vim vi nano |
        head --lines=1
    )
  }

  : "${Color_SubComent} bashrc -- Append user variables and functions into .bashrc ${Color_AttributesOff}"
  ## Note, these arrays include some command substitutions which depend on some function definitions, which in
  #+  turn must be defined prior to defining these arrays

  : "${Color_SubComent} bashrc -- Define lists of parameters to be appended into bashrc ${Color_AttributesOff}"
  ## Note, there are multiple lists for variables due to layers of dependencies. Later in this procedure,
  #+  each of these groups is relayed using associative arrays, which do not reliably maintain their internal
  #+  ordering, so, some consistent ordering must be imposed here.
  declare -a vars_for_bashrc_1=([0]="BROWSER" [1]="EDITOR" [2]="PS0" [3]="prompt_colors_reset")
  declare -a vars_for_bashrc_2=([0]="prompt_cmd_0")
  declare -a vars_for_bashrc_3=([0]="PROMPT_COMMAND")
  declare -a fcns_for_bashrc_1=()

    # indices=()
    #
    # list_{ index }=( group )
    #
    # identify [ var or fn ] by parsing shell builtins

    ## ToDo, write lists of how the data is to be written in bashrc, and of how the data exists originally,
    #+  then with those endpoints, chart how to transform the strings from a simple list to output in bashrc

  : "${Color_SubComent} bashrc -- Variables ${Color_AttributesOff}"
  missing_vars_and_fns=()

  : "${Color_SubComent} Note, test for whether the reqd variables are defined in the script#s current execution environment ${Color_AttributesOff}"
  for QQ in "${vars_for_bashrc_1[@]}" "${vars_for_bashrc_2[@]}" "${vars_for_bashrc_3[@]}"
  do
    if [[ $( declare -p "${QQ}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${QQ}" )
    fi
  done
  unset QQ

  : "${Color_SubComent} bashrc -- Functions ${Color_AttributesOff}"
  for UU in "${fcns_for_bashrc_1[@]}"
  do
    if [[ $( declare -pF "${UU}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${UU}" )
    fi
  done
  unset UU

  : "${Color_SubComent} bashrc -- Test for any missing parameters ${Color_AttributesOff}"
  if (( ${#missing_vars_and_fns[@]} > 0 ))
  then
    _als_die_ "${missing_vars_and_fns[@]}"
  fi

  : "${Color_SubComent} bashrc -- Create Associative arrays of required parameters ${Color_AttributesOff}"

  : "${Color_SubComent} bashrc -- Define Aa_bashrc_strngs_* ${Color_AttributesOff}"
  ## Note, you want for these array elements to represent just one parameter or function each.  ...what does this mean?
  local -a bashrc_Assoc_arrays
  local -a bashrc_Assoc_arrays=( Aa_bashrc_strngs_F1   Aa_bashrc_strngs_V1   Aa_bashrc_strngs_V2   Aa_bashrc_strngs_V3 )
  local -A "${bashrc_Assoc_arrays[@]}"

  : "${Color_SubComent} bashrc -- Variables ${Color_AttributesOff}"
  ## Note, three temp vars are used here because of the correspondence of numbers, ie, 1 and 1, 2 and 2, etc
  #+  between the names of the respective indexed and associative arrays. In effect, this is the clearest and
  #+  shortest way to write it in bash (5.2), for the intended purpose, to the best of my knowledge.
  local XX YY ZZ
  for XX in "${vars_for_bashrc_1[@]}"
  do
    Aa_bashrc_strngs_V1+=(
      ["define parameter ${XX}"]=$(
        declare -p "${XX}"
      )
    )
  done

  for YY in "${vars_for_bashrc_2[@]}"
  do
    Aa_bashrc_strngs_V2+=(
      ["define parameter ${YY}"]=$(
        declare -p "${YY}"
      )
    )
  done

  for ZZ in "${vars_for_bashrc_3[@]}"
  do
    Aa_bashrc_strngs_V3+=(
      ["define parameter ${ZZ}"]=$(
        declare -p "${ZZ}"
      )
    )
  done
  unset XX YY ZZ

  : "${Color_SubComent} bashrc -- Functions (a.k.a. \"subroutines\") ${Color_AttributesOff}"
  local AA
  for AA in "${fcns_for_bashrc_1[@]}"
  do
    Aa_bashrc_strngs_F1+=(
      ["define subroutine ${AA}"]="function $(
        declare -pf "${AA}"
      )"
    )
  done
  unset AA

  : "${Color_SubComent} bashrc -- Write functions and variable definitions into bashrc files ${Color_AttributesOff}"
  local KK
  for KK in "${!bashrc_Assoc_arrays[@]}"
  do
    _fn_write_bashrc_strings "${bashrc_Assoc_arrays[${KK}]}"
  done
  unset KK

  : "${Color_SubComent} bashrc -- Clean up ${Color_AttributesOff}"
  unset pc_regx prompt_cmd_0
  unset files_for_use_with_bash
  unset -f _fn_write_bashrc_strings
  unset "${bashrc_Assoc_arrays[@]}"
  unset bashrc_Assoc_arrays
                                                 _als_fnction_boundary_out_0_
}


## Bug, _fn_setup_dnf_ is too long and too complicated

: "${Color_SubComent} Define _fn_setup_dnf_() ${Color_AttributesOff}"
function _fn_setup_dnf_()
{                           _als_fnction_boundary_in_

  ## Bug, there should be a n\eeds-restarting loop between each install/upgrade
  ## Bug, the --security upgrade should be done rpm by rpm

    : "${Color_SubComent} Beginning section on DNF ${Color_AttributesOff}"

  ## Note, CUPS cannot be safely removed; too many dependencies
  ## Note, For some unknown reason, even when  dnf  doesn\t change any programs,  dnf
  #+  needs-restarting  decides it needs to restart all available Firefox processes, which crashes all of
  #+  my tabs.  (Burg?)  So, I\m adding in a few  rpm -qa | wc -l s to only run  dnf
  #+  needs-restarting  in the event that any files on disk may actually have been changed.
  ## Note, these PE\s (for_admin, for_bash, etc.) have been tested and should \disappear\ by virtue of
  #+  whichever expansion does that, leaving just the regular strings as the elements of the array
  ## Note, this brace grouping (all together of for_admin, for_bash, etc.) is so that \shellcheck disable\ will
  #+  apply to the entire block

  hash_of_installed_pkgs_A=$(
    rpm --all --query |
      sha256sum |
      cut --delimiter=' ' --fields=1
  )

  : "${Color_SubComent} Define filename for record of previous hash..B ${Color_AttributesOff}"
  local hash_f hash_of_installed_pkgs_B_prev
  hash_f=/tmp/setup_dnf__hash_of_installed_pkgs_B_prev
  hash_of_installed_pkgs_B_prev=""

  : "${Color_SubComent} If the record already exists... ${Color_AttributesOff}"
  if [[ -f ${hash_f} ]]
  then

    : "${Color_SubComent}...then read it in ${Color_AttributesOff}"
    read -r hash_of_installed_pkgs_B_prev < "${hash_f}"

    : "${Color_SubComent} If the old hash...B matches the new hash...A, then return from this function ${Color_AttributesOff}"
    if [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B_prev}" ]]
    then
      return
    fi
  fi

  : "${Color_SubComent} Removals for disk space ${Color_AttributesOff}"
  pkg_nms_for_removal=( google-noto-sans-cjk-vf-fonts mint-x-icons mint-y-icons transmission )

  : "${Color_SubComent} Removals for security ${Color_AttributesOff}"
  #pkg_nms_for_removal+=( blueman bluez )

  ## Note, xfce4-terminal -- hardcoded WM ...can be used w/o XFCE....

  # shellcheck disable=SC2206
  {
      addl_pkgs=(  ${for_admin:=}         ncdu pwgen )
      addl_pkgs+=( ${for_bash:=}          bash bash-completion )
    # addl_pkgs+=( ${for_bashdb:=}        bash-devel make autoconf )
      addl_pkgs+=( ${for_critical_A:=}    libsss_sudo sudo{,-python-plugin} )
      addl_pkgs+=( ${for_critical_B:=}    nss{,-{mdns,softokn{,-freebl},sysinit,util}} )
      addl_pkgs+=( ${for_critical_C:=}    openssh{,-{clients,server}} )
      addl_pkgs+=( ${for_critical_D:=}    chrony )
      addl_pkgs+=( ${for_critical_E:=}    gnupg2{,-smime} {archlinux,debian,ubu}-keyring )
      addl_pkgs+=( ${for_critical_F:=}      {distribution,fedora}-gpg-keys python3-gpg )
      addl_pkgs+=( ${for_critical_G:=}    NetworkManager NetworkManager-{adsl,bluetooth,libnm,ppp} )
      addl_pkgs+=( ${for_critical_H:=}      NetworkManager-{team,wifi,wwan} util-linux )
      addl_pkgs+=( ${for_critical_I:=}    firewall-config python3-firewall firewalld{,-filesystem} )
      addl_pkgs+=( ${for_critical_J:=}    firefox{,-langpacks} mozilla-{filesystem,https-everywhere,noscript,privacy-badger} )
      addl_pkgs+=( ${for_critical_K:=}      mozjs102 perl-Mozilla-CA )
      addl_pkgs+=( ${for_critical_L:=}    iptables-{libs,nft} {,python3-}nftables )
      addl_pkgs+=( ${for_critical_M:=}    dnf{,-data,-plugins-core} python3-dnf{,-plugins-core} {python3-,}libdnf )
      addl_pkgs+=( ${for_critical_M:=}    rpm{,-{build-,}libs,-plugin-{selinux,systemd-inhibit},-sequoia,-sign-libs} )
      addl_pkgs+=( ${for_critical_M:=}    {delta,python3-}rpm )
    # addl_pkgs+=( ${for_critical_N:=}    audit{,-libs} python3-audit )
      addl_pkgs+=( ${for_critical_O:=}    sysstat )
    # addl_pkgs+=( ${for_careful_A:=}     systemd )
    # addl_pkgs+=( ${for_careful_B:=}     sssd{,-{ad,client,common{,-pac},ipa,kcm,krb5{,-common},ldap,nfs-idmap,proxy}} )
    # addl_pkgs+=( ${for_db_ish:=}        libreoffice-calc )
    # addl_pkgs+=( ${for_bug_rpts:=}     inxi zsh dash mksh )
    # addl_pkgs+=( ${for_char_sets:=}     enca moreutils uchardet )
      addl_pkgs+=( ${for_duh:=}           info plocate lynx )
    # addl_pkgs+=( ${for_duh:=}           pdfgrep wdiff )
      addl_pkgs+=( ${for_firefox:=}       mozilla-noscript mozilla-privacy-badger mozilla-https-everywhere )
      addl_pkgs+=( ${for_fs_maint:=}      bleachbit python3-psutil )
    # addl_pkgs+=( ${for_fs_maint:=}      stacer )
    # addl_pkgs+=( ${for_fun:=}           supertuxkart )
    # addl_pkgs+=( ${for_gcov:=}          gcc )
      addl_pkgs+=( ${for_git:=}           git gh )
    # addl_pkgs+=( ${for_internet:=}      chromium )
    # addl_pkgs+=( ${for_later_other:=}   memstomp gdb valgrind memstrack kernelshark )
    # addl_pkgs+=( ${for_later_trace:=}   bpftrace python3-ptrace fatrace apitrace x11trace )
      addl_pkgs+=( ${for_linting:=}       ShellCheck strace )
    # addl_pkgs+=( ${for_mo_linting:=}    kcov shfmt patch ltrace )
    # addl_pkgs+=( ${for_lockfile:=}      procmail )
    # addl_pkgs+=( ${for_os_dnlds:=}      debian-keyring )
      addl_pkgs+=( ${for_strings:=}       binutils )
      addl_pkgs+=( ${for_term_tests:=}    xfce4-terminal )
    # addl_pkgs+=( ${for_term_tests:=}    gnome-terminal xterm )
    # addl_pkgs+=( ${for_unicode:=}       xterm rxvt-unicode perl-Text-Bidi-urxvt )
    # addl_pkgs+=( ${for_security:=}      orca protonvpn-cli xsecurelock )
  }

  : "${Color_SubComent} Start with removing any unnecessary RPMs ${Color_AttributesOff}"

  if [[ -n ${pkg_nms_for_removal:0:8} ]]
  then
    ## Note, this  printf  command uses nulls so that  -e  and  %s...  will be read as separate indices
    #+  by  readarray
    readarray -d "" -t grep_args < <(
      printf -- '-e\0%s.*\0' "${pkg_nms_for_removal[@]}"
    )
    readarray -t removable_pkgs < <(
      rpm --all --query | grep --ignore-case --extended-regexp "${grep_args[@]}"
    )

    : "${Color_SubComent} Keep a list, just in case an rpm removal accidentally erases something vital ${Color_AttributesOff}"
    if [[ -n ${removable_pkgs[*]:0:8} ]]
    then
      for QQ in "${!removable_pkgs[@]}"
      do
        ## Note,  dnf , do not use [-y|--yes] with this particular command
        unset DD exp_dt dnf_cmd
        DD=$( date +%s )
        exp_dt=$( date --date="January 1, 2026" +%s )

        if (( DD > exp_dt ))
        then
          dnf_cmd=dnf5
        else
          dnf_cmd=dnf4
        fi

        if sudo -- \
          nice --adjustment=-20 -- \
          "${dnf_cmd}" --allowerasing remove -- "${removable_pkgs[QQ]}"
        then
          unset "removable_pkgs[QQ]"
        else
          _als_die_ "${removable_pkgs[QQ]}"
        fi
        unset DD exp_dt dnf_cmd
      done
      unset QQ
    fi
  fi

  : "${Color_SubComent} Then do a blanket security upgrade ${Color_AttributesOff}"

  ## Note, the problem with this \blanket security upgrade\ is how it
  #+   includes kernel and firmware. Better to capture list of rpms in
  #+   a no-op cmd, filter out impractical (for a LiveUsb) rpms, then
  #+   upgrade the rest one by one

  : $'Run this loop until \x60dnf --security upgrade\x60 returns 0, or 0 upgradable, rpms'
  while true
  do

    : "${Color_SubComent} Get full list of rpms to upgrade, in an array; exit on non-zero ${Color_AttributesOff}"
    readarray -d "" -t pkgs_for_upgrade < <(
      sudo -- dnf --assumeno --security --bugfix upgrade 2>/dev/null |
        awk '$2 ~ /x86_64|noarch/ { printf "%s\0", $1 }' |
        grep -vE ^replacing$
      )

    : $'remove all  kernel  and  firmware  rpms from array \x24pkgs_for_upgrade array'
    for HH in "${!pkgs_for_upgrade[@]}"
    do
      if [[ ${pkgs_for_upgrade[HH]} =~ kernel|firmware ]]
      then
        unset_reason+=( [HH]="${BASH_REMATCH[*]}" )
        unset "pkgs_for_upgrade[HH]"
      fi
    done
    unset HH

    : "${Color_SubComent} If count of upgradeable rpms is 0, then break loop ${Color_AttributesOff}"
    if [[ ${#pkgs_for_upgrade[@]} -eq 0 ]]
    then
      break
    fi

    : "${Color_SubComent} Upgrade the RPM\s one at a time ${Color_AttributesOff}"
    for II in "${!pkgs_for_upgrade[@]}"
    do
      if sudo -- dnf --assumeyes --security upgrade -- "${pkgs_for_upgrade[II]}"
      then
        unset "pkgs_for_upgrade[II]"
      else
        printf 'ERROR %d\n' "${II}"
        break
      fi
    done
    unset II

    : $'Run \x60dnf needs-restarting\x60, collecting PID/commandline pairs'
    #a_pids=()
    _fn_get_pids_for_restarting_

      declare -p a_pids
      #exit 101

    : $'Send signals to "needs-restarting" PID\x27s, one at a time...'
    #+   with pauses and descriptions between each one, so I can see which
    #+   signal/process combinations cause any problems. This would be a
    #+   great job for logging.

  done

  _fn_pause_to_check_ "${nameref_Lineno}" $'Which packages in the \x24addl_pkgs array are already installed?' # <>

  : "${Color_SubComent} Find out whether an RPM is installed, one by one ${Color_AttributesOff}"
  for UU in "${!addl_pkgs[@]}"
  do
    if rpm --query --quiet -- "${addl_pkgs[UU]}"
    then
      pkgs_installed+=( "${addl_pkgs[UU]}" )
      unset "addl_pkgs[UU]"
    fi
  done
  unset UU

    _fn_pause_to_check_ "${nameref_Lineno}" $'Upgrade any pre-intstalled packages from the \x24addl_pkgs array' # <>

  ## Bug, this section should upgrade rpms one by one

  : "${Color_SubComent} Upgrade any installed RPMs from the main list, en masse ${Color_AttributesOff}"
  if [[ -n ${pkgs_installed[*]: -1:1} ]]
  then
    sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet upgrade "${pkgs_installed[@]}" || {
      _als_die_
    }
  fi

    _fn_pause_to_check_ "${nameref_Lineno}" $'From the \x24addl_pkgs array, install the remainder' # <>

  : "${Color_SubComent} Install any as yet uninstalled RPMs from the main list as necessary ${Color_AttributesOff}"
  not_yet_installed_pkgs=( "${addl_pkgs[@]}" )

  if [[ -n ${not_yet_installed_pkgs[*]: -1:1} ]]
  then
    ## Note, if you install multiple rpms at the same time, and one of them causes some error, then you have
    #+  no immediate way of knowing which one caused the error

    for VV in "${not_yet_installed_pkgs[@]}"
    do
      sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet install "${VV}" || {
        _als_die_
      }

      _fn_get_pids_for_restarting_

      ## BUG, killing NetworkManager or firewalld stops the systemd service process, and neither restart
      #+  automatically

      ## Question, how is it possible to know from \ps aux\ output whether a process was started by a
      #+  systemd service?  ...grepping /usr/lib/systemd/system for the cmdline?
      #
      #{ for XX in /proc/[0-9]*/cmdline; do if [[ -n $XX ]]; then readarray -d "" -t array_cmdln < <( cat "$XX" ); string_cmdln="${array_cmdln[@]}"; if [[ -z ${array_cmdln[*]} ]] || [[ -z $string_cmdln ]]; then continue; fi; if grep -rilqe "$string_cmdln" /usr/lib/systemd/system; then printf 'yes\t'; else printf 'no\t'; fi; printf '%s\n' "${string_cmdln}"; fi; done; } | head -n20

      if [[ -n ${a_pids[*]:0:1} ]]
      then

        for WW in "${!a_pids[@]}"
        do
            : $'\x22${a_pids[WW]}\x22:' "${a_pids[WW]}" # <>

          ps aux |
            awk --assign "CC=${a_pids[WW]}" '$2 ~ CC { print }'

          : "${Color_SubComent} Ensure a process is still running before trying to kill it ${Color_AttributesOff}"

          ## Note, some strings from /proc/[pid]/cmdline include \[]\ brackets; \pgrep -f\ parses these as
          #+  ERE\s and cannot parse fixed strings, so a Parameter Expansion is necessary in order to render
          #+  any opening bracket \[\ as non-special for ERE syntax.
          ## Note, subprocesses, killing a daemon, for example, avahi, might also kill some other processes
          #+  which were avahi\s child processes, so when the for loop, looping through PID\s to be restarted,
          #+  gets to those child processes, then those child processes are no longer active, and
          #+  \/proc/${a_pids[WW]}/cmdline\ would not exist.
          sleep 1

          : "${Color_SubComent} Most existing processes have some commandline information available ${Color_AttributesOff}"
          :
          : "${Color_SubComent} If the /proc/PID/cmdline FSO exists and is a file, then... ${Color_AttributesOff}"
          if [[ -f /proc/${a_pids[WW]}/cmdline ]]
          then
            ## Note, these files are in /proc - of course they have a zero filesize!!

            ## Bug, the bash(ism) \[[\ keyword cannot accept a leading or internal \2>/dev/null\, though
            #+  \test\ and \[\ can.

            : "${Color_SubComent} If the /proc/PID/cmdline FSO also has a size greater than zero... ${Color_AttributesOff}"
            if [[ -n $( tr -d '\0' < "/proc/${a_pids[WW]}/cmdline" ) ]]
            then
              local -a array_of_PIDs_cmdline
              local string_of_PIDs_cmdline

              : "${Color_SubComent} Load the cmdline into an array ${Color_AttributesOff}"
              readarray -d '' -t array_of_PIDs_cmdline < <(
                cat "/proc/${a_pids[WW]}/cmdline"
              )

              : $'Skip zombie processes, which have zero length \x22/proc/[pid]/cmdline\x22 files'
              if [[ -z ${array_of_PIDs_cmdline[*]} ]]
              then
                unset "a_pids[WW]" array_of_PIDs_cmdline
                continue
              fi

              : "${Color_SubComent} If the commandline cannot be found in ps output, then move on to the next loop ${Color_AttributesOff}"
              string_of_PIDs_cmdline=( "${array_of_PIDs_cmdline[@]//\[/\\[}" )

              if ! pgrep -f "${string_of_PIDs_cmdline[*]}" >/dev/null
              then
                unset "a_pids[WW]" string_of_PIDs_cmdline
                continue
              fi

              if ! ps hp "${a_pids[WW]}" >/dev/null
              then
                unset "a_pids[WW]" string_of_PIDs_cmdline
                continue
              fi
              unset string_of_PIDs_cmdline array_of_PIDs_cmdline
            else
              unset "a_pids[WW]" string_of_PIDs_cmdline
              continue
            fi
          else
            : "If the /proc/PID/cmdline FSO does not exist, then begin the next loop"
            unset "a_pids[WW]" string_of_PIDs_cmdline
            continue
          fi

          : "${Color_SubComent} Kill a particular process ${Color_AttributesOff}"
          hash -r
          sudo -- "$(type -P kill)" \
            --timeout 1000 HUP \
            --timeout 1000 USR1 \
            --timeout 1000 TERM \
            --timeout 1000 KILL "${ver__[@]}"  "${a_pids[WW]}"
          sleep 3
          ps aux |
            awk --assign "DD=${a_pids[WW]}" '$2 ~ DD { print }'

        done
        unset WW
      fi
    done
    unset VV
  fi
  unset pkg_nms_for_removal addl_pkgs
  unset for_{admin,bash,bashdb,db_ish,bugg_rpts,duh,firefox,fun,gcov,git,internet,later_{other,trace}}
  unset for_{linting,lockfile,os_dnlds,strings,term_tests,unicode}
  unset grep_args removable_pkgs rr pkgs_installed not_yet_installed_pkgs

  : "${Color_SubComent} Restart any processes that may need to be restarted. Begin by getting a list of any such PIDs ${Color_AttributesOff}"
  _fn_get_pids_for_restarting_

  : $'Get new hash of installed packages, ie, \x24{hash..B}'
  hash_of_installed_pkgs_B=$(
    rpm --all --query |
      sha256sum |
      awk '{ print $1 }'
  )

  : $'Write \x24{hash..B} to disk'

  local hash_of_installed_pkgs_B_prev
  hash_of_installed_pkgs_B_prev="${hash_of_installed_pkgs_B}"

  : "${Color_SubComent} If the target file exists ${Color_AttributesOff}"
  if [[ -f ${hash_f} ]]
  then

    : "${Color_SubComent} If the target file is immutable ${Color_AttributesOff}"
    local has_immutable
    has_immutable=$(
      lsattr -l "${hash_f}" |
        awk '$1 ~ /i/ { printf "Yes" }'
    )

    if [[ ${has_immutable} = "Yes" ]]
    then

      : "${Color_SubComent}...then remove the immutable flag ${Color_AttributesOff}"
      sudo chattr -i "${hash_f}"
    fi

  : "${Color_SubComent} if the target file does not exist ${Color_AttributesOff}"
  else

    : "${Color_SubComent} then create it ${Color_AttributesOff}"
    touch "${hash_f}"
  fi

  : "${Color_SubComent} Make sure the file is writeable ${Color_AttributesOff}"
  [[ -w "${hash_f}" ]] ||
    chmod u+w "${hash_f}"

  : "${Color_SubComent} State, the file exists and is writeable ${Color_AttributesOff}"

  : $'Write \x24{hash..B} to disk, and make it RO and immutable.'
  printf '%s\n' "${hash_of_installed_pkgs_B_prev}" |
    tee "${hash_f}"
  chmod 400 "${ver__[@]}" "${hash_f}"
  sudo chattr +i "${hash_f}"
  unset hash_f

  ## ToDo: change temp-vars (II, XX, etc) to fully named vars

  if  ! [[ ${hash_of_installed_pkgs_A} = ${hash_of_installed_pkgs_B} ]] ||
      [[ ${#a_pids[@]} -gt 0 ]]
  then

    while true
    do

      ## Note,  [[ ... = , this second test,  [[ ${a_pids[*]} = 1 ]]  is correct. This means, do not use
      #+  ((...)) , and \=\ is intended to that \1\ on RHS is matched as in Pattern Matching, ie, as \PID 1.\
      : $'if any PID\x60s were found... ...and if there are any PID\x60s other than PID 1...'
      if  [[ -n ${a_pids[*]: -1:1} ]] &&
          ! [[ ${a_pids[*]} = 1 ]]
      then
        II=0
        XX=${#a_pids[@]}

        : "${Color_SubComent} Print some info and wait for it to be read ${Color_AttributesOff}"
        ## Note, "\x60" is a grace accent used as a single quote
        printf '\n  %b for restarting, count, %d \n\n' 'PID\x60s' "${XX}"

          sleep 1 # <>

        : "${Color_SubComent} for each signal and for each PID... ${Color_AttributesOff}"
        for YY in "${!a_pids[@]}"
        do
          ## Note, readability
          : $'\x60kill\x60'" loop $(( ++II )) of ${XX}"

          ZZ=${a_pids[YY]}
          (( ZZ == 1 )) &&
            continue 001
          sleep 1

          for AA in HUP USR1 TERM KILL
          do

              : "${Color_SubComent} To kill PID ${ZZ} with signal ${AA} ${Color_AttributesOff}"

            sync --file-system

              wait -f # <>

            : "${Color_SubComent}...if the PID is still running... ${Color_AttributesOff}"
            if  ps --no-headers --quick-pid "${ZZ}"
            then
              : "${Color_SubComent} Evidently, I need to give the system a little time for processing ${Color_AttributesOff}"
              sleep 1

              ## Bug?? all of the \type -P\ commands s\b consolidated into a s\et of variables ...?

              : $'...then \x60kill\x60 it with the according per-loop SIGNAL...'
              ## Note, the exit codes for  kill  only indicate whether or not the target PIDs existed, rather
              #+ than whether the  kill  operation succeeded, per  info kill .
              sudo -- "$( type -P kill )" --signal "${AA}" -- "${ZZ}"

              : "${Color_SubComent} Evidently, I need to give the system a little MORE time for processing ${Color_AttributesOff}"
              sleep 1

              : "${Color_SubComent}...and if the PID in question no longer exists then unset the current array index number ${Color_AttributesOff}"
              if  ps --no-headers --quick-pid "${ZZ}" |
                    grep -qv defunct
              then
                is_pid_a_zombie=$(
                  ps aux |
                    awk --assign "EE=${ZZ}" '$2 ~ EE { print $8 }'
                )

                if [[ ${is_pid_a_zombie} = Z ]]
                then
                  : "${Color_SubComent} Process is a zombie; unsetting ${Color_AttributesOff}"
                  unset "a_pids[YY]"
                  break 1
                else
                  continue 1
                fi
              else
                unset "a_pids[YY]"
                continue 2
              fi
            else
              unset "a_pids[YY]"
              break 1
            fi
          done
          unset AA
        done
        unset YY ZZ
      else
        break 1
      fi
    done
    unset II XX a_pids is_pid_a_zombie
  fi
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_gh_cli_() ${Color_AttributesOff}"
function _fn_setup_gh_cli_()
{                        _als_fnction_boundary_in_

  : "${Color_SubComent} GH -- s\et config key-value pairs ${Color_AttributesOff}"
  local -A github_configs
  local gh_config_list_out
  github_configs+=( [editor]=vim )
  github_configs+=( [browser]=firefox )
  github_configs+=( [pager]=less )
  github_configs+=( [git_protocol]=ssh )
  gh_config_list_out=$(
    gh config list |
      tr '\n' \
  )

  for KK in "${!github_configs[@]}"
  do
    ## Note, \SC2076 (warning): Remove quotes from right-hand side of =~ to match as a regex rather than literally.\
    if ! [[ ${gh_config_list_out} =~ ${KK}=${github_configs[${KK}]} ]]
    then
      gh config set "${KK}" "${github_configs[${KK}]}"
    fi
  done
  unset KK
  unset gh_config_list_out github_configs

    wait -f # <>
    hash -r

  ## Bug, \gh auth status\ is executed too many (ie, 3) times. Both the checkmarks and the exit code are used

    #gh auth status ## <>

  : "${Color_SubComent} GH -- Login to github ${Color_AttributesOff}"
  ## Note, this command actually works as desired, neither pipefail nor the ERR trap are triggered
  printf -v count_gh_auth_checkmarks "%s" "$(
    gh auth status |&
    grep --count $'\xe2\x9c\x93'
  )"

  if  ! gh auth status 2>/dev/null 1>&2 ||
      [[ ${count_gh_auth_checkmarks} -ne 4 ]]
  then
    if ! pgrep firefox
    then
      firefox --browser 2>/dev/null 1>&2 &
      sleep 5
      _fn_pause_to_check_ "${nameref_Lineno}" $'Waiting till browser is open before running \x60gh auth\x60 command'
      _fn_gh_auth_login_command_
    fi
  fi

  ## Bug, when \gh ssh-key list\ fails, then after _fn_gh_auth_login_command_() executes, \gh ssh-key list\ is
  #+  not executed again, when it should be

  : "${Color_SubComent} GH -- Get SSH & GPG keys ${Color_AttributesOff}"
  for QQ in ssh-key gpg-key
  do
    if ! gh "${QQ}" list > /dev/null 2>&1
    then
      _fn_gh_auth_login_command_
    fi
  done
  unset QQ

  : "${Color_SubComent} GH -- Use GitHub CLI as a credential helper ${Color_AttributesOff}"
  gh auth setup-git --hostname github.com
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_git_() ${Color_AttributesOff}"
function _fn_setup_git_()
{                           _als_fnction_boundary_in_

  ## Note, git ui colors: normal black red green yellow blue magenta cyan white
  #+  git ui attributes: bold dim ul (underline blink reverse)
  ## Note, In vim, since \expandtab\ is s\et in .vimrc, to make some actual tabs, press Ctrl-v-[tab]

  ## Bug? in vim, when quoting \EOF\, $tmp_dir changes color, but bash still expands the redirection
  #+ destination file.

  : "${Color_SubComent} Git -- parameters, dependency level 1 ${Color_AttributesOff}"
  local git_conf_global_f git_ignr git_mesg
  git_conf_global_f=~/.gitconfig
  git_ignr=~/.gitignore
  git_mesg=~/.gitmessage

  : "${Color_SubComent} Paramters with globs ${Color_AttributesOff}"
  ## Note, use of globs. The RE pattern must match all of the patterns in the array assignments
  local git_files_a git_regexp
  git_files_a=( /etc/git* /etc/.git* ~/.git* )
  git_regexp=git"*"

  : "${Color_SubComent} Git -- parameters, dependency level 2 ${Color_AttributesOff}"
  if [[ -f ${git_conf_global_f} ]]
  then
    local git_cnf_glob_list
    readarray -t git_cnf_glob_list < <(
      git config --global --list
    )
  fi

  ## Note, write large array assignments this way so that they mirror xtrace output cleanly
  ## ToDo, make a note of this in my style guide

  local -A git_keys
  git_keys+=( [color.diff]=always )
  git_keys+=( [color.diff.meta]=blue\ black\ bold )
  git_keys+=( [color.interactive]=always )
  git_keys+=( [color.ui]=true )
  git_keys+=( [commit.gpgsign]=true )
  git_keys+=( [commit.template]=${git_mesg} )
  git_keys+=( [core.editor]=vim )
  git_keys+=( [core.excludesfile]=${git_ignr} )
  git_keys+=( [core.pager]=$( type -P less ) )
  git_keys+=( [credential.helper]=cache\ --timeout=3600 )
  git_keys+=( [gpg.program]=$( type -P gpg2 ) )
  git_keys+=( [help.autocorrect]=prompt )
  git_keys+=( [init.defaultBranch]=main )
  git_keys+=( [user.email]=${user_github_email_address} )
  git_keys+=( [user.name]=${user_real_name} )
  git_keys+=( [user.signingkey]=${user_github_gpg_key} )

  : "${Color_SubComent} Git -- Files must exist and Permissions ${Color_AttributesOff}"
  read -r -a prev_umask < <(
    umask -p
  )
  umask 133

  : "${Color_SubComent} Remove any unmatched glob patterns ${Color_AttributesOff}"
  local ZZ

  for ZZ in "${!git_files_a[@]}"
  do
    if [[ ${git_files_a[ZZ]} =~ ${git_regexp} ]]
    then
      unset "git_files_a[ZZ]"
    fi
  done
  unset ZZ git_regexp

  : $'Git -- Create files and s\et DAC\x60s as necessary - Loop B'
  local AA
  for AA in "${git_files_a[@]}"
  do
    : '  Loop B - open \\\ '
    sudo -- [ -e "${AA}" ] ||
      sudo -- touch "${AA}"
    sudo -- chmod 0600 "${ver__[@]}" "${AA}"
    : "${Color_SubComent} Loop B - shut ///  ${Color_AttributesOff}"
  done
  unset AA
  : "${Color_SubComent} Loops B - complete ===  ${Color_AttributesOff}"

  builtin "${prev_umask[@]}"

  : "${Color_SubComent} Git -- remove a particular configuration key/value pair if present ${Color_AttributesOff}"
  if  printf '%s\n' "${git_cnf_glob_list[@]}" |
        grep gpg.format "${qui__[@]}"
  then
    git config --global --unset gpg.format
  fi

  : "${Color_SubComent} Git -- setup configuration - Loop C ${Color_AttributesOff}"
  local BB
  for BB in "${!git_keys[@]}"
  do
    : '  Loop C - open \\\ '

      : "${Color_SubComent} BB:${BB} ${Color_AttributesOff}"

    if ! grep -e "${BB#*.} = ${git_keys[${BB}]}" "${qui__[@]}" "${git_conf_global_f}"
    then
      git config --global "${BB}" "${git_keys[${BB}]}"
    fi
    : "${Color_SubComent} Loop C - shut ///  ${Color_AttributesOff}"
  done
  unset BB
  : "${Color_SubComent} Loops C - complete ===  ${Color_AttributesOff}"

  : "${Color_SubComent} Git -- gitmessage (global) ${Color_AttributesOff}"
  if ! [[ -f ${git_mesg} ]]
  then
    : "${Color_SubComent} Heredoc, gitmessage ${Color_AttributesOff}"
    cat <<- "EOF" > "${tmp_dir}/msg"
		Subject line (try to keep under 50 characters)

		Multi-line description of commit,
		feel free to be detailed.

		[Ticket: X]

		EOF

    # shellcheck disable=SC2024 #(info): sudo does not affect redirects. Use sudo cat file | ..
    tee -- "${git_mesg}" < "${tmp_dir}/msg" > /dev/null || {
      _als_die_
    }
    chmod 0644 "${ver__[@]}" "${git_mesg}" || {
      _als_die_
    }
  fi

  : "${Color_SubComent} Git -- gitignore (global) ${Color_AttributesOff}"
  if  ! [[ -f ${git_ignr} ]] ||
      ! grep swp "${qui__[@]}" "${git_ignr}"
  then
    : "${Color_SubComent} Heredoc, gitignore ${Color_AttributesOff}"
    cat <<- \EOF > "${tmp_dir}/ign"
		*~
		.*.swp
		.DS_Store

		EOF

    # shellcheck disable=SC2024
    tee -- "${git_ignr}" < "${tmp_dir}/ign" > /dev/null || {
      _als_die_
    }
    chmod 0644 "${ver__[@]}" "${git_ignr}" || {
      _als_die_
    }
  fi

  : $'Git -- Set correct DAC\x60s (ownership and permissions)'
  local HH
  for HH in "${git_mesg}" "${git_ignr}"
  do
    if  ! [[ "$( stat -c%u "${HH}" )" = "${login_uid}" ]] ||
        ! [[ "$( stat -c%g "${HH}" )" = "${login_gid}" ]]
    then
      sudo -- chown "${login_uid}:${login_gid}" "${ver__[@]}" "${HH}"
    fi

    if ! [[ "$( stat -c%a "${HH}" )" = 0400 ]]
    then
      chmod 0400 "${ver__[@]}" "${HH}"
    fi
  done
  unset HH

  : "${Color_SubComent} Clean up after section, Git ${Color_AttributesOff}"
  unset git_files_a git_conf_global_f git_mesg git_ignr git_keys
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_gti_user_dirs_() ${Color_AttributesOff}"
function _fn_setup_gti_user_dirs_()
{                 _als_fnction_boundary_in_

  ## Note, in order to clone into any repo, and keep multiple repos separate,  cd  is required, or  pushd  /
  #+   popd

  : "${Color_SubComent} Variables -- global, for use for entire script ${Color_AttributesOff}"
  dev_d1=~/MYPROJECTS
  dev_d2=~/OTHERSPROJECTS
  readonly dev_d1
  readonly dev_d2

  : "${Color_SubComent} Make dirs ${Color_AttributesOff}"
  local UU
  for UU in "${dev_d1}" "${dev_d2}"
  do
    if ! [[ -d ${UU} ]]
    then
      mkdir --mode=0700 "${ver__[@]}" "${UU}" || {
        _als_die_
      }
    fi
  done
  unset UU

  : "${Color_SubComent} Change dirs ${Color_AttributesOff}"
  pushd "${dev_d1}" > /dev/null || {
    _als_die_
  }
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_gpg() ${Color_AttributesOff}"
function _fn_setup_gpg()
{                           _als_fnction_boundary_in_

  : "${Color_SubComent} If any files in ~/.gnupg are not owned by either USER or root, then error out and exit ${Color_AttributesOff}"
  local -a problem_files
  problem_files=()
  readarray -d "" -t problem_files < <(
      find -- ~/.gnupg -xdev \
        \( \
          \(  \!  -uid "${login_gid}" -a  \! -gid 0  \) -o \
          \(  \!  -gid "${login_uid}" -a  \! -uid 0  \) \
        \)  -print0 \
  )
  [[ -n ${problem_files[*]} ]] && {
    _als_die_ Incorrect ownership on -- "${problem_files[@]}"
  }
  unset problem_files

  : $'If any files are owned by root, then change their ownership to \x24USER'
  sudo -- \
    find -- ~/.gnupg -xdev \( -uid 0 -o -gid 0 \) -execdir \
      chown "${login_uid}:${login_gid}" "${ver__[@]}" \{\} \; || {
        _als_die_
      }

  : $'If any dir perms aren\x60t 700 or any file perms aren\x60t 600, then make them so'
  find -- ~/.gnupg -xdev -type d \! -perm 700  -execdir \
    chmod 700 "${ver__[@]}" \{\} \; #
  find -- ~/.gnupg -xdev -type f \! -perm 600  -execdir \
    chmod 600 "${ver__[@]}" \{\} \; #

  : "${Color_SubComent} GPG -- If a gpg-agent daemon is running, or not, then, either way say so ${Color_AttributesOff}"
  # shellcheck disable=SC2009
  if ps aux | grep -q --extended-regexp "[g]pg-a.*daemon" "${qui__[@]}"
  then
    printf '\n\tgpg-agent daemon IS RUNNING\n\n'

    ## Why was this command in here???
    #gpgconf --kill "${ver__[@]}" gpg-agent

  else
    printf '\n\tgpg-agent daemon is NOT running\n\n'
  fi

  ## Why was this command in here???
  #gpg-connect-agent "${ver__[@]}" /bye

  GPG_TTY=$( tty )
  export GPG_TTY
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_network() ${Color_AttributesOff}"
function _fn_setup_network()
{                       _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  dns_srv_1=8.8.8.8
  dns_srv_A=75.75.75.75
  readonly dns_srv_1 dns_srv_A

  if  ! _fn_test_dns "${dns_srv_1}" ||
      ! _fn_test_dns "${dns_srv_A}"
  then
    printf '\n%s, Attempting to connect to the internet... \n\n' "${scr_nm}"

    : "${Color_SubComent} Try to get NetworkManager up and running ${Color_AttributesOff}"
    sudo -- nice --adjustment=-20 -- systemctl start -- NetworkManager.service
    wait -f

    : "${Color_SubComent} Turn on networking ${Color_AttributesOff}"
    sudo -- nmcli n on

    : "${Color_SubComent} Turn on WiFi ${Color_AttributesOff}"
    sudo -- nmcli r wifi on

    : "${Color_SubComent} Get interface name(s) ${Color_AttributesOff}"
    readarray -d "" -t ifaces < <(
      nmcli --terse c |
        awk --field-separator : '$1 !~ /lo/ { printf "%s\0", $1 }'
    )

    : "${Color_SubComent} Connect the interface ${Color_AttributesOff}"
    case "${#ifaces[@]}" in
      0 )
        _als_die_ "No network device available"
        ;; #
      1 )
        nmcli c up "${ifaces[*]}"
        sleep 5
        ;; #
      * )
        _als_die_ "Multiple network devices available"
        ;; #
    esac

    if  ! _fn_test_dns "${dns_srv_1}" ||
        ! _fn_test_dns "${dns_srv_A}"
    then
      printf '\n%s, Network, Giving up, exiting.\n\n' "${scr_nm}"
    else
      printf '\n%s, Network, Success!\n\n' "${scr_nm}"
    fi
  fi

  : "${Color_SubComent} Clean up from Network ${Color_AttributesOff}"
  ## Note, dns_srv_A will be used at the end of the script
  unset -f _fn_test_dns
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_ssh() ${Color_AttributesOff}"
function _fn_setup_ssh()
{                           _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  ## Bug? hardcoded filenames? ...yes, I know it#s mis-spelled.

  local ssh_usr_conf_dir ssh_user_conf_file
  ssh_usr_conf_dir=~/.ssh/
  ssh_user_conf_file=~/.ssh/config

  : "${Color_SubComent} Make sure the SSH config directory and file for USER exist ${Color_AttributesOff}"
  [[ -d ${ssh_usr_conf_dir} ]] ||
    mkdir -m 0700 "${ssh_usr_conf_dir}" || {
      _als_die_
    }
  [[ -f ${ssh_user_conf_file} ]] ||
    _fn_write_ssh_conf || {
      _als_die_
    }
    _als__fn_pause_to_check__ # <>

  ## ToDo, _rm_ should be an alias
  ## ToDo, all aliases should be prefixed and suffixed with underscores, while functions should
  #+  include at least one underscore

  : $'Make sure the SSH config file for USER is correct, and write it if it is missing or wrong'
  if ! grep "ForwardAgent yes" "${qui__[@]}" "${ssh_user_conf_file}"
  then
    "$( type -P rm )" --force --one-file-system --preserve-root=all "${ver__[@]}" "${ssh_user_conf_file}"
    _fn_write_ssh_conf
  fi
  unset -f _fn_write_ssh_conf

  ## Bug, security, these #chown# commands should operate on the files while they are still in skel_LiveUsb
  #+  see also similar code in _fn_setup_gpg(), possibly elsewhere also  :-\

  ## Bug, timestamps, chown changes ctime on every execution, whether or not the ownership changes

  : $'Make sure the SSH config directories and files for USER have correct DAC\x60s'
  {
    sudo -- \
      find -- "${ssh_usr_conf_dir}" -xdev \
        \(  \! -uid "${login_uid}"  -o  \
            \! -gid "${login_gid}"  \
        \) -execdir \
          chown -- "${login_uid}:${login_gid}" "${ver__[@]}" \{\} \; || {
            _als_die_
          }
    find -- "${ssh_usr_conf_dir}" -xdev -type d -execdir \
      chmod 700 "${ver__[@]}" \{\} \; #
    find -- "${ssh_usr_conf_dir}" -xdev -type f -execdir \
      chmod 600 "${ver__[@]}" \{\} \; #
  }
  unset ssh_usr_conf_dir ssh_user_conf_file

  ## Bug? not necc to restart ssh-agent if both of these vars exist?

    : "${Color_SubComent}${SSH_AUTH_SOCK:=}" "${SSH_AGENT_PID:=} ${Color_AttributesOff}"
    declare -p SSH_AUTH_SOCK SSH_AGENT_PID # <>

    _als__fn_pause_to_check__ # <>

  : "${Color_SubComent} Get the PID of any running SSH Agents -- there may be more than one ${Color_AttributesOff}"
  local -a ssh_agent_pids
  readarray -t ssh_agent_pids < <(
    ps h -C 'ssh-agent -s' -o pid |
      tr -d ' '
  )

  : "${Color_SubComent} Make sure ssh daemon is running (?) ${Color_AttributesOff}"
  if  [[ -z ${SSH_AUTH_SOCK:-} ]] ||
      [[ -z ${SSH_AGENT_PID:-} ]] ||
      [[ -z ${ssh_agent_pids[*]:-} ]]
  then
    : $'If there aren\x60t any SSH Agents running, then start one'
    ## Note, https://stackoverflow.com/questions/10032461/git-keeps-asking-me-for-my-ssh-key-passphrase
    local HH
    HH=$(
      ssh-agent -s
    )
    eval "${HH}"
    unset HH

    : "${Color_SubComent}...and try again to get the PID of the SSH Agent ${Color_AttributesOff}"
    readarray -t ssh_agent_pids < <(
      ps h -C 'ssh-agent -s' -o pid |
        tr -d ' '
    )
  fi

    _als__fn_pause_to_check__ # <>

  case "${#ssh_agent_pids[@]}" in
    0 )
        _als_die_ "ssh-agent failed to start"
      ;; #
    1 )
        if [[ -z ${SSH_AGENT_PID:-} ]]
        then
          SSH_AGENT_PID="${ssh_agent_pids[*]}"

            declare -p SSH_AGENT_PID ## <>
        fi
      ;; #
    * )
        ## ToDo, _kill_ should be an alias?

        : "${Color_SubComent} If more than one ssh-agent is running, then keep the first and kill the rest ${Color_AttributesOff}"
        local II
        for II in "${!ssh_agent_pids[@]}"
        do
          [[ ${II} = 0 ]] &&
            continue
          "$( type -P kill )" "${ver__[@]}" "${ssh_agent_pids[II]}"
          printf '<%s>\n' "${II}"
        done
        unset II
      ;; #
  esac

  ## ToDo, review these commands for necessity
  ## Note, ssh-add  and  ssh  don\t have long options.

  #: "?"
  #ssh-add -v

  ## Note,  ssh-add -L  is "list;"
  #ssh-add -L -v

  ## Note,  ssh -T  is "disable pseudo-terminal allocation."
  #ssh -T git@github.com ## Note, returns exit code 1; why is this command here exectly?
                                                 _als_fnction_boundary_out_0_
}




#: "setup_systemd()"
#function _fn_setup_systemd()
#{                      _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_
  ### Note, services to disable and mask
  ##+  ModemManager.service
  ##+ ...
  ### Note, services to disable and mask
  ##+ ...
#}




: "${Color_SubComent} Define _fn_setup_temp_dirs() ${Color_AttributesOff}"
function _fn_setup_temp_dirs()
{                     _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  tmp_dir=$(
    if ! TMPDIR="" mktemp --directory --suffix=-LiveUsb 2>&1
    then
      _als_die_
    fi
  )

  [[ -d ${tmp_dir} ]] || {
    _als_die_
  }
  readonly tmp_dir
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_time() ${Color_AttributesOff}"
function _fn_setup_time()
{                          _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  sudo -- timedatectl set-local-rtc 0
  sudo -- timedatectl set-timezone America/Vancouver
  sudo -- systemctl start chronyd.service || {
    _als_die_
  }
  sudo -- chronyc makestep > /dev/null
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_setup_vim() ${Color_AttributesOff}"
function _fn_setup_vim()
{                           _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  : "${Color_SubComent} Heredoc of vim-conf-text ${Color_AttributesOff}"
  cat <<- \EOF | tee -- "${tmp_dir}/vim-conf-text" > /dev/null
		" ~/.vimrc

		" per Google
		set number

		" per https://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim
		filetype plugin indent on
		" show existing tab with 2 spaces width
		set tabstop=2
		" when indenting with ">", use 2 spaces width
		set shiftwidth=2
		" On pressing tab, insert 2 spaces
		set expandtab

		" per https://superuser.com/questions/286290/is-there-any-way-to-hook-saving-in-vim-up-to-commiting-in-git
		autocmd BufWritePost * execute '! if [[ -d .git ]]; then git commit -S -a -F -; fi'

		EOF

  : $'Get an array of the FS location\x28s\x29 of root\x60s vimrc\x28s\x29'
  local -a arr_vrc
  readarray -d "" -t arr_vrc < <(
    sudo -- find -- /root -name "*vimrc*" -print0
  )

  local strng_vrc
  case "${#arr_vrc[@]}" in
    0 )
        strng_vrc=/root/.vimrc
      ;; #
    1 )
        strng_vrc="${arr_vrc[*]}"
      ;; #
    *)
        printf '\n  Multiple .vimrc files found, please edit the filesystem.\n' >&2
        printf '\t%s\n' "${arr_vrc[@]}" >&2
        _als_die_
      ;; #
  esac

  if (( "${#arr_vrc[@]}" == 1 ))
  then
    read -r WW XX < <(
      sha256sum -- "${tmp_dir}/vim-conf-text" 2>&1
    )
    read -r YY XX < <(
      sudo -- sha256sum -- "${strng_vrc}" 2>&1
    )
    unset      XX
  else
    sudo -- touch -- "${strng_vrc}" # <> s\et-e
  fi

  : "${Color_SubComent} Write .vimrc ${Color_AttributesOff}"
  if  (( ${#arr_vrc[@]} == 0 )) ||
      ! [[ ${WW} = "${YY}" ]]
  then
    : $'Test returned \x22true,\x22 the number didn\x60t match, so write to .vimrc'

    : "${Color_SubComent} Set the umask ${Color_AttributesOff}"
    read -ra umask_prior < <(
      umask -p
    )
    umask 177

    : "${Color_SubComent} Write the root file ${Color_AttributesOff}"
    sudo -- rsync --archive --checksum -- "${tmp_dir}/vim-conf-text" "${strng_vrc}" || {
      _als_die_
    }

    : "${Color_SubComent} Copy the root file to ${HOME}"$' and repair DAC\x60s on '"${USER}"$'\x60s copy'
    sudo -- rsync --archive --checksum -- "${strng_vrc}" ~/.vimrc || {
      _als_die_
    }
    sudo -- chown "${UID}:${UID}" -- ~/.vimrc
    chmod 0400 -- ~/.vimrc

    : "${Color_SubComent} Reset the umask ${Color_AttributesOff}"
    builtin "${umask_prior[@]}"
  fi
  unset arr_vrc strng_vrc WW YY umask_prior
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_test_dns() ${Color_AttributesOff}"
function _fn_test_dns()
{                            _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  ping -c 1 -W 15 -- "$1" > /dev/null 2>&1
  return "$?"
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_test_os() ${Color_AttributesOff}"
function _fn_test_os()
{                             _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  local kern_rel
  kern_rel=$(
    uname --kernel-release
  )

  ## Note, test of $kern_rel is a test for whether the OS is Fedora (ie, "fc38" or "Fedora Core 38")
  if ! [[ ${kern_rel} =~ \.fc[0-9]{2}\. ]]
  then
    _als_die_ "OS is not Fedora"
  fi
  unset kern_rel
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_trap_err() ${Color_AttributesOff}"
function _fn_trap_err()
{                            _als_fnction_boundary_in_

  declare -p BASH BASH_ALIASES BASH_ARGC BASH_ARGV BASH_ARGV0 BASH_CMDS BASH_COMMAND BASH_LINENO
  declare -p BASH_REMATCH BASH_SOURCE BASH_SUBSHELL BASHOPTS BASHPID DIRSTACK EUID FUNCNAME HISTCMD IFS
  declare -p LC_ALL LINENO PATH PIPESTATUS PPID PWD SHELL SHELLOPTS SHLVL UID
                                                 _als_fnction_boundary_out_0_
}




## Bug, these var assignments $prev_cmd_exit_code and $lineno only fail when they\re on line number >=2
#+  of  trap  "args section" ??

: "${Color_SubComent} Define _fn_trap_exit() ${Color_AttributesOff}"
## Note, these variable assignments must be on the 1st line of the funtion in order to capture correct data
# shellcheck disable=SC2317
function _fn_trap_exit()
{                           _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  trap - EXIT

  : "${Color_SubComent} Remove temporary directory, if one exists ${Color_AttributesOff}"
  [[ -d ${tmp_dir:=} ]] &&
    "$( type -P rm )" --force --one-file-system --preserve-root=all --recursive "${ver__[@]}" "${tmp_dir}"

  builtin exit "${prev_cmd_exit_code}"
                                                 _als_fnction_boundary_out_0_
}




: "${Color_SubComent} Define _fn_write_bashrc_strings() ${Color_AttributesOff}"
function _fn_write_bashrc_strings()
{                _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  : "${Color_SubComent} Certain parameters must be defined and have non-zero values ${Color_AttributesOff}"
  (( ${#files_for_use_with_bash[@]} == 0 )) && {
    _als_die_
  }
  (( $# == 0 )) && {
    _als_die_
  }

  local JJ file_x Aa_index Aa_element
  local -n fn_nameref

  : "${Color_SubComent} For each s\et of strings to append into bashrc"
  for JJ
  do
    : 'Loop D - open \\\ '

    unset -n fn_nameref
    local -n fn_nameref="${JJ}"

    : "${Color_SubComent} For each .bashrc"
    for file_x in "${files_for_use_with_bash[@]}"
    do
      : 'Loop D:1 - open \\\ '

      : "${Color_SubComent} file_x, ${file_x} ${Color_AttributesOff}"

      : "${Color_SubComent} For each definition (function or parameter)"
      for Aa_index in "${!fn_nameref[@]}"
      do
        : 'Loop D:1:a - open \\\ '

        : "${Color_SubComent} Aa_index, ${Aa_index} ${Color_AttributesOff}"
        Aa_element="${fn_nameref[${Aa_index}]}"

        : "${Color_SubComent}(1) If the definition is not yet written into the file... ${Color_AttributesOff}"
        if ! sudo -- grep --quiet --fixed-strings "## ${Aa_index}" -- "${file_x}"
        then

          : "${Color_SubComent} Then write the function definition into the file ${Color_AttributesOff}"
          printf '\n## %s \n%s \n' "${Aa_index}" "${Aa_element}" |
            sudo -- tee --append -- "${file_x}" > /dev/null || {
              _als_die_
            }
        else
          : "${Color_SubComent} Definition exists, skipping ${Color_AttributesOff}"
        fi

        ## Bug, what if it\s a multiline alias?

        ## Question, can `sed` take variable assignments the way `awk` can?

        : "${Color_SubComent}(2) If there is an alias by the same name, then delete it from the bashrc file at hand... ${Color_AttributesOff}"
        sudo -- sed --in-place "/^alias ${Aa_index##* }=/d" -- "${file_x}"

        : "${Color_SubComent} Loop D:1:a - shut /// "
      done
      unset Aa_element
      : "${Color_SubComent} Loops D:1:a - complete === "

      : "${Color_SubComent} For each file, if absent add a newline at EOF ${Color_AttributesOff}"
      if  sudo -- tail --lines 1 -- "${file_x}" |
            grep --quiet --extended-regexp "[[:graph:]]"
      then
        printf '\n' |
          sudo -- tee --append -- "${file_x}" > /dev/null
      fi

      : "${Color_SubComent} Loop D:1 - shut /// "
    done
    : "${Color_SubComent} Loops D:1 - complete === "

    : "${Color_SubComent} Reset for the next loop, assuming there is one ${Color_AttributesOff}"
    ## Note, ?? use  unset  so that values from previous loops will not interfere with the current loop
    shift

    : "${Color_SubComent} Loop D - shut /// "
  done
  unset JJ
  : "${Color_SubComent} Loops D - complete === "
                                                 _als_fnction_boundary_out_0_
}




## ToDo, look at how each conf file is defined and written, each one's a little different. Make them
#+  uniform with each other, since the purpose of each section is the same in each case.

function _fn_write_ssh_conf()
{                      _als_fnction_boundary_in_
  #_als_enble_locl_xtrce_

  ## Bug? $ssh_user_conf_file defined in a different function, _fn_setup_ssh()

  cat <<- \EOF > "${ssh_user_conf_file}"
	Host github.com
	ForwardAgent yes

	EOF
                                                 _als_fnction_boundary_out_0_
}

: "${Color_SubComent} Line ${nameref_Lineno}, Functions Complete ${Color_AttributesOff}"

  ## <>
  #_als_debug_break_
  #: 'hyphen,' "$-"

## ToDo, perhaps there should be a "main()" function.







: "${Color_Comment} Line ${nameref_Lineno}, Define trap on ERR ${Color_AttributesOff}"
trap _fn_trap_err ERR

: "${Color_Comment} Line ${nameref_Lineno}, Define trap on EXIT ${Color_AttributesOff}"
trap _fn_trap_exit EXIT


: "${Color_Comment} Line ${nameref_Lineno}, Regular users with sudo, only ${Color_AttributesOff}"
_fn_must_be_root_

## Note, traps
# EXIT -- for exiting
# HUP USR1 TERM KILL -- for restarting processes
# INT QUIT USR2 -- for stopping logging
# for starting logging ?

: "${Color_Comment} Line ${nameref_Lineno}, Test OS ${Color_AttributesOff}"
_fn_test_os

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Certain files must have been installed from off-disk ${Color_AttributesOff}"
_fn_reqd_user_files_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Network ${Color_AttributesOff}"
_fn_setup_network

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Time ${Color_AttributesOff}"
_fn_setup_time

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Temporary directory ${Color_AttributesOff}"
_fn_setup_temp_dirs

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Minimum necessary rpms ${Color_AttributesOff}"
_fn_min_necc_packages_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Vim ${Color_AttributesOff}"
_fn_setup_vim

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Bash ${Color_AttributesOff}"
_fn_setup_bashrc_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Increase disk space ${Color_AttributesOff}"
_fn_increase_disk_space_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Dnf ${Color_AttributesOff}"
_fn_setup_dnf_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Restart NetworkManager if necessary ${Color_AttributesOff}"

## ToDo: use written function here
for BB in "${dns_srv_A}" "${dns_srv_1}"
do
  if ! ping -4qc1 -- "${BB}" > /dev/null 2>&1
  then
    sudo -- nice --adjustment=-20 -- systemctl restart -- NetworkManager.service || {
      _als_die_
    }
  fi
done
unset BB


: "${Color_Comment} Line ${nameref_Lineno}, SSH ${Color_AttributesOff}"
_fn_setup_ssh

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, GPG ${Color_AttributesOff}"
_fn_setup_gpg

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Make and change into directories ${Color_AttributesOff}"
_fn_setup_gti_user_dirs_

  #_als_debug_break_

: "Git debug settings"
#_fn_enable_git_debug_settings_

: "${Color_Comment} Line ${nameref_Lineno}, Git ${Color_AttributesOff}"
_fn_setup_git_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, GH -- github CLI configuration ${Color_AttributesOff}"
_fn_setup_gh_cli_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Clone repo ${Color_AttributesOff}"
_fn_clone_repo_

  #_als_debug_break_

: "${Color_Comment} Line ${nameref_Lineno}, Remind user of commands for the interactive shell ${Color_AttributesOff}"

popd > /dev/null || {
  _als_die_
}

if ! [[ ${PWD} = ${dev_d1}/${scr_repo_nm} ]]
then
  printf '\n  Now run this command: \n'
  printf '\n\t cd "%s/%s" ; git status \n\n' "${dev_d1}" "${scr_repo_nm}"
fi

  set -v ## <>

: "${Color_Comment} Line ${nameref_Lineno}, Clean up & exit ${Color_AttributesOff}"
printf '  %s - Done \n' "$( date +%H:%M:%S )"
exti_code=00
main_lineno="${nameref_Lineno}" exit

