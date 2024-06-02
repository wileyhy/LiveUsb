#!/bin/bash
## LiveUsb1
##    #!/bin/env -iS bash

## Note, Putting a LN (LINENO) assignment preceding an `exit` command lets the value of LN match the line
#+  number of the `exit` command.
## Note, idempotent script
## Note, the symbol "<>" marks code as for deburging purpoeses only
## Note, ...undocumented feature??
#+    Use `env -i` or else the script\s execution environment will inherit any exported anything,
#+  including and especially functions, from its caller, e.g., any locally defined functions (such as `rm`)
#+  which might be intended to shadow any builtins or commands or to supplant any of the aliases which some
#+  of the various Linux distributions often define and provide for users\ convenience.  These exported
#+  functions which are received from the caller\s environment get printed above the script\s shebang in
#+  xtrace when xtrace and vebose are both enabled on the shebang line. ...but exported variables do not
#+  print.
#+    ...also, using `env` messes up vim\s default bash-colorizations
## Note, style, function definition syntax, "(){ :" makes plain xtrace easier to read
## Note, style, "! [[ -e" doesn\t show the "!" in xtrace, whereas "[[ ! -e" does, and yet, for `grep`.....
## Note, timestamps, `find`, `stat` and `[[` (and `ls`) don\t effect ext4 timestamps, as tested, but
#+  idempotent `chown` and `chmod` do, and of course `touch` does; if there\s no change in the file,
#+  `rsync` doesn\t, but if the file changes, it does. Also, "btime" on ext4 still isn\t consistent.
#+  `grep` has no effect on times; `cp -a` effects "ctimes" even if file contents do not change.

## Reportable burg. `command -p kill "$AA"` executes the bash builtin, judging by the output of `command
#+  -p kill` without any operands. The output of `$( type -P kill )"` without operands is the same as the
#+  output of /usr/bin/kill without operands. The documentation is ...somewhat unclear on these points.
#+    `help command`: "Runs COMMAND with ARGS suppressing shell function lookup...." It seems that what
#+  is intended is, "...suppressing shell function lookup, but still allowing builtins to be executed,"
#+  and possibly also aliases and keywords, though I haven\t tested those. The description of the "-p"
#+  option is particularly misleading: "use a default value for PATH that is guaranteed to find all of
#+  the standard utilities." That "guarantee" sounds as if use of the "-p" option "shall" (using the
#+  POSIX defition of the word) result in a binary utility being used, when actually that is not the
#+  case.
#+    Binary `kill` has a few options not available with the builtin, such as "--timeout", which can be
#+  used to avoid writing an extra for loop...
#+
#+      sudo -- "$( type -P kill )" --verbose \
#+          --timeout 1000 HUP \
#+          --timeout 1000 USR1 \
#+          --timeout 1000 TERM \
#+          --timeout 1000 KILL -- "$WW"
#+
#+    Otherwise, it would be useful, IMO, if `kill --help` showed the help file for /bin/kill, since
#+  using that syntax most likely indicates that intention  :-\

## TODO, lock file, bc ^z
## TODO, add colors to xtrace comments
## TODO, systemd services to disable: bluetooth, cups, [ systemd-resolved ? ]
## TODO, systemd services to possibly enable: sshd, sssd

# <> Deburging
# shellcheck disable=SC1001
declare -nx nL=L\INENO ## <> Note, this assignment is repeated here; originally it\s located in setup_vars()
set -a # <>
set -C # <>
set -u # <>
set -T # <>
set -e # <>
set -o pipefail # <>

hash -r
shopt -s expand_aliases
#set -x # <>

## How to add colors to xtrace comments
C0="$( tput sgr0 )"

unset II a_colors aa_colors
declare -A aa_colors
a_colors=( {1..15} )
  aa_colors+=( ["1"]="Red"            ## Errors
               ["2"]="Green"          ## Per-section and -subsection explanatory comments
               ["3"]="Brown"          ## Aliases re xtrace
               ["4"]="Purple"         ## Technical comments
               ["5"]="Dark blue"
               ["6"]="Teal"
               ["7"]="Pink"
               ["8"]="Dark red"
               ["9"]="Dark green"
               ["10"]="Light green"
               ["11"]="Orange"        ## Function boundary lines
               ["12"]="Blue"          ## Major sections, ie, separate functions
               ["13"]="Magenta"
               ["14"]="Light blue"    ## Aliases at function boundaries
               ["15"]="White" )

for II in "${!aa_colors[@]}"
do
  declare -n XX="C${II}" 
  printf -v XX '%b' "$( tput setaf "${II}" )"

    # <>
    #for II in {0..32}; do  printf '%b %d is some color %b\n' "$( tput setaf "${II}" )" "${II}" "${C0}"; tput sgr0; done
    printf '%b%d is %s%b\n' "${XX}" "${II}" "${aa_colors[$II]}" "${C0}"; tput sgr0
done
unset -n XX
unset aa_colors
readonly C{0..15}

  # <>
  #declare -p C{0..15}
  #echo "C1=$( tput setaf 1 );: 01 is Red; tput sgr0"
  exit "${LINENO}"
  #set -x # <>

: "${C12}Variables likely to be manually changed with some regularity, or which absolutely must be defined early on${C0}"
# shellcheck disable=SC2034
{
  : "${C2}Script metadata${C0}"
  script_start_time=$( date +%H:%M:%S )
  readonly script_start_time
  global_hyphn=$-
  export global_hyphn
  :
  : "${C2}Repo info${C0}"
  scr_repo_nm="LiveUsb"
  scr_nm="LiveUsb1.sh"
  datadir_basenm="skel-LiveUsb"
  datdir_idfile=".${scr_repo_nm}_id-key"
  readonly scr_repo_nm scr_nm datadir_basenm datdir_idfile
  :
  : "${C2}File and partition data and metadata${C0}"
  sha256_of_repo_readme="da016cc2869741834138be9f5261f14a00810822a41e366bae736bd07fd19b7c"
  data_pttn_uuid="7fcfd195-01"
  data_dir_id_sha256="7542c27ad7c381b059009e2b321155b8ea498cf77daaba8c6d186d6a0e356280"
  readonly sha256_of_repo_readme data_pttn_uuid data_dir_id_sha256
  :
  : "${C2}Function boundary parameters${C0}"
  printf -v__ '%b%s%b' "${C13}" '<>  <>  <>  <>  <>  <>  <>  <>  <>  <>  <>  <>  <>' "${C0}"
  #fn_bndry_sh="${C11} ~~~ ~~~ ~~~ ${C0}"
  #fn_bndry_lo="${C11} ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~ ${C0}"
  fn_bndry_sh=" ~~~ ~~~ ~~~ "
  fn_bndry_lo=" ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~ "
  readonly fn_bndry_sh fn_bndry_lo
  fn_lvl=0
  pfb=y # "print function boundaries"
  :
  : "${C2}Function boundary aliases${C0}"
  ## Note, as I recall, these variable assignments all need to be on the first line of this array 
  #+  definition, so that they can all be on the first line of each function definition.
  #alias __function_boundary_in__=': "${C14}" L:${LINENO}, execute alias __function_boundary_in__; __xtr_read_and_on__; : "${C11}"; _="${fn_bndry_lo} ${FUNCNAME[0]}() BEGINS ${fn_bndry_sh} ${fn_lvl} to $(( ++fn_lvl ))" local_hyphn="$-" local_exit_code="${EC:-$?}" local_lineno="${LN:-"${nL:-"${1}"}"}"; __xtr_restore__; : "${C14}" L:${LINENO}, complete alias __function_boundary_in__ "${C0}"'
  #alias __function_boundary_out_0__='
    #: "${C6}" L:${LINENO}, execute alias __function_boundary_out_0__
    #__xtr_read_and_on__
    #: "${C11}"
    #_="${fn_bndry_lo} ${FUNCNAME[0]}()  ENDS  ${fn_bndry_sh} ${fn_lvl} to $(( --fn_lvl ))"
    #__xtr_restore__
    #: "${C6}" L:${LINENO}, complete alias __function_boundary_out_0__ "${C0}"'
  #alias __function_boundary_out_1__='
    #: "${C6}" L:${LINENO}, execute alias __function_boundary_out_1__
    #__xtr_read_and_on__
    #: "${C11}"
    #_="${fn_bndry_lo} ${FUNCNAME[1]}()  ENDS  ${fn_bndry_sh} ${fn_lvl} to $(( --fn_lvl ))"
    #__xtr_restore__
    #: "${C6}" cL:${LINENO}, omplete alias __function_boundary_out_1__ "${C0}"'
  

  ## Note, s/b all one line
  alias __function_boundary_in__='
    : "${C14}" L:${LINENO}, execute alias __function_boundary_in__; 
    [[ $pfb == y ]] &&
      builtin set -x && 
      : "${C11}"
      _="${fn_bndry_lo} ${FUNCNAME[0]}() BEGINS ${fn_bndry_sh} ${fn_lvl} to $(( ++fn_lvl ))" local_hyphn="$-" local_exit_code="${EC:-$?}" local_lineno="${LN:-"${nL:-"${1}"}"}"; 
    : "${C14}"
    builtin set -
    : "${C14}" L:${LINENO}, complete alias __function_boundary_in__ "${C0}"'

  ## Note, s/b multi-lined
  alias __function_boundary_out_0__='
    : "${C6}" L:${LINENO}, execute alias __function_boundary_out_0__
    [[ $pfb == y ]] &&
      builtin set -x &&
      : "${C11}"
      _="${fn_bndry_lo} ${FUNCNAME[0]}()  ENDS  ${fn_bndry_sh} ${fn_lvl} to $(( --fn_lvl ))"
    : "${C6}"
    builtin set -
    : "${C6}" L:${LINENO}, complete alias __function_boundary_out_0__ "${C0}"'

  ## Note, s/b multi-lined
  alias __function_boundary_out_1__='
    : "${C6}" L:${LINENO}, execute alias __function_boundary_out_1__ "${C11}"
    [[ $pfb == y ]] &&
      builtin set -x && 
      _="${fn_bndry_lo} ${FUNCNAME[1]}()  ENDS  ${fn_bndry_sh} ${fn_lvl} to $(( --fn_lvl ))"
    builtin set -
    : "${C6}" cL:${LINENO}, omplete alias __function_boundary_out_1__ "${C0}"'
  
    
  :
  : "${C2}User info${C0}"
  user_real_name="Wiley Young"
  user_github_email_address="84648683+wileyhy@users.noreply.github.com"
  user_github_gpg_key="E287D0CF528591CE"
  readonly user_real_name user_github_email_address user_github_gpg_key
  :
  : "${C2}Required RPM\s${C0}"
    list_of_minimum_reqd_rpms+=( [0]="ShellCheck"
                                 [1]="firewall-config"
                                 [2]="geany"
                                 [3]="gh"
                                 [4]="git"
                                 [5]="vim-enhanced" )
  readonly list_of_minimum_reqd_rpms
  :
  : "${C12}Required files lists${C0}"
  ## Note, the "indexed array," $arrays_of_conf_files , is a meta-array containing a list of names of more
  #+  "indexed arrays." The array names, $files_for_use_with_github_depth_* , each have the same format and
  #+  are numbered sequentially are created here on one line only and have values assigned to each of them
  #+  within the next ~50 lines. The list of index numbers is created just once, so the indices in the
  #+  assignment section below must match the indices created here.
    arrays_of_conf_files+=( [0]="files_for_use_with_github_depth_0"
                            [1]="files_for_use_with_github_depth_1"
                            [2]="files_for_use_with_github_depth_2"
                            [3]="files_for_use_with_github_depth_3" )
  readonly arrays_of_conf_files 

  : 'Unset each value of the array'
  unset "${arrays_of_conf_files[@]}"
  :
  ## Note, this is really a lot of manually entered data ...of filenames -- it\s a lot to maintain. :-\
  #+  Wouldn\t it be better to just always keep the data directory... in proper intended order...?
  #+  But then the data dir can be changed and there wouldn\t be any process of making sure the DACs
  #+  are correct. On the other hand, it\s easier to maintain a simple set of files. ...but their state
  #+  wouldn\t necessarily have been documented, which is valuable in and of itself. Otherwise, if they
  #+  were changed accidentally, how would you know any change had occurred?
  ## TODO
  #: "  Files, firefox"
  #files_for_use_with_github_depth_0+=( ~/.mozilla )

  : "${C2}  Files, gh (cli)${C0}"
  files_for_use_with_github_depth_2+=( ~/.config/gh/{config.yml,gpg-agent.conf,hosts.yml,pubring.kbx,trustdb.gpg} )
  files_for_use_with_github_depth_3+=( ~/.config/gh/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev )
  files_for_use_with_github_depth_3+=( ~/.config/gh/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )
  : "${C2}  Files, gpg${C0}"
  files_for_use_with_github_depth_1+=( ~/.gnupg/{gpg-agent.conf,pubring.kbx,tofu.db,trustdb.gpg} )
  files_for_use_with_github_depth_2+=( ~/.gnupg/crls.d/DIR.txt )
  files_for_use_with_github_depth_2+=( ~/.gnupg/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev )
  files_for_use_with_github_depth_2+=( ~/.gnupg/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )
  : "${C2}  Files, ssh${C0}"
  files_for_use_with_github_depth_1+=( ~/.ssh/{id_ed25519{,.pub},known_hosts} )
  : "${C2}  Files, top${C0}"
  files_for_use_with_github_depth_2+=( ~/.config/procps/toprc )
  : "${C2}  Files, vim${C0}"
  files_for_use_with_github_depth_0+=( ~/.vimrc )
  : "${C12}  End of Files lists${C0}"
}

:
: "${C12}Write to TTY${C0}"
printf '  %s - Executing %s \n' "${script_start_time}" "$0"
umask 077





:;: "${C12}##  CRITICAL FUNCTIONS  ##${C0}";:

: "${C2}Define alias __xtr_read_and_on__${C0}"
#alias __xtr_read_and_on__='printf "%b" "${C14}"
alias __xtr_read_and_on__='
  : "${C3}" L:${LINENO}, execute alias __xtr_read_and_on__

  if [[ $- == *x* ]]
  then
    xtr_state=on
  else
    xtr_state=off
  fi
  export xtr_state

  builtin set -x

  : "${C3}" L:${LINENO}, complete alias __xtr_read_and_on__ "${C0}"'




: "${C2}Define alias __xtr_restore__${C0}"
#alias __xtr_restore__='printf "%b" "${C14}"
alias __xtr_restore__='
  : "${C3}" L:${LINENO}, execute alias __xtr_restore__
  builtin set +x

  if [[ -z ${xtr_state} ]]
  then
    __die__ Some state must have been established
  elif [[ ${xtr_state} == on ]]
  then
    builtin set -x
  elif ! [[ ${xtr_state} == off ]]
  then
    __die__
  fi

  : "${C3}" L:${LINENO}, complete alias __xtr_restore__ "${C0}"'




#: "${C2}Define trap_return()${C0}"
#function trap_return(){                          __function_boundary_in__
  #local -
  #builtin set -x # []
    #echo "fn_bndry_lo: ${fn_bndry_lo}"
    #echo "FUNCNAME[0]: ${FUNCNAME[0]}"
    #echo "FUNCNAME[1]: ${FUNCNAME[1]}"
    #echo "fn_bndry_sh: ${fn_bndry_sh}"
    #echo "fn_lvl: ${fn_lvl}"
    #exit "${LINENO}"
                                                 #__function_boundary_out_0__
                                                 #__function_boundary_out_1__
#}
#: "${C2}Define trap on RETURN${C0}"
#trap trap_return RETURN




: "${C2}Define set()${C0}"
function set(){                                  __function_boundary_in__
  ## The global variable $fn_lvl is pulled in from the global scope and is set to effect the global
  #+  scope as well
  #: "$__"
  local -Ig fn_lvl

  : "${C4}" $'This \x60set\x60 effects global scope' "${C0}"
  builtin set "$@"

  : "${C4}" $'This \x60set\x60 effects local scope' "${C0}"
  local -
  builtin set -x

  local local_hyphn
    local_hyphn="${local_hyphn:-"${-}"}"
  local -aIg qui__ ver__
    qui__=("${qui__[@]}")
    ver__=("${ver__[@]}")

    #declare -p global_hyphn local_hyphn qui__ ver__

  if [[ -o xtrace ]]
  then
    qui__=( [0]="--" )
    ver__=( [0]="--verbose" [1]="--" )
  else
    qui__=( [0]="--quiet" [1]="--" )
    ver__=( [0]="--" )
  fi
  export qui__ ver__
                                                 __function_boundary_out_0__
}




## Buggy?
#: "${C2}Define xtr_duck()${C0}"
#function xtr_duck(){                              __function_boundary_in__
  #local -
  #builtin set -x
  ### Turns xtrace off after recording previous state
  #[[ -o xtrace ]] &&
    #xon=yes &&
    #builtin set +x &&
                                                  #__function_boundary_out_0__ &&
    #return
  ### Turns xtrace on after recording previous state
  #[[ ${xon:=} = yes ]] &&
    #builtin set -x &&
                                                  #__function_boundary_out_0__ &&
    #return
#}

:;: "${C12}##  CRITICAL FUNCTIONS COMPLETE  ##${C0}";:





:;: "${C12}##  REGULAR FUNCTIONS  ##${C0}";:

: "${C12}Functions and Aliases TOC...${C0}"
  ##  Function name                   ??? < What do these 'y's mean?
  #+  ############################    ###
  #+ functions_this_script=(
  #+  "__vte_osc7()"
  #+  "__vte_prompt_command()"
  #+  "clone_repo()"
  #+  '__die__'
  #+  "enable_git_deburg_settings()"
  #+  "error_and_exit()"
  #+  "get_pids_for_restarting()"
  #+  "gh_auth_login_command()"
  #+  "increase_disk_space()"
  #+  "min_necc_packages()"
  #+  "must_be_root()"
  #+  "pause_to_check()"
  #+  "reqd_user_files()"             # y
  #+  "rsync_install_if_missing()"
  #+  "setup_bashrc()"                # y
  #+  "setup_dnf()"
  #+  "setup_gh_cli()"                # y
  #+  "setup_git()"                   # y
  #+  "setup_gpg()"                   # y
  #+  "setup_network()"
  #+  "setup_ssh()"                   # y
  #+  "setup_temp_dirs()"             # y
  #+  "setup_time()"
  #+  "setup_git_user_dirs()"         # y
  #+  "setup_vars()"
  #+  "setup_vim()"                   # y
  #+  "test_dns()"
  #+  "test_os()"
  #+  "trap_err()"
  #+  "trap_exit()"
  #+  "trap_return()"
  #+  "write_bashrc_strings()"        # y
  #+  "write_ssh_conf()"              # y
  #+)




#: "Define __vte_osc7() -- for bashrc only"
# shellcheck disable=SC2317
#function __vte_osc7(){                          __function_boundary_in__
  #local - cmd urlencode_o
  #builtin set - # []
  #cmd=$( PATH="${PATH}:/usr/libexec:/usr/lib:/usr/lib64" command -v vte-urlencode-cwd )
  #[[ -n ${cmd} ]] || return
  #urlencode_o=$( "${cmd}" )
  #printf 'file://%s%s\n' "${HOSTNAME}" "${urlencode_o:-"${PWD}"}"
  #printf '\033]7;file://%s%s\033' "${HOSTNAME}" "${urlencode_o:-"${PWD}"}"
#}




#: "Define __vte_prompt_command() -- for bashrc only"
# shellcheck disable=SC2317
#function __vte_prompt_command(){                __function_boundary_in__
    #local - fn_pwd
    #builtin set - # []
    #fn_pwd=~
    #if ! [[ ${PWD} = ~ ]]; then
        #fn_pwd="${fn_pwd//[[:cntrl:]]}"
        #fn_pwd="${PWD/#"${HOME}"\//\~\/}"
    #fi
    #printf '\033[m\033]7;%s@%s:%s\033' "${USER}" "${HOSTNAME%%.*}" "${fn_pwd}"
    #printf '%s@%s:%s\n' "${USER}" "${HOSTNAME%%.*}" "${fn_pwd}"
    #__vte_osc7
#}




: "${C2}Define clone_repo()${C0}"
function clone_repo(){                           __function_boundary_in__
  local -
  builtin set -x # []

  [[ ${PWD} = "${dev_d1}" ]] || 
    __die__

  local AA
    AA=$( 
      sha256sum "${dev_d1}/${scr_repo_nm}/README.md" | 
        cut --delimiter=" " --fields=1 
    )
  
  if  ! [[ -d ./${scr_repo_nm} ]] || 
      ! [[ -f ./${scr_repo_nm}/README.md ]] ||
      ! [[ ${AA} == "${sha256_of_repo_readme}" ]]
  then
    git clone --origin github "https://github.com/wileyhy/${scr_repo_nm}" || 
      __die__
  fi
  unset AA
                                                 __function_boundary_out_0__
}




## Bug, separate alias definitions to a subsection above function definitions. Defining of alias B can
#+ occur before the defining of function A which is contained within in (alias B).

: "${C2}Define \"__die__\" alias to function error_and_exit()${C0}"
alias __die__='
  : "${C14}" L:${LINENO}, execute alias __die__
  error_and_exit "${nL}"
  : "${C14}" L:${LINENO}, complete alias __die__ "${C0}"'
:




: "${C2}Define enable_git_deburg_settings()${C0}"
function enable_git_deburg_settings(){           __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}Variables -- Global git deburg settings${C0}"
  # shellcheck disable=SC2034
  {
    GIT_TRACE=true
    GIT_CURL_VERBOSE=true
    GIT_SSH_COMMAND="ssh -vvv"
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
                                                 __function_boundary_out_0__
}




: "${C2}Define error_and_exit()${C0}"
function error_and_exit(){                       __function_boundary_in__
  local -
  builtin set -x # []

    #declare -p local_hyphn
    #declare -p local_lineno
    #declare -p local_exit_code

  ## Some positional parameters must exist
  [[ $# -lt 1 ]] && return 1

  ## The first positional parameter must be a digit, and should be the LINENO from where error_and_exit() is called
  if ! [[ $1 = [0-9]* ]]
  then
    printf '\n%b%s, %s, Error, first positional parameter must be a line number %b\n\n' "${C1}" "${scr_nm}" "${funcname}" "${C0}"
    return 2
  fi

  local local_lineno
  local_lineno="$1"
  shift

  printf '%b%s, Error, line %d, %s%b\n' "${C1}" "${scr_nm}" "${local_lineno}" "$*" "${C0}" >&2

  [[ ${local_exit_code} = 0 ]] && 
    local_exit_code="01"

    ## <>
    EC="${local_exit_code}" 
    LN="${local_lineno}" 
    builtin exit
                                                 __function_boundary_out_0__
}




## TODO: add a "get_distro()" function

: "${C2}Define get_pids_for_restarting()${C0}"
function get_pids_for_restarting(){              __function_boundary_in__
  local -
  builtin set -x # []

  # shellcheck disable=SC2034
  local dnf_o
  local pipline0 pipline1
  local -ga a_pids
  a_pids=()

  ## Note, this pipeline was broken out into its constituent commands in order to verify the values
  #+  mid-stream. Yes, some of the array names are in fact spelled uncorrectly.

  ## Note, this set of arrays could be a function, but `return` can only return from one function level at
  #+  at time, or it could be a loop, but the array names and command strings would have to be in an
  #+  associative array, and that seems like adding complexity.

  ## TODO, implement some improved commands:
  #+  dnf --assumeno --security upgrade 2>/dev/null | grep -e ^'Install ' -e ^'Upgrade '
  #+  dnf --assumeno --bugfix upgrade 2>/dev/null | grep -e ^'Install ' -e ^'Upgrade '
  #+  for II in 7656 11807 17897 72230; do ps_o=$( ps aux ); printf '\n%s\n' "$( grep -Ee "\<${II}\>" <<< "${ps_o}" )"; /bin/kill -s HUP "${II}"; sleep 2; done


  readarray -t dnf_o < <( 
    sudo -- nice --adjustment=-20 -- dnf needs-restarting 2> /dev/null || 
      __die__ 
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
                                                 __function_boundary_out_0__
}




: "${C2}Define gh_auth_login_command()${C0}"
function gh_auth_login_command(){                __function_boundary_in__
  local -
  # set -

  if gh auth status >/dev/null 2>&1
  then
    gh auth logout
  fi

  ## Bug, output of `gh auth login`: "! Authentication credentials saved in plain text"

  ## Note, do not break this line with any backslashed newlines or it will fail and you\ll have to
  #+  refresh auth manually; using short options for just this reason
  gh auth login -p ssh -h github.com -s admin:public_key,read:gpg_key,admin:ssh_signing_key -w || 
    __die__
                                                 __function_boundary_out_0__
}




: "${C2}Define increase_disk_space()${C0}"
function increase_disk_space(){                  __function_boundary_in__
  builtin set -x # []

  ## Note, such as...   /usr/lib/locale /usr/share/i18n/locales /usr/share/locale /usr/share/X11/locale , etc.
  ## Note, for $dirs1 , find syntax based on Mascheck\s
  ## Note, for $dirs2 , use of bit bucket because GVFS ‘/run/user/1000/doc’ cannot be read, even by root
  ## Note, for $fsos3 , "--and" is not POSIX compliant
  ## Note, for $fsos4 , sorts by unique inode and delimits by nulls

  declare -A Aa_fsos5
  readarray -d "" -t dirs1 < <( 
    find -- /  \!  -path / -prune -type d -print0 
  )

  readarray -d "" -t dirs2 < <(
    find -- "${dirs1[@]}" -type d -name "*locale*"  \!  -ipath "${mount_base__fedora}/*" -print0 2> /dev/null 
  )

  readarray -d "" -t fsos3 < <(
    find -- "${dirs2[@]}" -type f -size +$(( 2**16 ))  \(  \!  -ipath "*en_*" -a  \!  -ipath "*/.git/*"  \)  -print0 
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
        break 1 # <> set-u

      # shellcheck disable=SC2190
      Aa_fsos5+=( "${1%% *}" "${1#* }")
      shift 1

      (( $# == 0 )) && 
        break 1
    done
  fi

  : "${C2}If any larger local data files were found, then remove them interactively${C0}"
  if [[ -n ${!Aa_fsos5[*]} ]]
  then
    : "${C2}Inform user of any found FSOs${C0}"
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
            KK="$( realpath -e "${JJ}" )" 
          ## Note, "\x60" is a "grave accent"
          printf '%s, output of %bls%b, %s \n' "${scr_nm}" '\x60' '\x60' "${KK}"
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
                  printf '  %s %b %s %s \n' "Script," ' \x60rm -i\x60 ' "requires a typed [yN] response," \
                    "it defaults to do-not-delete if a user just presses [enter]."

                  if sudo -- "$( type -P rm )" --interactive --one-file-system --preserve-root=all "${ver__[@]}" "${JJ}"
                  then
                    unset "Aa_fsos5[${AA}]"
                    break 1
                  else
                    __die__ "Unknown error"
                  fi
                ;; #
            n | f )
                  printf '  Keeping this file. \n'
                  unset "Aa_fsos5[${AA}]"
                  break 1
                ;; #
            * )   HH=$(( ++HH )) # <> set-e, can be just  (( HH++ ))  when errexit\s off

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
                                                 __function_boundary_out_0__
}




: "${C2}Define min_necc_packages()${C0}"
function min_necc_packages(){                    __function_boundary_in__
  local -
  builtin set -x # []

  local XX

  ## Question? how many $a_pids arrays are there, and are they ever misused?

  #local -a a_pids

  for XX in "${list_of_minimum_reqd_rpms[@]}"
  do
    if ! rpm --query --quiet "${XX}"
    then
      sudo -- dnf --assumeyes install "${XX}"

      ## TODO, comment out this use of $a_pids, re declaring and unsetting
      #unset -v a_pids
      #local -a a_pids=()
      get_pids_for_restarting

    fi
  done
  unset XX
                                                 __function_boundary_out_0__
}




: "${C2}Define must_be_root()${C0}"
function must_be_root(){                         __function_boundary_in__
  if (( UID == 0 ))
  then
    __die__ "Must be a regular user and use sudo"
  elif sudo --validate
  then
    : validation succeeded
  else
    : validation failed
    __die__
  fi
                                                 __function_boundary_out_0__
}




: "${C2}Define pause_to_check()${C0}"
## Usage,   pause_to_check "${nL}"
function pause_to_check(){                       __function_boundary_in__
  local -
  builtin set - # []
  local -I EC=101 LN="$1" ## Q, Why inherit attributes and values when you assign values anyway?

  #shift
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

  ## TODO: copy out this construct to the rest of the functions, re bndry_cmd
  ## SAVE this block
  #local bndry_cmd
  #if [[ $hyphn =~ x ]]; then bndry_cmd="echo"; else bndry_cmd="true"; fi
  #"${bndry_cmd}"  "${fn_bndry} ${FUNCNAME[0]}()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
                                                 __function_boundary_out_0__
}
alias __pause2ck__='
  : "${C14}" L:${LINENO}, exceute alias __pause2ck__
  pause_to_check "${nL}"
  : "${C14}" L:${LINENO}, complete alias __pause2ck__ "${C0}"'




: "${C2}Define reqd_user_files()${C0}"
function reqd_user_files(){                      __function_boundary_in__
  local -
  builtin set -x # []

  ## Note, QQ must be declared as local before unsetting it inside the function so that the `unset` will
  #+  effect the local variable
  ## Note, and yet, when locally declaring and assigning separately a regular variable, ie,
  #+  `local lsblk_out \n lsblk_out=""` the assignment doesn\t need a preceding `local`
  ## Note, I\m using an array with $lsblk_out so I can work around `set -u` by using a ":=" PE, and so that
  #+  I can limit xtrace output by testing for a shortened version of the output of `lsblk`. I.e., I\m testing
  #+  the last line of the array, index "-1", but this is really just a practice, since a lot of times index
  #+  zero gets unset for whatever reason, but if there are any values in the array at all, then index
  #+  "-1" is guaranteed to exist. ...unless the array is completely empty...
  #+	but I don\t want to UNSET ie RESET the array on each loop...
  #+ In this script, index zero should exist, barring any future changes. So, it\s a bit of future-proofing.

  : $'Vars: Is device identified by \x22\x24data_pttn_uuid\x22 attached to this machine? If so, get device path'
  local pttn_device_path
  pttn_device_path=$( 
    lsblk --noheadings --output partuuid,path | 
      awk --assign awk_var_ptn="${data_pttn_uuid}" '$1 ~ awk_var_ptn { print $2 }' 
  )
  [[ -n ${pttn_device_path} ]] || 
    __die__ $'Necessary USB drive isn\x60t plugged in or its filesystem has changed.'

  : "${C2}Vars: get mountpoints and label${C0}"
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
      : "${C2}  Zero matches${C0}"
      ## Note, "plugged in and not mounted" means the LABEL would still be visible, if there is one: the USB
      #+  drive or the filesystem holding the data could change, and either change would rewrite the PARTUUID
      local pttn_label
      pttn_label=$( 
        lsblk --noheadings --output label "${pttn_device_path}" 
      )
      pttn_label="${pttn_label:=live_usb_tmplabel}"
      #mount_base__debian=""
      mount_base__fedora="/run/media/root"
      #mount_base__suse=""
      mount_pt="${mount_base__fedora}/${pttn_label}"
      data_dir="${mount_pt}/${datadir_basenm}"
      is_mounted=no
      unset pttn_label
      ;; #
    1 )
      : "${C2}  One match${C0}"
      mount_pt="${array_mt_pts[*]}"
      data_dir="${mount_pt}/${datadir_basenm}"
      is_mounted=yes
      ;; #
    * )
      : "${C2}  Multiple matches${C0}"
      __die__ "The target partition is mounted in multiple places"
      ;; #
  esac
  unset array_mt_pts

  : "${C2}FS mounting must be restricted to root and/or liveuser${C0}"
  local mount_user
  mount_user="${mount_pt%/*}" mount_user="${mount_user##*/}"
  [[ ${mount_user} = @(root|liveuser) ]] || 
    __die__
  unset mount_user

  : "${C2}USB drive must be mounted${C0}"
  if [[ ${is_mounted} = "no" ]]
  then
    if ! [[ -d "${mount_pt}" ]]
    then
      sudo -- mkdir --parents -- "${mount_pt}" || 
        __die__
    fi

    sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || 
      __die__
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

  : "${C2}Directories from mount-username directory to mount point must be readable via ACL, but not writeable${C0}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${mount_pt%/*}"
  sudo -- setfacl --remove-all --remove-default -- "${mount_pt}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${mount_pt}"

  : "${C2}Data directory must already exist${C0}"
  if  ! [[ -d ${data_dir} ]] || 
      [[ -L ${data_dir} ]]
  then 
    __die__
  fi

  : "${C2}Data directory must be readable via ACL, but not writeable${C0}"
  sudo -- setfacl --remove-all --remove-default --recursive --physical -- "${data_dir}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${data_dir}"
  sudo -- find "${data_dir}" -type d -execdir setfacl --modify="u:${LOGNAME}:rx" --recursive --physical '{}' \; #
  sudo -- find "${data_dir}" -type f -execdir setfacl --modify="u:${LOGNAME}:r" '{}' \; #

  : "${C2}Data directory verification info must be correct${C0}"
  local ZZ
  ZZ=$( 
    sudo -- sha256sum -b "${data_dir}/${datdir_idfile}" | 
      grep -o "${data_dir_id_sha256}" 
  )

  if  ! [[ -f "${data_dir}/${datdir_idfile}" ]] || 
      [[ -L "${data_dir}/${datdir_idfile}" ]]
  then 
    __die__
  fi
  
  if ! [[ ${ZZ} = "${data_dir_id_sha256}" ]]
  then 
    __die__
  fi
  unset ZZ

  : "${C2}Capture previous umask and set a new one${C0}"
  local prev_umask
  read -r -a prev_umask < <( 
    umask -p 
  )
  umask 177

  : "${C2}For each array of conf files and/or directories${C0}"
  local AA
  local -n QQ
  ## Note, It isn\t strictly necessary to declare QQ as a nameref here, since unsetting QQ (see below) removes
  #+  the nameref attribute, but I intend to use QQ as a nameref, so declaring QQ without a nameref attribute
  #+  would be confusing

  for AA in "${arrays_of_conf_files[@]}"
  do
    #: 'Loop A - open \\\ ' ;:

    : "${C2}Vars${C0}"
    ## Note, if I declare a local nameref, `local -n foo`, then on the next line just assign to the nameref
    #+  directly, `foo=bar`, then on the second loop `local -p QQ` prints the former value of QQ. Perhaps
    #+  the second assignment statement, ie, `foo=bar` without `local -n` is global?
    ## Note, remember, namerefs can only be unset with the -n flag to the `unset` builtin
    #unset -n QQ
    local -n QQ
    local -n QQ="${AA}"   ## good code
    #QQ="${AA}"           ## baaad code

    : "${C2}For each conf file or dir${C0}"
    local BB

    : "${C2}If the target conf file/dir does not exist${C0}"
    for BB in "${!QQ[@]}"
    do
      #: '    Loop A:1 - open \\\ '
      if ! [[ -e ${QQ[BB]} ]]
      then

        : "${C2}Vars${C0}"
        local source_file
        source_file="${data_dir}/${QQ[BB]#~/}"

        : "${C2}If the source conf file/dir does not exist, then find it${C0}"
        if ! [[ -e ${source_file} ]]
        then

          : "${C2}If the partition is not mounted which holds the data directory, then mount it${C0}"
          if [[ ${is_mounted} = no ]]
          then

            ## Duplicated above
            #: "Mountpoint must exist"
            #if ! [[ -d ${mount_pt} ]]
            #then
            #  sudo -- mkdir --parents -- "${mount_pt}" || 
            #     __die__
            #fi

            sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || 
              __die__

            if  mount | 
                  grep -q "${pttn_device_path}"
            then
              is_mounted=yes
            fi
          fi

          : "${C2}If the source conf file/dir still does not exist, then throw an error${C0}"
          if ! [[ -e "${source_file}" ]]
          then
            __die__ "${QQ[BB]}" "${source_file}"
          fi
        fi

        local dest_dir
        dest_dir="${QQ[BB]%/*}"
        rsync_install_if_missing  "${source_file}" "${dest_dir}"
        unset source_file dest_dir
      fi
      #: "    Loop A:1 - shut /// "
    done
    #: "Loops A:1 - complete === " ;:

    unset BB
    unset -n QQ
    #: "Loop A - shut /// " ;:
  done

  unset AA
  unset mount_pt data_dir is_mounted
  unset pttn_device_path
  #: "Loops A - complete === " ;:

  : "${C2}Restore previous umask${C0}"
  builtin "${prev_umask[@]}"
  unset prev_umask

    # <>
    EC=101 
    LN="${nL}" exit 
                                                 __function_boundary_out_0__
}




: "${C2}Define rsync_install_if_missing()${C0}"
function rsync_install_if_missing(){             __function_boundary_in__
  local -
  builtin set -x # []

    # <>
    if [[ -z $(declare -p data_dir) ]]
    then 
      echo FOOL
      exit "${LINENO}"
    fi 

  local fn_target_dir fn_source_var
  fn_source_var="$1"
  fn_target_dir="$2"

  if [[ -e ${fn_target_dir} ]]
  then
    if ! [[ -d ${fn_target_dir} ]]
    then
      __die__ "${fn_target_dir}"
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

  ## Bug, variable $data_dir is defined in a different function, reqd_user_files().
  #+ See <> test above, ~line 812

  if [[ -z "${data_dir}" ]]
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
    rsync --archive --checksum -- "${fn_source_var}" "${fn_target_dir}" || 
      __die__ "${fn_target_dir}"
  fi

  : "${C2}Unset a local variable defined and assigned in only this function, and not any variables by the same name...${C0}"
  #+  from any other scope
  [[ ${unset_local_var_rand5791:=} = "yes" ]] && 
    unset unset_local_var_rand5791 data_dir

  unset fn_source_var fn_target_dir
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_bashrc()${C0}"
function setup_bashrc(){                         __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}  bashrc -- Do some backups${C0}"
  files_for_use_with_bash=( /root/.bashrc ~/.bashrc )

  for WW in "${files_for_use_with_bash[@]}"
  do
    hash -r

    : "${C2}  bashrc -- RC File must exist${C0}"
    if ! sudo -- "$(type -P test)" -f "${WW}"
    then
      __die__ "${WW}"
    fi

    ## Note, chmod changes the ctime, even with no change of DAC\s

    : "${C2}  bashrc -- ...of the array files_for_use_with_bash${C0}"
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

    : "${C2}  bashrc -- ...per-script-execution file backup${C0}"
    sudo -- rsync --archive --checksum "${ver__[@]}" "${WW}" "${WW}~" || 
      __die__ "${WW}"
  done
  unset WW

  : "${C2}  bashrc -- Env parameters for bashrc${C0}"

  : "${C2}  bashrc -- PS0 -- Assign color code and duck xtrace${C0}"
  ## Note,  set [-|-x] , letting xtrace expand this  tput  command alters all xtrace colorization
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

  : "${C2}  bashrc -- PROMPT_COMMAND -- Variables dependency -- level 1 --${C0}"
  pc_regx="not found"$
  # shellcheck disable=SC2034
  prompt_colors_reset=$( 
    tput sgr0 
  )

  ## TODO, append some additional definitions into bashrc
  #+    man(){ "$( type -P man )" --nh --nj "$@"; }
  #+    export TMOUT=15

  : "${C2}  bashrc -- PROMPT_COMMAND -- Variables dependency -- level 2 --${C0}"
  # shellcheck disable=SC2016
  prompt_cmd_0='printf "%b" "${prompt_colors_reset}"'

  : "${C2}  bashrc -- PROMPT_COMMAND -- Variables dependency -- level 3 --${C0}"
  ## Note, PROMPT_COMMAND could have been inherited as a string variable
  unset PROMPT_COMMAND
  declare -a PROMPT_COMMAND
  PROMPT_COMMAND=( [0]="${prompt_cmd_0}" )

  if ! [[ "$( declare -pF __vte_prompt_command 2>&1 )" =~ ${pc_regx} ]]
  then
    PROMPT_COMMAND+=( __vte_prompt_command )
  fi

  : "${C2}  bashrc -- Other parameters${C0}"
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

  : "${C2}  bashrc -- Append user variables and functions into .bashrc${C0}"
  ## Note, these arrays include some command substitutions which depend on some function definitions, which in
  #+  turn must be defined prior to defining these arrays

  : "${C2}  bashrc -- Define lists of parameters to be appended into bashrc${C0}"
  ## Note, there are multiple lists for variables due to layers of dependencies. Later in this procedure,
  #+  each of these groups is relayed using associative arrays, which do not reliably maintain their internal
  #+  ordering, so, some consistent ordering must be imposed here.
  declare -a vars_for_bashrc_1=([0]="BROWSER" [1]="EDITOR" [2]="PS0" [3]="prompt_colors_reset")
  declare -a vars_for_bashrc_2=([0]="prompt_cmd_0")
  declare -a vars_for_bashrc_3=([0]="PROMPT_COMMAND")
  declare -a fcns_for_bashrc_1=() #rm ) #__vte_osc7 __vte_prompt_command

    # indices=()
    #
    # list_{ index }=( group )
    #
    # identify [ var or fn ] by parsing shell builtins

    ## TODO, write lists of how the data is to be written in bashrc, and of how the data exists originally,
    #+  then with those endpoints, chart how to transform the strings from a simple list to output in bashrc

  : "${C2}  bashrc -- Variables${C0}"
  missing_vars_and_fns=()

  : "${C2}Note, test for whether the reqd variables are defined in the script#s current execution environment${C0}"
  for QQ in "${vars_for_bashrc_1[@]}" "${vars_for_bashrc_2[@]}" "${vars_for_bashrc_3[@]}"
  do
    if [[ $( declare -p "${QQ}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${QQ}" )
    fi
  done
  unset QQ

  : "${C2}  bashrc -- Functions${C0}"
  for UU in "${fcns_for_bashrc_1[@]}"
  do
    if [[ $( declare -pF "${UU}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${UU}" )
    fi
  done
  unset UU

  : "${C2}  bashrc -- Test for any missing parameters${C0}"
  if (( ${#missing_vars_and_fns[@]} > 0 ))
  then
    __die__ "${missing_vars_and_fns[@]}"
  fi

  : "${C2}  bashrc -- Create Associative arrays of required parameters${C0}"

  : "${C2}  bashrc -- Define Aa_bashrc_strngs_*${C0}"
  ## Note, you want for these array elements to represent just one parameter or function each.  ...what does this mean?
  local -a bashrc_Assoc_arrays
  local -a bashrc_Assoc_arrays=( Aa_bashrc_strngs_F1   Aa_bashrc_strngs_V1   Aa_bashrc_strngs_V2   Aa_bashrc_strngs_V3 )
  local -A "${bashrc_Assoc_arrays[@]}"

  # for AA in bashrc_Assoc_arrays
  #
  #     bashrc_Assoc_arrays === Aa_bashrc_strngs_F1   Aa_bashrc_strngs_V1 ...
  #
  #   if AA = *_V{ number } # ie, is for variables
  #
  #       AA === Aa_bashrc_strngs_V1
  #
  #     for BB in !vars_for_bashrc_{ number }
  #
  #         vars_for_bashrc_{ number __1__ }[BB] === vars_for_bashrc_1
  #
  #       for XX in  vars_for_bashrc_{ number __1__ }[BB]
  #
  #       local -A Aa_bashrc_strngs_V{ number }[$AA] = [def parm BB]=$( declare -p BB)
  #

  : "${C2}  bashrc -- Variables${C0}"
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

  : "${C2}  bashrc -- Functions (a.k.a. \"subroutines\")${C0}"
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

  : "${C2}  bashrc -- Write functions and variable definitions into bashrc files${C0}"
  local KK
  for KK in "${!bashrc_Assoc_arrays[@]}"
  do
    write_bashrc_strings "${bashrc_Assoc_arrays[${KK}]}"
  done
  unset KK

  : "${C2}  bashrc -- Clean up${C0}"
  unset pc_regx prompt_cmd_0
  unset files_for_use_with_bash
  unset -f write_bashrc_strings
  unset "${bashrc_Assoc_arrays[@]}"
  unset bashrc_Assoc_arrays
                                                 __function_boundary_out_0__
}




## Bug, setup_dnf is too long and too complicated

: "${C2}Define setup_dnf()${C0}"
function setup_dnf(){                           __function_boundary_in__
  local -
  builtin set -x # []

  ## Bug, there should be a n\eeds-restarting loop between each install/upgrade
  ## Bug, the --security upgrade should be done rpm by rpm

    : "${C2}Beginning section on DNF${C0}"

  ## Note, CUPS cannot be safely removed; too many dependencies
  ## Note, For some unknown reason, even when  dnf  doesn\t change any programs,  dnf
  #+  needs-restarting  decides it needs to restart all available Firefox processes, which crashes all of
  #+  my tabs.  (Burg?)  So, I\m adding in a few  rpm -qa | wc -l s to only run  dnf
  #+  needs-restarting  in the event that any files on disk may actually have been changed.
  ## Note, these PE\s (for_admin, for_bash, etc.) have been tested and should "disappear" by virtue of
  #+  whichever expansion does that, leaving just the regular strings as the elements of the array
  ## Note, this brace grouping (all together of for_admin, for_bash, etc.) is so that "shellcheck disable" will
  #+  apply to the entire block

  hash_of_installed_pkgs_A=$( 
    rpm --all --query | 
      sha256sum | 
      cut --delimiter=' ' --fields=1 
  )

  : "${C2}Define filename for record of previous hash..B${C0}"
  local hash_f hash_of_installed_pkgs_B_prev
  hash_f=/tmp/setup_dnf__hash_of_installed_pkgs_B_prev
  hash_of_installed_pkgs_B_prev=""

  : "${C2}If the record already exists...${C0}"
  if [[ -f ${hash_f} ]]
  then

    : "${C2}...then read it in${C0}"
    read -r hash_of_installed_pkgs_B_prev < "${hash_f}"

    : "${C2}If the old hash...B matches the new hash...A, then return from this function${C0}"
    if [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B_prev}" ]]
    then
      return
    fi
  fi

  : "${C2}Removals for disk space${C0}"
  pkg_nms_for_removal=( google-noto-sans-cjk-vf-fonts mint-x-icons mint-y-icons transmission )

  : "${C2}Removals for security${C0}"
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
    # addl_pkgs+=( ${for_burg_rpts:=}     inxi zsh dash mksh )
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

  : "${C2}Start with removing any unnecessary RPMs${C0}"

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

    : "${C2}Keep a list, just in case an rpm removal accidentally erases something vital${C0}"
    if [[ -n ${removable_pkgs[*]:0:8} ]]
    then
      for QQ in "${!removable_pkgs[@]}"
      do
        ## Note,  dnf , do not use [-y|--yes] with this particular command
        if sudo -- nice --adjustment=-20 -- dnf --allowerasing remove -- "${removable_pkgs[QQ]}"
        then
          unset "removable_pkgs[QQ]"
        else
          __die__ "${removable_pkgs[QQ]}"
        fi
      done
      unset QQ
    fi
  fi

  : "${C2}Then do a blanket security upgrade${C0}"

  ## Note, the problem with this "blanket security upgrade" is how it includes kernel and firmware. Better to
  #+  capture list of rpms in a no-op cmd, filter out impractical (for a LiveUsb) rpms, then upgrade the rest
  #+  one by one

  : $'Run this loop until \x60dnf --security upgrade\x60 returns 0, or 0 upgradable, rpms'
  while true
  do

    : "${C2}Get full list of rpms to upgrade, in an array; exit on non-zero${C0}"
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

    : "${C2}If count of upgradeable rpms is 0, then break loop${C0}"
    if [[ ${#pkgs_for_upgrade[@]} -eq 0 ]]
    then
      break
    fi

    : "${C2}Upgrade the RPM\s one at a time${C0}"
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
    get_pids_for_restarting

      declare -p a_pids
      #exit 101

    : $'Send signals to "needs-restarting" PID\x27s, one at a time...'
    #+  with pauses and descriptions between each one, so I can see which signal/process combinations cause
    #+  any problems. This would be a great job for logging.

  done

  pause_to_check "${nL}" $'Which packages in the \x24addl_pkgs array are already installed?' # <>

  : "${C2}Find out whether an RPM is installed, one by one${C0}"
  for UU in "${!addl_pkgs[@]}"
  do
    if rpm --query --quiet -- "${addl_pkgs[UU]}"
    then
      pkgs_installed+=( "${addl_pkgs[UU]}" )
      unset "addl_pkgs[UU]"
    fi
  done
  unset UU

    pause_to_check "${nL}" $'Upgrade any pre-intstalled packages from the \x24addl_pkgs array' # <>

  ## Bug, this section should upgrade rpms one by one

  : "${C2}Upgrade any installed RPMs from the main list, en masse${C0}"
  if [[ -n ${pkgs_installed[*]: -1:1} ]]
  then
    sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet upgrade -- "${pkgs_installed[@]}" || 
      __die__
  fi

    pause_to_check "${nL}" $'From the \x24addl_pkgs array, install the remainder' # <>

  : "${C2}Install any as yet uninstalled RPMs from the main list as necessary${C0}"
  not_yet_installed_pkgs=( "${addl_pkgs[@]}" )

  if [[ -n ${not_yet_installed_pkgs[*]: -1:1} ]]
  then
    ## Note, if you install multiple rpms at the same time, and one of them causes some error, then you have
    #+  no immediate way of knowing which one caused the error

    for VV in "${not_yet_installed_pkgs[@]}"
    do
      sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet install -- "${VV}" || 
        __die__

      #a_pids=()
      get_pids_for_restarting

      ## BUG, killing NetworkManager or firewalld stops the systemd service process, and neither restart
      #+  automatically

      ## Question, how is it possible to know from `ps aux` output whether a process was started by a
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

            #pause_to_check "${nL}" "Execute a lengthy \x60kill --timeout...\x60 command?" # <>


          : "${C2}Ensure a process is still running before trying to kill it${C0}"

          ## Note, some strings from /proc/[pid]/cmdline include "[]" brackets; `pgrep -f` parses these as
          #+  ERE's and cannot parse fixed strings, so a Parameter Expansion is necessary in order to render
          #+  any opening bracket "[" as non-special for ERE syntax.
          ## Note, subprocesses, killing a daemon, for example, avahi, might also kill some other processes
          #+  which were avahi's child processes, so when the for loop, looping through PID\s to be restarted,
          #+  gets to those child processes, then those child processes are no longer active, and
          #+  "/proc/${a_pids[WW]}/cmdline" would not exist.
          sleep 1

          : "${C2}Most existing processes have some commandline information available${C0}"
          :
          : "${C2}If the /proc/PID/cmdline FSO exists and is a file, then...${C0}"
          if [[ -f /proc/${a_pids[WW]}/cmdline ]]
          then
            ## Note, these files are in _PROC_! Of course they have a zero filesize!!

            ## Bug, the bash(ism) `[[` keyword cannot accept a leading or internal "2>/dev/null", though
            #+  `test` and `[` can.

            : "${C2}If the /proc/PID/cmdline FSO also has a size greater than zero...${C0}"
            if [[ -n "$( tr -d '\0' < /proc/${a_pids[WW]}/cmdline )" ]]
            then
              local -a array_of_PIDs_cmdline
              local string_of_PIDs_cmdline

              : "${C2}Load the cmdline into an array${C0}"
              readarray -d '' -t array_of_PIDs_cmdline < <( 
                cat "/proc/${a_pids[WW]}/cmdline" 
              )

              : $'Skip zombie processes, which have zero length \x22/proc/[pid]/cmdline\x22 files'
              if [[ -z ${array_of_PIDs_cmdline[*]} ]]
              then
                unset "a_pids[WW]" array_of_PIDs_cmdline
                continue
              fi

              : "${C2}If the commandline cannot be found in ps output, then move on to the next loop${C0}"
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
            "If the /proc/PID/cmdline FSO does not exist, then begin the next loop"
            unset "a_pids[WW]" string_of_PIDs_cmdline
            continue
          fi

          : "${C2}Kill a particular process${C0}"
          #sudo -- "$(type -P kill)" --timeout 1000 HUP --timeout 1000 USR1 --timeout 1000 TERM --timeout 1000 KILL "${ver__[@]}"  "${a_pids[WW]}"
          hash -r
          sudo -- "$(type -P kill)" \
            --timeout 1000 HUP \
            --timeout 1000 USR1 \
            --timeout 1000 TERM \
            --timeout 1000 KILL "${ver__[@]}"  "${a_pids[WW]}"
          sleep 3
          ps aux | 
            awk --assign "DD=${a_pids[WW]}" '$2 ~ DD { print }'

            #pause_to_check "${nL}" "Now do you need to manually restart anything?" # <>

        done
        unset WW
      fi
    done
    unset VV
  fi
  unset pkg_nms_for_removal addl_pkgs
  unset for_{admin,bash,bashdb,db_ish,burg_rpts,duh,firefox,fun,gcov,git,internet,later_{other,trace}}
  unset for_{linting,lockfile,os_dnlds,strings,term_tests,unicode}
  unset grep_args removable_pkgs rr pkgs_installed not_yet_installed_pkgs

    # <>
    EC=101 
    LN="${nL}" exit 
    
    # <>
    #pause_to_check "${nL}" "Begin section on restarting processes?" 

  : "${C2}Restart any processes that may need to be restarted. Begin by getting a list of any such PIDs${C0}"
  #a_pids=()
  get_pids_for_restarting

    # <>
    EC=101 
    LN="${nL}" exit 

  : $'Get new hash of installed packages, ie, \x24{hash..B}'
  hash_of_installed_pkgs_B=$( 
    rpm --all --query | 
      sha256sum | 
      awk '{ print $1 }' 
  )

  : $'Write \x24{hash..B} to disk'

  local hash_of_installed_pkgs_B_prev
  hash_of_installed_pkgs_B_prev="${hash_of_installed_pkgs_B}"

  : "${C2}If the target file exists${C0}"
  if [[ -f ${hash_f} ]]
  then

    : "${C2}If the target file is immutable${C0}"
    local has_immutable
    has_immutable=$( 
      lsattr -l "${hash_f}" | 
        awk '$1 ~ /i/ { printf "Yes" }' 
    )

    if [[ ${has_immutable} = "Yes" ]]
    then

      : "${C2}...then remove the immutable flag${C0}"
      sudo chattr -i "${hash_f}"
    fi

  : "${C2}if the target file does not exist${C0}"
  else

    : "${C2}then create it${C0}"
    touch "${hash_f}"
  fi

  : "${C2}Make sure the file is writeable${C0}"
  [[ -w "${hash_f}" ]] || 
    chmod u+w "${hash_f}"

  : "${C2}State: the file exists and is writeable${C0}"

  : $'Write \x24{hash..B} to disk, and make it RO and immutable'
  printf '%s\n' "${hash_of_installed_pkgs_B_prev}" | 
    tee "${hash_f}"
  chmod 400 "${ver__[@]}" "${hash_f}"
  sudo chattr +i "${hash_f}"
  unset hash_f

  ## TODO: change temp-vars (II, XX, etc) to fully named vars

  if  ! [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B}" ]] || 
      [[ ${#a_pids[@]} -gt 0 ]]
  then

    while true
    do

      ## Note,  [[ ... = , this second test,  [[ ${a_pids[*]} = 1 ]]  is correct. This means, do not use
      #+  ((...)) , and "=" is intended to that "1" on RHS is matched as in Pattern Matching, ie, as "PID 1."
      : $'if any PID\x60s were found... ...and if there are any PID\x60s other than PID 1...'
      if  [[ -n ${a_pids[*]: -1:1} ]] && 
          ! [[ ${a_pids[*]} = 1 ]]
      then
        II=0
        XX="${#a_pids[@]}"

        : "${C2}Print some info and wait for it to be read${C0}"
        ## Note, "\x60" is a grace accent used as a single quote
        printf '\n  %b for restarting, count, %d \n\n' 'PID\x60s' "${XX}"

          sleep 1 # <>

        : "${C2}for each signal and for each PID...${C0}"
        for YY in "${!a_pids[@]}"
        do
          ## Note, readability
          : $'\x60kill\x60'" loop $(( ++II )) of ${XX}" ;:

          ZZ="${a_pids[YY]}"
          (( ZZ == 1 )) && 
            continue 001
          sleep 1

            #pause_to_check "${nL}" "" # <>

          for AA in HUP USR1 TERM KILL
          do

              : "${C2}To kill PID ${ZZ} with signal ${AA}${C0}"
              #pause_to_check "${nL}" # <>

            #sleep 1
            sync --file-system

              wait -f # <>

            : "${C2}...if the PID is still running...${C0}"
            if  ps --no-headers --quick-pid "${ZZ}"
            then
              : "${C2}Evidently, I need to give the system a little time for processing${C0}"
              sleep 1

              ## Bug?? all of the `type -P` commands s/b consolidated into a set of variables ...?

              : $'...then \x60kill\x60 it with the according per-loop SIGNAL...'
              ## Note, the exit codes for  kill  only indicate whether or not the target PIDs existed, rather
              #+ than whether the  kill  operation succeeded, per  info kill .
              sudo -- "$( type -P kill )" --signal "${AA}" -- "${ZZ}"

              : "${C2}Evidently, I need to give the system a little MORE time for processing${C0}"
              sleep 1

              : "${C2}...and if the PID in question no longer exists then unset the current array index number${C0}"
              if  ps --no-headers --quick-pid "${ZZ}" | 
                    grep -qv defunct
              then
                is_pid_a_zombie=$( 
                  ps aux | 
                    awk --assign "EE=${ZZ}" '$2 ~ EE { print $8 }' 
                )

                if [[ ${is_pid_a_zombie} = Z ]]
                then
                  : "${C2}Process is a zombie; unsetting${C0}"
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
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_gh_cli()${C0}"
function setup_gh_cli(){                        __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}GH -- set config key-value pairs${C0}"
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
    ## Note, "SC2076 (warning): Remove quotes from right-hand side of =~ to match as a regex rather than literally."
    if ! [[ ${gh_config_list_out} =~ ${KK}=${github_configs[${KK}]} ]]
    then
      gh config set "${KK}" "${github_configs[${KK}]}"
    fi
  done
  unset KK
  unset gh_config_list_out github_configs

    wait -f # <>
    hash -r

  ## Bug, `gh auth status` is executed too many (ie, 3) times. Both the checkmarks and the exit code are used

    #gh auth status ## <>

  : "${C2}GH -- Login to github${C0}"
  ## Note, this command actually works as desired: neither pipefail nor the ERR trap are triggered
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
      pause_to_check "${nL}" $'Waiting till browser is open before running \x60gh auth\x60 command'
      gh_auth_login_command
    fi
  fi

  ## Bug, when `gh ssh-key list` fails, then after gh_auth_login_command() executes, `gh ssh-key list` is
  #+  not executed again, when it should be

  : "${C2}GH -- Get SSH & GPG keys${C0}"
  for QQ in ssh-key gpg-key
  do
    if ! gh "${QQ}" list > /dev/null 2>&1
    then
      gh_auth_login_command
    fi
  done
  unset QQ

  : "${C2}GH -- Use GitHub CLI as a credential helper${C0}"
  gh auth setup-git --hostname github.com
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_git()${C0}"
function setup_git(){                           __function_boundary_in__
  local -
  builtin set -x # []

  ## Note: git ui colors: normal black red green yellow blue magenta cyan white
  #+  git ui attributes: bold dim ul (underline blink reverse)
  ## Note: In vim, since "expandtab" is set in .vimrc, to make some actual tabs, press Ctrl-v-[tab]

  ## Bug? in vim, when quoting "EOF", $tmp_dir changes color, but bash still expands the redirection
  #+ destination file.

  : "${C2}Git -- parameters, dependency level 1${C0}"
  local git_conf_global_f git_ignr git_mesg
  #local git_system_conf_file
  git_conf_global_f=~/.gitconfig
  #git_system_conf_file=/etc/gitconfig
  git_ignr=~/.gitignore
  git_mesg=~/.gitmessage

  : "${C2}  Paramters with globs${C0}"
  ## Note, use of globs. The RE pattern must match all of the patterns in the array assignments
  local git_files_a git_regexp
  git_files_a=( /etc/git* /etc/.git* ~/.git* )
  git_regexp="git*"

  : "${C2}Git -- parameters, dependency level 2${C0}"
  if [[ -f ${git_conf_global_f} ]]
  then
    local git_cnf_glob_list
    readarray -t git_cnf_glob_list < <( 
      git config --global --list 
    )
  fi

  ## Note, write large array assignments this way so that they mirror xtrace output cleanly
  ## TODO, make a note of this in my style guide

  local -A git_keys
  git_keys+=( [color.diff]=always )
  git_keys+=( [color.diff.meta]="blue black bold" )
  git_keys+=( [color.interactive]=always )
  git_keys+=( [color.ui]=true )
  git_keys+=( [commit.gpgsign]=true )
  git_keys+=( [commit.template]="${git_mesg}" )
  git_keys+=( [core.editor]=vim )
  git_keys+=( [core.excludesfile]="${git_ignr}" )
  git_keys+=( [core.pager]="$( type -P less )" )
  git_keys+=( [credential.helper]="cache --timeout=3600" )
  git_keys+=( [gpg.program]="$( type -P gpg2 )" )
  git_keys+=( [help.autocorrect]=prompt )
  git_keys+=( [init.defaultBranch]=main )
  git_keys+=( [user.email]="${user_github_email_address}" )
  git_keys+=( [user.name]="${user_real_name}" )
  git_keys+=( [user.signingkey]="${user_github_gpg_key}" )

  : "${C2}Git -- Files must exist and Permissions${C0}"
  read -r -a prev_umask < <( 
    umask -p 
  )
  umask 133

  : "${C2}  Remove any unmatched glob patterns${C0}"
  local ZZ

  for ZZ in "${!git_files_a[@]}"
  do
    if [[ ${git_files_a[ZZ]} =~ ${git_regexp} ]]
    then
      unset "git_files_a[ZZ]"
    fi
  done
  unset ZZ git_regexp

  : $'Git -- Create files and set DAC\x60s as necessary - Loop B' ;:
  local AA
  for AA in "${git_files_a[@]}"
  do
    : '  Loop B - open \\\ '
    sudo -- [ -e "${AA}" ] || 
      sudo -- touch "${AA}"
    sudo -- chmod 0600 "${ver__[@]}" "${AA}"
    : "${C2}  Loop B - shut /// ${C0}"
  done
  unset AA
  : "${C2}  Loops B - complete === ${C0}"

  builtin "${prev_umask[@]}"

  : "${C2}Git -- remove a particular configuration key/value pair if present${C0}"
  if  printf '%s\n' "${git_cnf_glob_list[@]}" | 
        grep gpg.format "${qui__[@]}"
  then
    git config --global --unset gpg.format
  fi

  : "${C2}Git -- setup configuration - Loop C${C0}"
  local BB
  for BB in "${!git_keys[@]}"
  do
    : '  Loop C - open \\\ '

      : "${C2}BB:${BB}${C0}"

    if ! grep -e "${BB#*.} = ${git_keys[${BB}]}" "${qui__[@]}" "${git_conf_global_f}"
    then
      git config --global "${BB}" "${git_keys[${BB}]}"
    fi
    : "${C2}  Loop C - shut /// ${C0}"
  done
  unset BB
  : "${C2}  Loops C - complete === ${C0}"

  : "${C2}Git -- gitmessage (global)${C0}"
  if ! [[ -f ${git_mesg} ]]
  then
    : "${C2}  Heredoc: gitmessage${C0}"
    cat <<- "EOF" > "${tmp_dir}/msg"
		Subject line (try to keep under 50 characters)

		Multi-line description of commit,
		feel free to be detailed.

		[Ticket: X]

		EOF

    # shellcheck disable=SC2024 #(info): sudo does not affect redirects. Use sudo cat file | ..
    tee -- "${git_mesg}" < "${tmp_dir}/msg" > /dev/null || 
      __die__
    chmod 0644 "${ver__[@]}" "${git_mesg}" || 
      __die__
  fi

  : "${C2}Git -- gitignore (global)${C0}"
  if  ! [[ -f ${git_ignr} ]] || 
      ! grep swp "${qui__[@]}" "${git_ignr}"
  then
    : "${C2}  Heredoc: gitignore${C0}"
    cat <<- \EOF > "${tmp_dir}/ign"
		*~
		.*.swp
		.DS_Store

		EOF

    # shellcheck disable=SC2024
    tee -- "${git_ignr}" < "${tmp_dir}/ign" > /dev/null || 
      __die__
    chmod 0644 "${ver__[@]}" "${git_ignr}" || 
      __die__
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

  : "${C2}Clean up after section, Git${C0}"
  unset git_files_a git_conf_global_f git_mesg git_ignr git_keys
  #unset git_system_conf_file
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_gpg()${C0}"
function setup_gpg(){                           __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}If any files in ~/.gnupg are not owned by either USER or root, then error out and exit${C0}"
  local -a problem_files
  problem_files=()
  readarray -d "" -t problem_files < <(
      find -- ~/.gnupg -xdev \
        \( \
          \(  \!  -uid "${login_gid}" -a  \! -gid 0  \) -o \
          \(  \!  -gid "${login_uid}" -a  \! -uid 0  \) \
        \)  -print0 \
  )
  [[ -n ${problem_files[*]} ]] && 
    __die__ Incorrect ownership on -- "${problem_files[@]}"
  unset problem_files

  : $'If any files are owned by root, then change their ownership to \x24USER'
  sudo -- \
    find -- ~/.gnupg -xdev \( -uid 0 -o -gid 0 \) -execdir \
      chown "${login_uid}:${login_gid}" "${ver__[@]}" \{\} \; ||
        __die__

  : $'If any dir perms aren\x60t 700 or any file perms aren\x60t 600, then make them so'
  find -- ~/.gnupg -xdev -type d \! -perm 700  -execdir \
    chmod 700 "${ver__[@]}" \{\} \; #
  find -- ~/.gnupg -xdev -type f \! -perm 600  -execdir \
    chmod 600 "${ver__[@]}" \{\} \; #

  : "${C2}GPG -- If a gpg-agent daemon is running, or not, then, either way say so${C0}"
  if grep --extended-regexp "[g]pg-a.*daemon" "${qui__[@]}" <<< "${ps_o}"
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
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_network()${C0}"
function setup_network(){                       __function_boundary_in__
  local -
  builtin set -x # []

  dns_srv_1=8.8.8.8
  dns_srv_A=75.75.75.75
  readonly dns_srv_1 dns_srv_A

  if  ! test_dns "${dns_srv_1}" || 
      ! test_dns "${dns_srv_A}"
  then
    printf '\n%s, Attempting to connect to the internet... \n\n' "${scr_nm}"

    : "${C2}Try to get NetworkManager up and running${C0}"
    sudo -- nice --adjustment=-20 -- systemctl start -- NetworkManager.service
    wait -f

    : "${C2}Turn on networking${C0}"
    sudo -- nmcli n on

    : "${C2}Turn on WiFi${C0}"
    sudo -- nmcli r wifi on

    : "${C2}Get interface name(s)${C0}"
    readarray -d "" -t ifaces < <( 
      nmcli --terse c |
        awk --field-separator : '$1 !~ /lo/ { printf "%s\0", $1 }' 
    )

    : "${C2}Connect the interface${C0}"
    case "${#ifaces[@]}" in
      0 )
        __die__ "No network device available"
        ;; #
      1 )
        nmcli c up "${ifaces[*]}"
        sleep 5
        ;; #
      * )
        __die__ "Multiple network devices available"
        ;; #
    esac

    if  ! test_dns "${dns_srv_1}" || 
        ! test_dns "${dns_srv_A}"
    then
      printf '\n%s, Network, Giving up, exiting.\n\n' "${scr_nm}"
    else
      printf '\n%s, Network, Success!\n\n' "${scr_nm}"
    fi
  fi

  : "${C2}Clean up from Network${C0}"
  ## Note, dns_srv_A will be used at the end of the script
  unset -f test_dns
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_ssh()${C0}"
function setup_ssh(){                           __function_boundary_in__
  local -
  builtin set - ## []

  ## Bug? hardcoded filenames? ...yes, I know it#s mis-spelled.

  local ssh_usr_conf_dir ssh_user_conf_file
  ssh_usr_conf_dir=~/.ssh/
  ssh_user_conf_file=~/.ssh/config

  : "${C2}Make sure the SSH config directory and file for USER exist${C0}"
  [[ -d ${ssh_usr_conf_dir} ]] || 
    mkdir -m 0700 "${ssh_usr_conf_dir}" || 
    __die__
  [[ -f ${ssh_user_conf_file} ]] || 
    write_ssh_conf || 
    __die__

    __pause2ck__ # <>

  ## TODO, _rm_ should be an alias
  ## TODO, all aliases should be prefixed and suffixed with underscores, while functions should
  #+  include at least one underscore

  : $'Make sure the SSH config file for USER is correct, and write it if it is missing or wrong'
  if ! grep "ForwardAgent yes" "${qui__[@]}" "${ssh_user_conf_file}"
  then
    "$( type -P rm )" --force --one-file-system --preserve-root=all "${ver__[@]}" "${ssh_user_conf_file}"
    write_ssh_conf
  fi
  unset -f write_ssh_conf

  ## Bug, security, these #chown# commands should operate on the files while they are still in skel_LiveUsb
  #+  see also similar code in setup_gpg(), possibly elsewhere also  :-\

  ## Bug, timestamps, chown changes ctime on every execution, whether or not the ownership changes

  : $'Make sure the SSH config directories and files for USER have correct DAC\x60s'
  {
    sudo -- \
      find -- "${ssh_usr_conf_dir}" -xdev \
        \(  \! -uid "${login_uid}"  -o  \
            \! -gid "${login_gid}"  \
        \) -execdir \
          chown -- "${login_uid}:${login_gid}" "${ver__[@]}" \{\} \;  ||
            __die__
    find -- "${ssh_usr_conf_dir}" -xdev -type d -execdir \
      chmod 700 "${ver__[@]}" \{\} \; #
    find -- "${ssh_usr_conf_dir}" -xdev -type f -execdir \
      chmod 600 "${ver__[@]}" \{\} \; #
  }
  unset ssh_usr_conf_dir ssh_user_conf_file

  ## Bug? not necc to restart ssh-agent if both of these vars exist?

    : "${C2}${SSH_AUTH_SOCK:=}" "${SSH_AGENT_PID:=}${C0}"
    declare -p SSH_AUTH_SOCK SSH_AGENT_PID # <>

    __pause2ck__ # <>

  : "${C2}Get the PID of any running SSH Agents -- there may be more than one${C0}"
  local -a ssh_agent_pids
  readarray -t ssh_agent_pids < <( 
    ps h -C 'ssh-agent -s' -o pid | 
      tr -d ' ' 
  )

  : "${C2}Make sure ssh daemon is running (?)${C0}"
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

    : "${C2}...and try again to get the PID of the SSH Agent${C0}"
    readarray -t ssh_agent_pids < <( 
      ps h -C 'ssh-agent -s' -o pid | 
        tr -d ' ' 
    )
  fi

    __pause2ck__ # <>

  case "${#ssh_agent_pids[@]}" in
    0 )
        __die__ "ssh-agent failed to start"
      ;; #
    1 )
        if [[ -z ${SSH_AGENT_PID:-} ]]
        then
          SSH_AGENT_PID="${ssh_agent_pids[*]}"

            declare -p SSH_AGENT_PID ## <>
        fi
      ;; #
    * )
        ## TODO, _kill_ should be an alias?

        : "${C2}If more than one ssh-agent is running, then keep the first and kill the rest${C0}"
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

  ## TODO, review these commands for necessity
  ## Note, ssh-add  and  ssh  don\t have long options.

  #: "?"
  #ssh-add -v

  ## Note,  ssh-add -L  is "list;"
  #ssh-add -L -v

  ## Note,  ssh -T  is "disable pseudo-terminal allocation."
  #ssh -T git@github.com ## Note, returns exit code 1; why is this command here exectly?
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_temp_dirs()${C0}"
function setup_temp_dirs(){                     __function_boundary_in__
  local -
  builtin set -x # []

  tmp_dir=$( TMPDIR="" \
    mktemp --directory --suffix=-LiveUsb 2>&1 || 
      __die__ 
  )
  [[ -d ${tmp_dir} ]] || 
    __die__
  readonly tmp_dir
                                                 __function_boundary_out_0__
}




#: "setup_systemd()"
#function setup_systemd(){                      __function_boundary_in__
  #local -
  #builtin set -x # []
  ### Note, services to disable and mask
  ##+  ModemManager.service
  ##+ ...
  ### Note, services to disable and mask
  ##+ ...
#}




: "${C2}Define setup_time()${C0}"
function setup_time(){                          __function_boundary_in__
  local -
  builtin set -x # []

  sudo -- timedatectl set-local-rtc 0
  sudo -- timedatectl set-timezone America/Vancouver
  sudo -- systemctl start chronyd.service || 
    __die__
  sudo -- chronyc makestep > /dev/null
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_git_user_dirs()${C0}"
function setup_git_user_dirs(){                 __function_boundary_in__
  local -
  builtin set -x # []

  ## Note: in order to clone into any repo, and keep multiple repos separate,  cd  is required, or  pushd  /
  #+   popd

  : "${C2}Variables -- global, for use for entire script${C0}"
  dev_d1=~/MYPROJECTS
  dev_d2=~/OTHERSPROJECTS
  readonly dev_d1
  readonly dev_d2

  : "${C2}Make dirs${C0}"
  local UU
  for UU in "${dev_d1}" "${dev_d2}"
  do
    if ! [[ -d ${UU} ]]
    then
      mkdir --mode=0700 "${ver__[@]}" "${UU}" || 
        __die__
    fi
  done
  unset UU

  : "${C2}Change dirs${C0}"
  pushd "${dev_d1}" > /dev/null || 
    __die__
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_vars()${C0}"
function setup_vars(){                          __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}Vars, dirs, etc${C0}"
  ## Bug, only way to export namerefs?  `declare -nx nL=...`

  : "${C2}Vars... Error handling, variables and functions${C0}"
  ## Note, variable assignments, backslash escape bc  sed -i
  # shellcheck disable=SC1001
  local -gnx nL=L\INENO

  : "${C2}Vars... PATH${C0}"
  PATH="/usr/bin:/usr/sbin"
  export PATH

  : "${C2}Vars... Other environment variables${C0}"
  ## Note, Initialize some env vars found in sourced files, as a workaround for nounset
  ## Note, local style, inline comments, ie, ": foo ## Note, blah", are useful for rebutting false positives
  #+  from ShellCheck
  LC_ALL=""
  PS1=""

  ## Note, ps(1), "The real group ID identifies the group of the user who created the process" and "The
  #+  effective group ID describes the group whose file access permissions are used by the process"
  #+ See output of:  `ps ax -o euid,ruid,egid,rgid,pid,ppid,stat,cmd | awk '$1 !~ $2 || $3 !~ $4'`
  ## Note, sudo(1), "SUDO_UID: Set to the user-ID of the user who invoked sudo."
  if [[ -z ${login_uid:=} ]]
  then 
    login_uid=$( 
      id -u "$( 
        logname 
      )" 
    )
  fi
  
  if [[ -z ${login_gid:=} ]]
  then 
    login_gid=$( 
      id -g "$( 
        logname 
      )" 
    )
  fi
  #saved_SUDO_UID=$( sudo printenv SUDO_UID )
  #saved_SUDO_GID=$( sudo printenv SUDO_GID )

  ## Note, /etc/bashrc and /etc/profile.d/colorls.*sh on Fedora 38
  # shellcheck disable=SC2034
  local -g BASHRCSOURCED USER_LS_COLORS
                                                 __function_boundary_out_0__
}




: "${C2}Define setup_vim()${C0}"
function setup_vim(){                           __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}Heredoc of vim-conf-text${C0}"
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
        __die__
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
    sudo -- touch -- "${strng_vrc}" # <> set-e
  fi

  : "${C2}Write .vimrc${C0}"
  if  (( ${#arr_vrc[@]} == 0 )) || 
      ! [[ ${WW} = "${YY}" ]]
  then
    : $'Test returned \x22true,\x22 the number didn\x60t match, so write to .vimrc'

    : "${C2}Set the umask${C0}"
    read -ra umask_prior < <( 
      umask -p 
    )
    umask 177

    : "${C2}Write the root file${C0}"
    sudo -- rsync --archive --checksum -- "${tmp_dir}/vim-conf-text" "${strng_vrc}" || 
      __die__

    : "${C2}Copy the root file to ${HOME}"$' and repair DAC\x60s on '"${USER}"$'\x60s copy'
    sudo -- rsync --archive --checksum -- "${strng_vrc}" ~/.vimrc || 
      __die__
    sudo -- chown "${UID}:${UID}" -- ~/.vimrc
    chmod 0400 -- ~/.vimrc

    : "${C2}Reset the umask${C0}"
    builtin "${umask_prior[@]}"
  fi
  unset arr_vrc strng_vrc WW YY umask_prior
                                                 __function_boundary_out_0__
}




: "${C2}Define test_dns()${C0}"
function test_dns(){                            __function_boundary_in__
  local -
  builtin set -x # []

  ping -c 1 -W 15 -- "$1" > /dev/null 2>&1
  return "$?"
                                                 __function_boundary_out_0__
}




: "${C2}Define test_os()${C0}"
function test_os(){                             __function_boundary_in__
  local -
  builtin set -x # []

  local kern_rel
  kern_rel=$( 
    uname --kernel-release 
  )

  ## Note, test of $kern_rel is a test for whether the OS is Fedora (ie, "fc38" or "Fedora Core 38")
  if ! [[ ${kern_rel} =~ \.fc[0-9]{2}\. ]]
  then
    __die__ "OS is not Fedora"
  fi
  unset kern_rel
                                                 __function_boundary_out_0__
}




: "${C2}Define trap_err()${C0}"
function trap_err(){                            __function_boundary_in__
  #: "$__"
  local -
  builtin set -x # []

  declare -p BASH BASH_ALIASES BASH_ARGC BASH_ARGV BASH_ARGV0 BASH_CMDS BASH_COMMAND BASH_LINENO
  declare -p BASH_REMATCH BASH_SOURCE BASH_SUBSHELL BASHOPTS BASHPID DIRSTACK EUID FUNCNAME HISTCMD IFS
  declare -p LC_ALL LINENO PATH PIPESTATUS PPID PWD SHELL SHELLOPTS SHLVL UID
                                                 __function_boundary_out_0__
}




## Bug, these var assignments $local_exit_code and $lineno only fail when they\re on line number >=2
#+  of  trap  "args section" ??

: "${C2}Define trap_exit()${C0}"
## Note: these variable assignments must be on the 1st line of the funtion in order to capture correct data
# shellcheck disable=SC2317
function trap_exit(){                           __function_boundary_in__
  #: "$__"
  local -
  builtin set -x # []

  trap - EXIT

  : "${C2}Remove temporary directory, if one exists${C0}"
  [[ -d ${tmp_dir:=} ]] &&
    "$( type -P rm )" --force --one-file-system --preserve-root=all --recursive "${ver__[@]}" "${tmp_dir}"

  builtin exit "${local_exit_code}"
                                                 __function_boundary_out_0__
}




: "${C2}Define write_bashrc_strings()${C0}"
function write_bashrc_strings(){                __function_boundary_in__
  local -
  builtin set -x # []

  : "${C2}Certain parameters must be defined and have non-zero values${C0}"
  (( ${#files_for_use_with_bash[@]} == 0 )) && 
    __die__
  (( $# == 0 )) && 
    __die__

  local JJ file_x Aa_index Aa_element
  local -n fn_nameref

  : "${C2}For each set of strings to append into bashrc" ;:
  for JJ
  do
    : 'Loop D - open \\\ ' ;:

    unset -n fn_nameref
    local -n fn_nameref="${JJ}"

    : "${C2}For each .bashrc" ;:
    for file_x in "${files_for_use_with_bash[@]}"
    do
      : 'Loop D:1 - open \\\ ' ;:

      : "${C2}file_x, ${file_x}${C0}"

      : "${C2}For each definition (function or parameter)" ;:
      for Aa_index in "${!fn_nameref[@]}"
      do
        : 'Loop D:1:a - open \\\ ' ;:

        : "${C2}Aa_index, ${Aa_index}${C0}"
        Aa_element="${fn_nameref[${Aa_index}]}"

        : "${C2}(1) If the definition is not yet written into the file...${C0}"
        if ! sudo -- grep --quiet --fixed-strings "## ${Aa_index}" -- "${file_x}"
        then

          : "${C2}Then write the function definition into the file${C0}"
          printf '\n## %s \n%s \n' "${Aa_index}" "${Aa_element}" |
            sudo -- tee --append -- "${file_x}" > /dev/null || 
              __die__
        else
          : "${C2}Definition exists, skipping${C0}"
        fi

        ## Bug: what if it\s a multiline alias?

        ## Question, can `sed` take variable assignments the way `awk` can?

        : "${C2}(2) If there is an alias by the same name, then delete it from the bashrc file at hand...${C0}"
        sudo -- sed --in-place "/^alias ${Aa_index##* }=/d" -- "${file_x}"

        : "${C2}Loop D:1:a - shut /// " ;:
      done
      unset Aa_element
      : "${C2}Loops D:1:a - complete === " ;:

      : "${C2}For each file, if absent add a newline at EOF${C0}"
      if  sudo -- tail --lines 1 -- "${file_x}" | 
            grep --quiet --extended-regexp "[[:graph:]]"
      then
        printf '\n' | 
          sudo -- tee --append -- "${file_x}" > /dev/null
      fi

      : "${C2}Loop D:1 - shut /// " ;:
    done
    : "${C2}Loops D:1 - complete === " ;:

    : "${C2}Reset for the next loop, assuming there is one${C0}"
    ## Note, ?? use  unset  so that values from previous loops will not interfere with the current loop
    shift

    : "${C2}Loop D - shut /// " ;:
  done
  unset JJ
  : "${C2}Loops D - complete === " ;:
                                                 __function_boundary_out_0__
}




## TODO, look at how each conf file is defined and written, each one's a little different. Make them
#+  uniform with each other, since the purpose of each section is the same in each case.

function write_ssh_conf(){                      __function_boundary_in__
  local -
  builtin set - # []

  ## Bug? $ssh_user_conf_file defined in a different function, setup_ssh()

  cat <<- \EOF > "${ssh_user_conf_file}"
	Host github.com
	ForwardAgent yes

	EOF
                                                 __function_boundary_out_0__
}

:;: "${C12}##  REGULAR FUNCTIONS COMPLETE  ##${C0}";:

  ## <>
  #EC=101 LN="${nL}" exit
  #builtin set -x
  #: 'hyphen,' "$-"

## TODO, perhaps there should be a "main()" function.







: "${C12}L:${LINENO}, Define trap on ERR${C0}"
trap trap_err ERR

: "${C12}L:${LINENO}, Define trap on EXIT${C0}"
trap trap_exit EXIT

  # <>
  #EC=101 
  #LN="${nL}" 
  #exit 
  #set -
  #EC=101 
  printf '%b enabling global xtrace %b\n' "${C4}" "${C0}" &&
    builtin set -x
  #set -x
  #LN="${nL}" exit 

: "${C12}L:${LINENO}, Regular users with sudo, only${C0}"
must_be_root

  # <>
  EC=101 
  LN="${nL}" exit 
  #: "${C2}LINENO: ${LINENO}${C0}"
  #set -x

## Note, traps
# EXIT -- for exiting
# HUP USR1 TERM KILL -- for restarting processes
# INT QUIT USR2 -- for stopping logging

  #echo foo
  #set +x
  #echo bar
  #set -x
  #declare -p qui__ ver__
  #EC=101 
  #LN="${nL}" exit # <>

: "${C12}L:${LINENO}, Test OS${C0}"
test_os

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Variables${C0}"
setup_vars

  EC=101 
  LN="${nL}" exit # <>
  set -x
  #__die__ testing
  #false

#: "<Logs>"
set -x
#logf="${tmp_dir}/log.${scr_nm}.${script_start_time}.txt"
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}"
#exec > >( tee "${logf}" ) 2>&1

: "${C12}L:${LINENO}, Certain files must have been installed from off-disk${C0}"
reqd_user_files

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Network${C0}"
setup_network

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Time${C0}"
setup_time

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Temporary directory${C0}"
setup_temp_dirs

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Minimum necessary rpms${C0}"
min_necc_packages

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Vim${C0}"
setup_vim

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Bash${C0}"
setup_bashrc

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Increase disk space${C0}"
increase_disk_space

  EC=101 
  LN="${nL}" exit # <>
  set -x

#: "<Logs>"
#set -x # <Logs>
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}" # <Logs>
#exec 3>&1 4>&2 # <Logs>
#trap "trap - INT QUIT USR2; exec 2>&4 1>&3" INT QUIT USR2 # <Logs>
#exec 1> "${logf}" 2>&1 # <Logs>

#: "<Logs>"
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}" # <Logs>
#set -x # <Logs>
#exec > >( tee "${logf}" ) 2>&1 ## this works. however, there aren\t any colors.
#exec > >( tee --append "${logf}" ) ##
#exec 2> >( GREP_COLORS="mt=01;33" grep --color=always -Ee ".*" | tee --append "${logf}" ) ## Burgy

: "${C12}L:${LINENO}, Dnf${C0}"
setup_dnf

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Restart NetworkManager if necessary${C0}"

## TODO: use written function here
for BB in "${dns_srv_A}" "${dns_srv_1}"
do
  if ! ping -4qc1 -- "${BB}" > /dev/null 2>&1
  then
    sudo -- nice --adjustment=-20 -- systemctl restart -- NetworkManager.service || 
      __die__
  fi
done
unset BB

# <Logs> Write to TTY and exit
#hash -r
#"$( type -P kill )" --signal USR2 -- "$$" # <Logs>

: "${C12}L:${LINENO}, SSH${C0}"
setup_ssh

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, GPG${C0}"
setup_gpg

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Make and change into directories${C0}"
setup_git_user_dirs

  EC=101 
  LN="${nL}" exit # <>
  set -x

#: "Git deburg settings"
#enable_git_deburg_settings

: "${C12}L:${LINENO}, Git${C0}"
setup_git

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, GH -- github CLI configuration${C0}"
setup_gh_cli

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Clone repo${C0}"
clone_repo

  EC=101 
  LN="${nL}" exit # <>
  set -x

: "${C12}L:${LINENO}, Remind user of commands for the interactive shell${C0}"

popd > /dev/null || 
  __die__

if ! [[ ${PWD} = ${dev_d1}/${scr_repo_nm} ]]
then
  printf '\n  Now run this command: \n'
  printf '\n\t cd "%s/%s" ; git status \n\n' "${dev_d1}" "${scr_repo_nm}"
fi

  set -v ## <>

: "${C12}L:${LINENO}, Clean up & exit${C0}"
#"$( type -P rm )" --force --one-file-system --preserve-root=all --recursive "${ver__[@]}" "${tmp_dir}"
printf '  %s - Done \n' "$( date +%H:%M:%S )"
EC=00 
LN="${nL}" exit
