#!/bin/bash
## #!/bin/env -iS bash

## Note: ...undocumented feature??
#+    Use `env -i` or else the script's execution environment will inherit any exported anything, 
#+  including and especially functions, from its caller, e.g., any locally defined functions (such as `rm`!)
#+  which might be intended to supercede any of the aliases which some Linux distributions often define and
#+  provide for users' convenience.  These exported functions which are received from the caller's
#+  environment get printed above the script's shebang in xtrace when xtrace and vebose are both enabled on the shebang line.
#+    ...also, using `env` messes up vim's default bash-colorizations

## LiveUsb1

## Note, written from within a Fedora instance, see hardcoded /run/media/root'
## Note, style, function definition syntax, '(){ :' makes plain xtrace easier to read
## Note, style, `! [[ -e` doesn't show the '!' in xtrace, whereas `[[ ! -e` does, and yet, for `grep`.....
## Note, idempotent script

## TODO: add colors to xtrace comments

# <> Debugging
set -aCuTeo pipefail # <>
set -x

if [[ -o xtrace ]]
then
  qui__=( '--' )
  verb__=( '--verbose' '--' )
else
  qui__=( '--quiet' '--' )
  verb__=( '--' )
fi

umask 077
hash -r

## How to add colors to xtrace comments
color_yellow=$( tput setaf 11 )
color_reset=$( tput sgr0 )
shopt -s expand_aliases
alias .y:=': $color_yellow ; :'
alias .^:=': $color_reset ; :'

  #.:;: $'TESTING\x60s -- \x56\x61\x72\x69\x61\x62\x6c\x65\x73\x20\x6c\x69\x6b\x65\x6c\x79\x20\x74\x6f\x20\x62\x65\x20\x6d\x61\x6e\x75\x61\x6c\x6c\x79\x20\x63\x68\x61\x6e\x67\x65\x64\x20\x77\x69\x74\x68\x20\x73\x6f\x6d\x65\x20\x72\x65\x67\x75\x6c\x61\x72\x69\x74\x79';.^: # <>
  #exit 101 # <>

:;: 'Variables likely to be manually changed with some regularity, or which absolutely must be defined early on'
# shellcheck disable=SC2034
{
  scr_repo_nm='LiveUsb'
  scr_nm='LiveUsb1.sh'
  
  script_start_time=$( date +%H:%M:%S )
  readonly script_start_time
  
  fn_bndry=' ~~~ ~~~ ~~~ '
  fn_lvl=0
  
  user_real_name='Wiley Young'
  user_github_email_address='84648683+wileyhy@users.noreply.github.com'
  user_github_gpg_key='E287D0CF528591CE'
  gpg_d=~/.gnupg
  
  files_for_use_with_github_level_1=( ~/.ssh "${gpg_d}" ~/.vimrc ~/.mozilla )
  files_for_use_with_github_level_2=( ~/.config/gh )
  files_for_use_with_github_level_3=( ~/.config/procps/toprc )
  arrays_of_conf_files=( files_for_use_with_github_level_1 files_for_use_with_github_level_2
    files_for_use_with_github_level_3 )
  
  ps_o=$( ps aux )
  readonly ps_o
}

:;: 'Write to TTY'
printf '  %s - Executing %s \n' "${script_start_time}" "$0"

##  FUNCTION DEFINITIONS, BEGIN ##

:;: 'Functions TOC...'
  ## functions_this_script=(
  #+  '__vte_osc7()'
  #+  '__vte_prompt_command()'
  #+  'enable_git_debug_settings()'
  #+  'er_x()'
  #+  'get_pids_for_restarting()'
  #+  'gh_auth_login_command()'
  #+  'min_necc_packages()'
  #+  'must_be_root()'
  #+  'pause_to_check()'
  #+  'reqd_user_files()'
  #+  'rm()'
  #+  'rsync_install_if_missing()'
  #+  'setup_dirs()'
  #+  'setup_git()'
  #+  'setup_network()'
  #+  'setup_ssh()'
  #+  'setup_tempd()'setup_tempd()''
  #+  'setup_time()'
  #+  'setup_vars()'
  #+  'setup_vim()'
  #+  'test_dns()'
  #+  'test_os()'
  #+  'trap_exit()'
  #+  'write_bashrc_strings()'
  #+)

#:;: 'Define __vte_osc7() -- for bashrc only'
# shellcheck disable=SC2317
#function __vte_osc7(){
  #local - cmd urlencode_o
  #set -
  #cmd=$( PATH="${PATH}:/usr/libexec:/usr/lib:/usr/lib64" command -v vte-urlencode-cwd )
  #[[ -n ${cmd} ]] || return
  #urlencode_o=$( "${cmd}" )
  #printf 'file://%s%s\n' "${HOSTNAME}" "${urlencode_o:-"${PWD}"}"
  #printf '\033]7;file://%s%s\033' "${HOSTNAME}" "${urlencode_o:-"${PWD}"}"
#}

#:;: 'Define __vte_prompt_command() -- for bashrc only'
# shellcheck disable=SC2317
#function __vte_prompt_command(){ 
    #local - fn_pwd;
    #set -;
    #fn_pwd=~;
    #if ! [[ ${PWD} = ~ ]]; then
        #fn_pwd="${fn_pwd//[[:cntrl:]]}";
        #fn_pwd="${PWD/#"${HOME}"\//\~\/}";
    #fi;
    #printf '\033[m\033]7;%s@%s:%s\033' "${USER}" "${HOSTNAME%%.*}" "${fn_pwd}";
    #printf '%s@%s:%s\n' "${USER}" "${HOSTNAME%%.*}" "${fn_pwd}";
    #__vte_osc7
#}

:;: 'Define enable_git_debug_settings()'
function enable_git_debug_settings(){ :
  local - hyphn="$-" _="${fn_bndry} enable_git_debug_settings() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"

  :;: 'Variables -- Global git debug settings'
  GIT_TRACE=true
  GIT_CURL_VERBOSE=true
  GIT_SSH_COMMAND="ssh -vvv"
  GIT_TRACE_PACK_ACCESS=true
  GIT_TRACE_PACKET=true
  GIT_TRACE_PACKFILE=true
  GIT_TRACE_PERFORMANCE=true
  GIT_TRACE_SETUP=true
  GIT_TRACE_SHALLOW=true
  [[ -f /home/liveuser/.gitconfig ]] && git config --global --list --show-origin --show-scope | cat

  true "${fn_bndry} enable_git_debug_settings()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define er_x()'
function er_x(){ local - hyphn="$-" exit_code="$?" _="${fn_bndry} er_x() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"

  printf '%s, Error, %s\n' "$scr_nm" "$*" >&2

  true "${fn_bndry} er_x() ENDS ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"

  exit "${exit_code}"
}

:;: 'Define get_pids_for_restarting()'
function get_pids_for_restarting(){ :
  local - hyphn="$-" _="${fn_bndry} get_pids_for_restarting() BEGINS ${fn_bndry} ${fn_lvl} to $((++fn_lvl))"

  ## Note,  local -Ig  picks up attributes and values from global scope and also outputs same to global
  #+  scope.
  # shellcheck disable=SC2034
  local - dnf_o pipeline1 pipeline2
  local -Ig a_pids
  dnf_o=$( sudo -- nice --adjustment=-20 -- dnf needs-restarting 2> /dev/null || er_x "${nL}" )

  ## Note, this pipeline was broken out into its constituent commands in order to verify the values
  #+  mid-stream
  pipline1=$( awk '{ print $1 }' <<< "${dnf_o}" )
  pipline2=$( grep --only-matching --extended-regexp ^'[0-9]*'$ <<< "${pipline1}" )

  readarray -d '' -t a_pids < <( tr '\n' '\0' <<< "${pipline2}" )

  true "${fn_bndry} get_pids_for_restarting()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define gh_auth_login_command()'
function gh_auth_login_command(){ :
  local - hyphn="$-" _="${fn_bndry} gh_auth_login_command() BEGINS ${fn_bndry} ${fn_lvl} to $((++fn_lvl))"
  # set -

  if gh auth status
  then
    gh auth logout
  fi

  ## Note, do not break this line with any backslashed newlines or it will fail and you'll have to
  #+  refresh auth manually; using short options for just this reason
  gh auth login -p 'ssh' -h 'github.com' -s 'admin:public_key,read:gpg_key,admin:ssh_signing_key' -w ||
    exit "${nL}"

  : 'GH - Use GitHub CLI as a credential helper'
  git config --global credential.helper "cache --timeout=3600"
  gh auth setup-git

  true "${fn_bndry} gh_auth_login_command()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define min_necc_packages()'
function min_necc_packages(){ :
  local - hyphn="$-" _="${fn_bndry} min_necc_packages() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -

  local XX 
  local -a a_pids

  for XX in git gh ShellCheck
  do
    if ! rpm --query --quiet "$XX"
    then
      sudo dnf --assumeyes install "$XX"

      ## TODO: comment out this use of $a_pids, re declaring and unsetting
      unset -v a_pids
      local -a a_pids=()
      get_pids_for_restarting

    fi
  done
  unset XX

  true "${fn_bndry} min_necc_packages()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define must_be_root()'
function must_be_root(){ :
  local - hyphn="$-" _="${fn_bndry} must_be_root() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -

  if (( UID == 0 ))
  then
    er_x Must be a regular user and use sudo
  else
    sudo --validate || er_x "${nL}"
  fi

  true "${fn_bndry} must_be_root()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define pause_to_check()'
## Usage,   pause_to_check $nL
function pause_to_check() { local -I EC=101 LN="$1"
  set -x ## sb global ?
  local - hyphn="$-" reply _="${fn_bndry} pause_to_check() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  set - ## sb local ?
  shift
  local -a KK=( "$@" )

  [[ -n ${KK[*]:0:1} ]] && printf '\n%s, pause_to_check(), %s\n' "${scr_nm}" "${KK[@]}" >&2
  printf '\n[Y|y|(enter)|(space)] is yes\nAnything else is { no and exit }\n' >&2
  
  if ! read -N1 -p $'\nReady?\n' -rst 600 reply >&2
  then
    printf '\nExiting, line %d\n\n' "${KK}" >&2
    builtin exit
  fi

  case $reply in
    Y*|y*|$'\n'|' ' )
      printf '\nOkay\n\n' >&2
      ;;\
    * )
      printf '\nExiting, line %d\n\n' "${KK}" >&2
      builtin exit
      ;;\
  esac
  unset KK

  ## TODO: copy out this construct to the rest of the functions, re bndry_cmd

  local bndry_cmd
  if [[ $hyphn =~ x ]]; then bndry_cmd='echo'; else bndry_cmd='true'; fi
  "${bndry_cmd}"  "${fn_bndry} pause_to_check()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'reqd_user_files()'
function reqd_user_files(){ :
  local - hyphn="$-" _="${fn_bndry} reqd_user_files() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -

  ## Note, QQ must be declared as local before unsetting it inside the function so that the `unset` will
  #+  effect the local variable
  local pttn_label mount_pt data_dir
  pttn_label='29_Mar_2023'
  mount_pt="/run/media/root/${pttn_label}"
  data_dir="${mount_pt}/skel-LiveUsb"

  : 'Vars: get list of mounts'
  ## Note, and yet, when locally declaring and assigning separately a regular variable, ie,
  #+  `local lsblk_out` \n `lsblk_out=''` the assignment doesn't need a preceding `local`
  ## Note, I'm using an array with $lsblk_out so I can work around `set -u` by using a ':=' PE, and so that
  #+  I can limit xtrace output by testing for a shortened version of the output of `lsblk`. I.e., I'm testing
  #+  the last line of the array, index '-1', but this is really just a practice, since a lot of times index
  #+  zero gets unset for whatever reason, but if there are any values in the array at all, then index
  #+  '-1' is guaranteed to exist. ...unless the array is completely empty...
  #+	but I don't want to UNSET ie RESET the array on each loop. If it's actually empty, I want to fill
  #+  it, but i
  #+ In this script, index zero should exist, barring any future changes. So,
  #+  it's a bit of future-proofing.
  local -a lsblk_out
  readarray -d '' -t lsblk_out < <( lsblk --noheadings --output label,path,mountpoints | awk '{ print $1,$2,$3 }' )
  [[ -n ${lsblk_out[@]} ]] || er_x "${nL}"

  : $'Vars: Get device name where label \x24pttn_label can be found'
  local pttn_path
  pttn_path=$( printf '%s\n' "${lsblk_out[@]}" | awk -v lbl="${pttn_label}" '$1 ~ lbl { print $2 }' )

  : 'Capture previous umask and set a new one'
  local prev_umask
  read -r -a prev_umask < <( umask -p )
  umask 177

  :;: 'For each array of conf files and/or directories'
  local -n QQ
  ## It isn't necessary to declare QQ as a nameref, since unsetting QQ (see below) removes the nameref
  #+  attribute, but I intend to use QQ as a nameref, so declaring QQ without a nameref attribute would be
  #+  confusing

  local AA
  for AA in "${arrays_of_conf_files[@]}"
  do
    :;: 'Loop A'

    : 'Vars'
    ## Note, if I declare a local nameref, `local -n foo`, then on the next line just assign to the nameref
    #+  directly, `foo=bar`, then on the second loop `local -p QQ` prints the former value of QQ. Perhaps
    #+  the second assignment statement, ie, `foo=bar` without `local -n` is global?
    ## Note, remember, namerefs can only be unset with the -n flag to the `unset` builtin
    unset -n QQ
    local -n QQ
    local -n QQ="${AA}"   ## good code
    #QQ="${AA}"           ## baad code

    :;: 'For each conf file or dir'
    local BB
    for BB in "${!QQ[@]}"
    do
      :;: 'Loop B'

      : 'Vars'
      local source_file dest_dir
      source_file="${data_dir}/${QQ[BB]#~/}"
      dest_dir="${QQ[BB]%/*}"

      :;: 'If the target conf file/dir does not exist'
      if ! [[ -e ${QQ[BB]} ]]
      then

        :;: 'If the source conf file/dir does not exist, then find it'
        if ! [[ -e "${source_file}" ]]
        then

          : 'If the USB device is NA, then exit'
          if [[ -z $pttn_path ]]
          then
            er_x "${nL} USB device not available, ${pttn_label}"
          fi

          : 'If the partition is not mounted which holds the data directory, then mount it'
          if ! grep --quiet "$mount_pt" <<< "${lsblk_out[@]}" # <>
          then

            : 'Mountpoint must exist'
            if ! [[ -d "${mount_pt}" ]]
            then
              sudo -- mkdir --parents -- "${mount_pt}" || er_x "${nL}"
            fi

            : $'Perform mount operation and re-sample \x60lsblk\x60'
            sudo -- mount -- "${pttn_path}" "${mount_pt}" || er_x "${nL}"

            readarray -t lsblk_out < <( lsblk --noheadings --output label,path,mountpoints )
          fi

          :;: 'If the source conf file/dir still does not exist, then throw an error'
          if ! sudo [ -e "${source_file}" ]
          then
            er_x "$nL" "${QQ[BB]}" "${source_file}"
          fi
        fi

        rsync_install_if_missing  "${source_file}" "${dest_dir}"

      else
        :;: 'If the target conf file/dir _does_ exist...'
        : '...and that conf file/dir is for GPG ...'
        ## Note, pattern `~'/.gnupg'` fails and expands as "+ [[ /home/liveuser/.gnupg = ~\/\.\g\n\u\p\g ]]"
        #+  pattern "~/'.gnupg'" ok; expands as "+ [[ /home/liveuser/.gnupg = \/\h\o\m\e\/\l\i\v\e\u\s\e\r/\.\g\n\u\p\g ]]"
        #+  pattern "~/.gnupg" ok; expands as "+ [[ /home/liveuser/.gnupg = \/\h\o\m\e\/\l\i\v\e\u\s\e\r/.gnupg ]]"
        ## Bug? if a tilda is abutted by a single quote, tilda expansion is not performed?
        if [[ ${QQ[BB]} = ~/.gnupg ]]
        then
          : $'...if the user\x60s Github GPG key is _not_ found in ~/.gnupg ...'
          count_of_user_keys=$( gpg2 --list-keys 2>&1 | grep -c "${user_github_gpg_key}" )
      
          if [[ ${count_of_user_keys} -eq 0 ]]
          then
            rsync_install_if_missing  "${source_file}" "${dest_dir}"
          fi
        fi
      fi
    done
    unset BB
  done
  unset AA QQ
  
  : 'Restore previous umask'
  builtin "${prev_umask[@]}"
      
    #EC=101 LN="$LINENO" exit # <>

  true "${fn_bndry} reqd_user_files()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define rm() -- for bashrc only'
## Note, rm(), command shadowing is intended in this case
function rm(){ :
  local -
  #set -

  :;: 'Input must exist'
  [[ ${#@} -eq 0 ]] && return "$LINENO"

  :;: 'For each positional parameter'
  local HH end_of_options opts_rm args_rm

  for HH
  do
    : 'If "End of Options" has (not) been reached'
    if ! [[ ${end_of_options:=} = 'has_been_reached' ]]
    then
      case "${HH}" in
        --version )
          command -- rm --version
          ;;
        --help )
          command -- rm --help
          ;;
        -- )
          end_of_options='has_been_reached'
          opts_rm+=( "${HH}" )
          ;;
        -f|--force|-i|--interactive|--interactive=always|-I|--interactive=once|--interactive=never|\
        --one-file-system|--no-preserve-root|--preserve-root|--preserve-root=all|-r|-R|--recursive|\
        -d|--dir|-v|--verbose )
          opts_rm+=( "${HH}" )
          ;;
        * )
          : 'No options found; options have concluded'
          end_of_options='has_been_reached'

          : 'If there is no next pos-parm'
          if [[ -z ${2:-} ]] || ! [[ $2 = -- ]]
          then
            : '...then force end of arguments on the CLI'
            opts_rm+=( -- )
          else
            : $'...or if the next pos-parm isn\x60t a valid FSO (File System Object)'
            if ! [[ -e $2 ]] || ! [[ -d $2 ]]
            then
              : '...then force end of arguments on the CLI'
              opts_rm+=( -- )
            fi
          fi

          if [[ -e ${HH} ]]
          then
            local JJ
            JJ=$( realpath -e "${HH}" )
            args_rm+=( "${JJ}" )
            unset JJ
          else
            : $'rm: unrecognized option \x27'"${HH}"$'\x27\n'
            : $'Try \x27rm --help\x27 for more information.'
          fi
          ;;
      esac
    else
      : 'Yes, so options are over and only arguments are processed'

      if [[ -e ${HH} ]]
      then
        local II
        II=$( realpath -e "${HH}" )
        args_rm+=( "${II}" )
        unset II
      else
        : $'fn_rm: cannot access \x27'"${HH}"$'\x27: No such file or directory\n'
        : $'GNU \x60rm\x60 silently ignores such inputs'
      fi
    fi

    : 'Restart loop'
    shift
  done
  : 'End of loop'

  : 'Sanity check for options and arguments'
  [[ -z ${opts_rm:=} ]] && opts_rm=( -- )

  :;: '"Recycle bin" must exist'
  local delete_d
  delete_d=~/.recycle.bin

  if ! [[ -e ${delete_d} ]] || ! [[ -d ${delete_d} ]]
  then
      command -- mkdir --mode 0700 --verbose -- "${delete_d}" || return "$LINENO"
  fi

  :;: 'If optargs exist, then  mv  the file into the recycle bucket, appending the time'
  if [[ -n ${args_rm[*]:0:8} ]]
  then
    local time_sfx
    time_sfx=$( date --utc +%s )

    command -- mv --verbose -- "${HH}" "${delete_d}/${HH}.${time_sfx}" || return "$LINENO"
  fi
  unset HH
}

:;: 'Define rsync_install_if_missing()'
function rsync_install_if_missing(){ :
  local - hyphn="$-" _="${fn_bndry} rsync_install_if_missing() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  set -x

  local fn_target_dir fn_umask fn_source_var
  #set -
  fn_source_var="$1"
  fn_target_dir="$2"

  if [[ -e "${fn_target_dir}" ]]
  then
    if ! [[ -d "${fn_target_dir}" ]]
    then
      er_x "$nL" "${fn_target_dir}"
    fi
  else
    read -r -a fn_umask < <( umask -p )
    umask 077
    mkdir --verbose --parents -- "${fn_target_dir}"
    builtin "${fn_umask[@]}"
    unset fn_umask
  fi

  if ! [[ -e ${fn_target_dir}/${fn_source_var#*"${data_dir}"/} ]]
  then
    sudo -- rsync --archive --checksum -- "${fn_source_var}" "${fn_target_dir}" || er_x "${nL}" "${fn_target_dir}"
  fi
  unset fn_source_var fn_target_dir

  true "${fn_bndry} rsync_install_if_missing()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define setup_dirs()'
function setup_dirs(){ :
  local - hyphn="$-" _="${fn_bndry} setup_dirs() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -x

  ## Note: in order to clone into any repo, and keep multiple repos separate,  cd  is required, or  pushd  / 
  #+   popd 

  :;: 'Variables -- global, for use for entire script'
  dev_d1=~/MYPROJECTS
  dev_d2=~/OTHERSPROJECTS
  readonly dev_d1
  readonly dev_d2

  :;: 'Make dirs'
  local UU
  for UU in "${dev_d1}" "${dev_d2}"
  do
    if ! [[ -d ${UU} ]]
    then
      mkdir --mode=0700 "${verb__[@]}" "${UU}" || exit "${nL}"
    fi
  done
  unset UU

  :;: 'Change dirs'
  pushd "${dev_d1}" > /dev/null || exit "${nL}"

  true "${fn_bndry} setup_dirs()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'setup_git()'
function setup_git(){ :
  local - hyphn="$-" _="${fn_bndry} setup_git() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -

  ## Note: git ui colors: normal black red green yellow blue magenta cyan white
  #+  git ui attributes: bold dim ul (underline blink reverse)
  ## Note: In vim, since 'expandtab' is set in .vimrc, to make some actual tabs, press Ctrl-v-[tab]

  ## Bug? in vim, when quoting 'EOF', $tmp_dir changes color, but bash still expands the redirection
  #+ destination file.

  ## Buggy.  I think there's some bugginess going on with these system files. ie, I don't think git actually 
  #+  uses files in etc...?
  #+    "$XDG_CONFIG_HOME/git/ignore, $GIT_DIR/info/exclude, .gitignore" - `man gitignore`

  :;: 'Git'

  :;: 'Git parameters, dependency level 1'
  local git_conf_sys git_config_sys_conf_file git_files_a git_files_b git_ignr git_mesg
  git_conf_sys=''
  git_config_sys_conf_file=/etc/gitconfig
  git_files_a=( /etc/git* /etc/.git* )
  git_files_b=( ~/.git*_system )
  git_ignr=/etc/.gitignore_system
  git_mesg=/etc/.gitmessage_system

  :;: 'Git parameters, dependency level 2'
  if sudo -- [ -f "${git_config_sys_conf_file}" ]
  then
    git_conf_sys=$( git config --global --list )
  fi
  local -A git_keys
  git_keys=(
    ['color.diff']='always'
    ['color.diff.meta']='blue black bold'
    ['color.interactive']='always'
    ['color.ui']='true'
    ['commit.gpgsign']='true'
    ['commit.template']="${git_mesg}"
    ['core.editor']='vim'
    ['core.excludesfile']="${git_ignr}"
    ['core.pager']='/usr/bin/less'
    ['gpg.program']='/usr/bin/gpg2'
    ['help.autocorrect']='prompt'
    ['init.defaultBranch']='main'
    ['user.email']="${user_github_email_address}"
    ['user.name']="${user_real_name}"
    ['user.signingkey']="${user_github_gpg_key}"
  )

  :;: 'Files must exist and Permissions'
  read -r -a prev_umask < <( umask -p )
  umask 133

  local regexp="(/etc|~)/[.]*git"
  local ZZ
  for ZZ in "${!git_files_a[@]}"
  do
      #declare -p git_files_a ZZ
  
    if [[ ${git_files_a[ZZ]} =~ ${regexp} ]]
    then
      unset 'git_files_a[ZZ]'
    fi
  done
  unset ZZ regexp

    #EC=101 LN="$LINENO" exit # <>

  local AA
  for AA in "${git_files_a[@]}"
  do
    sudo -- [ -e "${AA}" ] || sudo -- touch "${AA}"
    sudo -- chmod 0644 "${verb__[@]}" "${AA}"
  done
  unset AA
  builtin "${prev_umask[@]}"

  :;: 'git config, remove a config if present'
  if grep gpg.format "${qui__[@]}" <<< "${git_conf_sys[@]}"
  then
    git config --global --unset gpg.format 
  fi

  :;: 'git config, assigning - Loop A'
  local BB
  for BB in "${!git_keys[@]}"
  do
    :;: 'Loop A - open'
  
    : "BB:$BB"

    if ! grep "${BB}=${git_keys[$BB]}" "${qui__[@]}" <<< "${git_conf_sys[@]}"
    then
      git config --global "${BB}" "${git_keys[$BB]}"
    fi
    : "Loop A - shut" ;:
  done
  unset BB

  :;: 'gitmessage (system)'
  if ! [[ -f ${git_mesg} ]]
  then
    :;: 'Heredoc: gitmessage'
    cat <<- \EOF > "${tmp_dir}/msg"
	  Subject line (try to keep under 50 characters)

	  Multi-line description of commit,
	  feel free to be detailed.

	  [Ticket: X]

		EOF

    ## Note: this use of  sudo  is for giving write permissions to  tee
    # shellcheck disable=SC2024 #(info): sudo doesn't affect redirects. Use sudo cat file | ..
    sudo -- tee -- "${git_mesg}" < "${tmp_dir}/msg" > /dev/null || exit "${nL}"
    sudo -- chmod 0644 "${verb__[@]}" "${git_mesg}" || exit "${nL}"
  fi

    #set -x # <>

  :;: 'gitignore (system)'
  if ! [[ -f ${git_ignr} ]] || ! grep swp "${qui__[@]}" "${git_ignr}"
  then
    :;: 'Heredoc: gitignore'
    cat <<- \EOF > "${tmp_dir}/ign"
	  *~
	  .*.swp
	  .DS_Store

		EOF

    ## Note: this use of  sudo  is for giving write permissions to  tee
    # shellcheck disable=SC2024
    sudo -- tee -- "${git_ignr}" < "${tmp_dir}/ign" > /dev/null || exit "${nL}"
    sudo -- chmod 0644 "${verb__[@]}" "${git_ignr}" || exit "${nL}"
  fi

    #exit $LINENO # <>

  :;: 'Copy root-user files to USER'
  local HH
  for HH in "${git_mesg}" "${git_ignr}"
  do
    sudo -- rsync --checksum --archive "${verb__[@]}" "${HH}" ~
    sudo -- chown "${UID}:${UID}" "${verb__[@]}" ~/"${HH##*/}"
    chmod 0400 -- ~/"${HH##*/}"
  done
  unset HH

  :;: 'Rename files'
  local II
  for II in "${git_files_b[@]}"
  do
    if [[ -e $II ]]
    then
      sudo -- mv --force "${verb__[@]}" "${II}" "${II%_system}"
    fi
  done
  unset II

  ## Clean up after section "Git"
  unset git_files_a git_config_sys_conf_file git_conf_sys git_mesg git_ignr git_keys git_files_b

  true "${fn_bndry} setup_git()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define setup_network()'
function setup_network(){ :
  local - hyphn="$-" _="${fn_bndry} setup_network() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -x

  dns_srv_1=8.8.8.8
  dns_srv_A=75.75.75.75
  readonly dns_srv_1 dns_srv_A

  if ! test_dns "${dns_srv_1}" || ! test_dns "${dns_srv_A}"
  then
    printf '\n%s, Attempting to connect to the internet... \n\n' "$scr_nm"

    : 'Try to get NetworkManager up and running'
    sudo -- nice --adjustment=-20 -- systemctl start -- NetworkManager.service
    wait -f

    : 'Turn on networking'
    sudo -- nmcli n on

    : 'Turn on WiFi'
    sudo -- nmcli r wifi on

    : 'Get interface name(s)'
    readarray -d '' -t ifaces < <( nmcli --terse c |
      awk --field-separator ':' '$1 !~ /lo/ { printf "%s\0", $1 }' )

    : 'Connect the interface'
    case "${#ifaces[@]}" in
      0 )
        er_x "line,${nL}, No network device available"
        ;;\
      1 )
        nmcli c up "${ifaces[*]}"
        sleep 5
        ;;\
      * )
        er_x "line ${nL}, Multiple network devices available"
        ;;\
    esac

    if ! test_dns "${dns_srv_1}" || ! test_dns "${dns_srv_A}"
    then
      printf '\n%s, Network, Giving up, exiting.\n\n' "$scr_nm"
    else
      printf '\n%s, Network, Success!\n\n' "$scr_nm"
    fi
  fi

  ## Clean up from Network
  ## Note, dns_srv_A will be used at the end of the script
  unset -f test_dns

  true "${fn_bndry} setup_network()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define setup_ssh()'
function setup_ssh(){ :
  local - hyphn="$-" _="${fn_bndry} setup_ssh() BEGINS ${fn_bndry} ${fn_lvl} to $((++fn_lvl))"
  # set -

  ## Note, Unused var?
  #ssh_system_conf=/etc/ssh/ssh_config
  
  local ssh_usr_conf_dir
  ssh_usr_conf_dir=~/.ssh/

  if [[ -d ${ssh_usr_conf_dir} ]]
  then
    sudo -- \
      find "${ssh_usr_conf_dir}" -xdev '(' '!' -uid "${RUID}" -o '!' -gid "${RGID}" ')' -execdir \
        chown "${RUID}:${RGID}" "${verb__[@]}" '{}' ';' || 
          er_x "${nL}"
    find "${ssh_usr_conf_dir}" -xdev -type d -execdir chmod 700 "${verb__[@]}" '{}' ';'
    find "${ssh_usr_conf_dir}" -xdev -type f -execdir chmod 600 "${verb__[@]}" '{}' ';'
  else
    er_x "${nL}"
  fi
  unset ssh_usr_conf_dir

  local ssh_user_conf_file
  ssh_user_conf_file=~/.ssh/config
 
  if [[ -f ${ssh_user_conf_file} ]]
  then
    if ! grep 'ForwardAgent yes' "${qui__[@]}" "${ssh_user_conf_file}"
    then
      /bin/rm -f "${qui__[@]}" "${ssh_user_conf_file}"
      write_ssh_conf
    fi
  else
    write_ssh_conf
  fi
  unset ssh_user_conf_file
  unset -f write_ssh_conf

  ## Bug? not necc to restart ssh-agent if both of these vars exist?
  ## TODO, I do this duck-xtrace dance a few time in this script, but the procedure isn't normalized yet; do so

  :;: $'Collect output of \x60ps\x60, but without printing it to xtrace'
  local xon
  [[ -o xtrace ]] && xon=yes && set -
  [[ ${xon:=} = yes ]] && set -x
  unset xon

  : 'Make sure ssh daemon is running (?)'
  if [[ -z ${SSH_AUTH_SOCK} ]] || [[ -z ${SSH_AGENT_PID} ]]
  then
    
    ## Bug, window manager is hard coded, "startxfce4"
    
    awk_o=$( awk '$0 ~ /ssh-agent/ && $0 !~ /exec -l/ { print $2 }' <<< "${ps_o}" )

    if [[ -n ${awk_o} ]]
    then
      readarray -t ssh_agent_pids <<< "${awk_o}"
    fi
   
    ## Bug? `command -p kill "$AA"` executes the bash builtin, judging by the output of `command -p kill` 
    #+  without any operands. The output of `$( type -P kill )"` without operands is the same as the output
    #+  of /usr/bin/kill without operands. The documentation is ...somewhat unclear on these points.
    #+    `help command`: "Runs COMMAND with ARGS suppressing shell function lookup...." It seems that what
    #+  is intended is, "...suppressing shell function lookup, but still allowing builtins to be executed,"
    #+  and possibly also aliases and keywords, though I haven't tested those. The description of the '-p'
    #+  option is particularly misleading: "use a default value for PATH that is guaranteed to find all of 
    #+  the standard utilities." That "guarantee" sounds as if use of the '-p' option "shall" (using the 
    #+  POSIX defition of the word) result in a binary utility being used, when actually that is not the case.
    #+    Binary `kill` has a few options not available with the builtin, such as '--timeout', which can be
    #+  used to avoid writing an extra for loop...
    #+
    #+      sudo /bin/kill --verbose \
    #+          --timeout 1000 HUP \
    #+          --timeout 1000 USR1 \
    #+          --timeout 1000 TERM \
    #+          --timeout 1000 KILL -- "$WW"
    #+
    #+    And while we're on the topic, can `kill --help` please show the help file for /bin/kill, since
    #+  using that syntax most likely indicates that intention?

    if [[ ${#ssh_agent_pids[@]} -gt 0 ]]
    then
      case "${#ssh_agent_pids[@]}" in
        1)  if [[ -v SSH_AGENT_PID ]]
            then
              ## Note:  ssh-agent  doesn't have any long options.  ssh-agent -k  is "kill the current agent."
              ssh-agent -k
            else
              "$( type -P kill )" "${verb__[@]}" "${ssh_agent_pids[*]}"
            fi
          ;;\
        *)  for VV in "${ssh_agent_pids[@]}"
            do
              "$( type -P kill )" "${verb__[@]}" "${VV}"
            done
            unset VV
          ;;\
      esac
    fi

    ## Note:  ssh-agent -s  is "generate Bourne shell commands on stdout."

    ssh_agent_o=$( ssh-agent -s )
    eval "${ssh_agent_o}"

    ## Note:  ssh-add  and  ssh  don't have long options.  ssh-add -L  is "list;"  ssh -T  is "disable
    #+ pseudo-terminal allocation.

    ## Bug? hardcoded filename

    ssh-add ~/.ssh/id_ed25519
    ssh-add -L
    ssh -T git@github.com
  fi

  true "${fn_bndry} setup_ssh()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'setup_tempd()'
function setup_tempd(){ :
  local - hyphn="$-" _="${fn_bndry} setup_tempd() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"

  tmp_dir=$( TMPDIR='' mktemp --directory --suffix=-LiveUsb 2>&1 || er_x "${nL}" )
  [[ -d ${tmp_dir} ]] || er_x "${nL}"
  readonly tmp_dir

  true "${fn_bndry} setup_tempd()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define setup_time()'
function setup_time(){ :
  local - hyphn="$-" _="${fn_bndry} setup_time() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"

  sudo -- timedatectl set-local-rtc 0
  sudo -- timedatectl set-timezone America/Vancouver
  sudo -- nice --adjustment=-20 -- systemctl start chronyd.service || er_x "line ${nL}"
  sudo -- chronyc makestep > /dev/null

  true "${fn_bndry} setup_time()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}


:;: 'Define setup_vars()'
function setup_vars(){ :
  local - hyphn="$-" _="${fn_bndry} setup_vars() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"

  :;: 'Vars, dirs, etc'
  ## Bug, only way to export namerefs?  `declare -nx nL=...`

  :;: 'Vars... -- Error handling, variables and functions'
  ## Note, variable assignments, backslash escape bc  sed -i
  # shellcheck disable=SC1001
  local -gnx nL=L\INENO

  :;: 'Vars... -- PATH'
  PATH='/usr/bin:/usr/sbin'
  export PATH

  :;: 'Vars... -- Other environment variables'
  ## Note, Initialize some env vars found in sourced files, as a workaround for nounset'
  ## Note, local style, inline comments, ie, ': foo ## Note, blah', are useful for rebutting false positives
  #+  from ShellCheck
  LC_ALL=''
  PS1=''
  if [[ -z ${RUID:=} ]]; then RUID=$( id -u "$( logname )" ); readonly RUID; fi
  if [[ -z ${RGID:=} ]]; then RGID=$( id -g "$( logname )" ); readonly RGID; fi
  # shellcheck disable=SC2034
  declare BASHRCSOURCED USER_LS_COLORS ## Note, /etc/bashrc and /etc/profile.d/colorls.*sh on Fedora 38

  true "${fn_bndry} setup_vars()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}






:;: 'Define setup_vim()'
function setup_vim(){ :
  local - hyphn="$-" _="${fn_bndry} setup_vim() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  
  : 'Heredoc of vim-conf-text'
  cat <<- \EOF | tee -- "${tmp_dir}/vim-conf-text" > /dev/null
		" ~/.vimrc

		" per Google
		set number

		" per https://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim
		filetype plugin indent on
		" show existing tab with 2 spaces width
		set tabstop=2
		" when indenting with '>', use 2 spaces width
		set shiftwidth=2
		" On pressing tab, insert 2 spaces
		set expandtab

		" per https://superuser.com/questions/286290/is-there-any-way-to-hook-saving-in-vim-up-to-commiting-in-git
		autocmd BufWritePost * execute '! if [[ -d .git ]]; then git commit -S -a -F -; fi'

		EOF

  : $'Get an array of the FS location\x28s\x29 of root\x27s vimrc\x28s\x29'
  readarray -d '' -t arr_vrc < <( sudo -- find /root -name '*vimrc*' -print0 )

  case "${#arr_vrc[@]}" in
    0 )
        strng_vrc=/root/.vimrc
      ;;\
    1 )
        strng_vrc="${arr_vrc[*]:=/root/.vimrc}"
      ;;\
    *)
        printf '\n  Multiple .vimrc files found, please edit the filesystem.\n' >&2
        printf '\t%s\n' "${arr_vrc[@]}" >&2
        er_x "${nL}"
      ;;\
  esac

  if (( "${#arr_vrc[@]}" == 1 ))
  then
    read -r WW XX < <( sudo -- sha256sum -- "${tmp_dir}/vim-conf-text" 2>&1 )
    read -r YY XX < <( sudo -- sha256sum -- "${strng_vrc}" 2>&1 )
  else
    sudo -- touch -- "${strng_vrc}" # <> set-e
  fi

  : 'Write .vimrc'
  if (( ${#arr_vrc[@]} == 0 )) || ! [[ ${WW} = "${YY}" ]]
  then
    : $'Test returned \x22true,\x22 the number didn\x27t match, so write to .vimrc'

    : 'Set the umask'
    read -ra umask_prior < <( umask -p )
    umask 177

    : 'Write the root file'
    sudo -- rsync --archive --checksum -- "${tmp_dir}/vim-conf-text" "${strng_vrc}" || er_x "${nL}"

    : $'Copy the root file to ~liveuser and repair DAC\x27s on liveuser\x27s copy'
    sudo -- rsync --archive --checksum -- "${strng_vrc}" "/home/${USER}/.vimrc" || er_x "${nL}"
    sudo -- chown "${UID}:${UID}" -- "/home/${USER}/.vimrc"
    chmod 0400 -- "/home/${USER}/.vimrc"

    : 'Reset the umask'
    builtin "${umask_prior[@]}"
  fi

  ## Clean up after section Vim
  command -- rm --one-file-system --preserve-root=all --force -- "${tmp_dir}/vim-conf-text"
  unset arr_vrc strng_vrc write2fs WW XX YY umask_prior

  true "${fn_bndry} setup_vim()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

:;: 'Define test_dns()'
function test_dns(){ :
  local - hyphn="$-" _="${fn_bndry} test_dns() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -

  sudo -- ping -c 1 -W 15 -- "$1" > /dev/null 2>&1
  ping_exit_code=$?

  true "${fn_bndry} test_dns()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
  return "${ping_exit_code}"
}

:;: 'Define test_os()'
function test_os(){ :
  local - hyphn="$-" _="${fn_bndry} test_os() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"

  local kern_rel
  kern_rel=$( uname --kernel-release )

  ## Note, test of $kern_rel is a test for whether the OS is Fedora (ie, "fc38" or "Fedora Core 38")
  if ! [[ ${kern_rel} =~ \.fc[0-9]{2}\. ]]
  then
    er_x "${LINENO}, OS is not Fedora"
  fi

  true "${fn_bndry} test_os()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

## Bug, these var assignments $exit_trap_ec and $lineno only fail when they're on line number >=2
#+  of  trap  "args section" ??

:;: 'Define trap_exit()'
## Note: these variable assignments must be on the 1st line of the funtion in order to capture correct data
# shellcheck disable=SC2317
function trap_exit(){ local - hyphn="$-" exit_trap_ec="${EC:-$?}" lineno="${LN:-$LINENO}"
  declare -p PIPESTATUS
  true "${fn_bndry} trap_exit() BEGINS ${fn_bndry} ${fn_lvl} to $(( ++fn_lvl ))"
  #set -

  #if [[ -e ${tmp_dir} ]]
  #then
    #command rm --one-file-system --preserve-root=all --force --recursive -- "${tmp_dir}"
  #fi

  trap - EXIT

  if [[ ${exit_trap_ec} -eq '00' ]]
  then
    : "End of script, line ${lineno}"
  else
    : 'End of EXIT trap'
  fi

  true "${fn_bndry} trap_exit()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"

  builtin exit "${exit_trap_ec}"
}

:;: 'Define write_bashrc_strings()'
function write_bashrc_strings(){ :
  local - hyphn="$-" _="${fn_bndry} write_bashrc_strings() BEGINS ${fn_bndry} ${fn_lvl} to $((++fn_lvl))"
  set -x

  :;: 'Certain parameters must be defined and have non-zero values'
  (( ${#files_for_use_with_bash[@]} == 0 )) && er_x "line ${nL}"
  (( $# == 0 ))                             && er_x "line ${nL}"

  local JJ file_x Aa_index Aa_element
  local -n fn_nameref

  for JJ
  do :;: 'Loop A - For each set of strings to append into bashrc'

    unset -n fn_nameref
    local -n fn_nameref="$JJ"

    for file_x in "${files_for_use_with_bash[@]}"
    do :;: 'Loop B - For each .bashrc'

      : "file_x  ${file_x}"

      for Aa_index in "${!fn_nameref[@]}"
      do :;: 'Loop C - For each definition (function or parameter)'

        : "Aa_index  ${Aa_index}"
        Aa_element="${fn_nameref[${Aa_index}]}"

        :;: '(1) If the definition is not yet written into the file...'
        if ! sudo -- grep --quiet --fixed-strings "## ${Aa_index}" -- "${file_x}"
        then

          : 'Then write the function definition into the file'
          printf '\n## %s \n%s \n' "${Aa_index}" "${Aa_element}" |
            sudo -- tee --append -- "${file_x}" > /dev/null || er_x "${nL}"
        else
          : 'Definition exists, skipping'
        fi

        ## Bug: what if it\s a multiline alias?

        :;: '(2) If there is an alias by the same name, then delete it from the bashrc file at hand...'
        sudo -- sed --in-place "/^alias ${Aa_index##* }=/d" -- "${file_x}"

        : 'Loop C - shut' ;:
      done
      unset Aa_element
      :;: 'Loop C - complete'

      :;: 'For each file, if absent add a newline at EOF'
      if sudo -- tail --lines 1 -- "${file_x}" | grep --quiet --extended-regexp '[[:graph:]]'
      then
        printf '\n' | sudo -- tee --append -- "${file_x}" > /dev/null
      fi

      : 'Loop B - shut' ;:
    done

    :;: 'Reset for the next loop, assuming there is one'
    ## Note, ?? use  unset  so that values from previous loops will not interfere with the current loop
    shift

    : 'Loop A - shut' ;:
  done
  unset JJ

  true "${fn_bndry} write_bashrc_strings()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

function write_ssh_conf() { :
  local - hyphn="$-" _="${fn_bndry} write_ssh_conf() BEGINS ${fn_bndry} ${fn_lvl} to $((++fn_lvl))"
  set -x

  cat <<- \EOF > "${ssh_user_conf_file}"
	Host github.com
	ForwardAgent yes

	EOF
  
  true "${fn_bndry} write_ssh_conf()  ENDS  ${fn_bndry} ${fn_lvl} to $(( --fn_lvl ))"
}

##  FUNCTION DEFINITIONS COMPLETE ##

  #EC=101 LN="$LINENO" exit # <>



:;: 'Define trap on EXIT'
trap trap_exit EXIT

:;: 'Test OS'
test_os

:;: 'Variables'
setup_vars



:;: '<Logs>'
#set -x
#logf="${tmp_dir}/log.${scr_nm}.${script_start_time}.txt"
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}"
#exec > >( tee "${logf}" ) 2>&1

## Note, traps
# EXIT -- for exiting
# HUP USR1 TERM KILL -- for restarting processes
# INT QUIT USR2 -- for stopping logging



:;: 'Regular users with sudo, only'
must_be_root

:;: 'Certain files must have been installed from off-disk'
reqd_user_files

  #EC=101 LN="$LINENO" exit # <>

:;: 'Network'
setup_network

:;: 'Time'
setup_time

:;: 'Temporary directory'
setup_tempd

:;: 'Vim'
setup_vim

:;: 'Minimum necessary rpms'
min_necc_packages

#:;: 'Git debug settings'
#enable_git_debug_settings

:;: 'Minimum necessary git commands'
setup_git

:;: 'Make and change into directories'
setup_dirs

:;: 'SSH'
setup_ssh

:;: 'GPG'

sudo -- \
  find "${gpg_d}" -xdev '(' '!' -uid "${RUID}" -o '!' -gid "${RGID}" ')' -execdir \
    chown "${RUID}:${RGID}" "${verb__[@]}" '{}' ';' || 
      exit "${nL}"
find "${gpg_d}" -xdev -type d '!' -perm 700  -execdir chmod 700 "${verb__[@]}" '{}' ';'
find "${gpg_d}" -xdev -type f '!' -perm 600  -execdir chmod 600 "${verb__[@]}" '{}' ';'

: 'GPG -- If a gpg-agent daemon is running, kill it' ## Why???
if grep --extended-regexp '[g]pg-a.*daemon' "${qui__[@]}" <<< "${ps_o}"
then
  gpgconf --verbose --kill gpg-agent
fi

gpg-connect-agent --verbose /bye
GPG_TTY=$( tty )
export GPG_TTY

  #set -x # <>



:;: 'GH -- github CLI configuration'
declare -A github_configs
github_configs=( [editor]=vim [browser]=firefox [pager]=less [git_protocol]=ssh )
gh_config_list_out=$( gh config list | tr '\n' ' ' )

for KK in "${!github_configs[@]}"
do
  if ! [[ ${gh_config_list_out} = "${KK}=${github_configs[$KK]}" ]]
  then
    gh config set "${KK}" "${github_configs[$KK]}"
  fi
done
unset KK gh_config_list_out github_configs

  wait -f # <>

:;: 'GH -- Login to github'
## Note, executing this command just once
count_gh_auth_checkmarks=$( gh auth status |& grep --only $'\xe2\x9c\x93' | wc -l )
#printf -v count_gh_auth_checkmarks '%s' $( gh auth status |& grep --count $'\xe2\x9c\x93' )

  wait -f # <>
  declare -p count_gh_auth_checkmarks
  EC=101 LN="${nL}" exit

if ! gh auth status 2>/dev/null 1>&2 || [[ ${count_gh_auth_checkmarks} -ne 4 ]]
then
  if ! pgrep 'firefox'
  then
    firefox --browser 2>/dev/null 1>&2 &
    sleep 5
    pause_to_check "$nL" 'Waiting till browser is open before running  gh auth  command'
    gh_auth_login_command
  fi
fi

:;: 'GH -- Get SSH & GPG keys'
for QQ in ssh-key gpg-key
do
  if ! gh "${QQ}" list > /dev/null
  then
    gh_auth_login_command
  fi
done
unset QQ

  set -x



:;: 'Clone repo'
[[ ${PWD} = "${dev_d1}" ]] || er_x "${nL}"

if [[ ! -d ${scr_repo_nm} ]] || [[ ! -f ${scr_repo_nm}/README.md ]]
then
  git clone --verbose --origin 'github' "${verb__[@]}" "https://github.com/wileyhy/${scr_repo_nm}" || exit "${nL}"
fi



:;: 'Bash'
## Note, this section is for .bashrc. VTE functions are from Fedora 38, Sun 09 July 2023, altered from vte.sh

:;: 'Do some backups'
files_for_use_with_bash=( /root/.bashrc ~/.bashrc )

for WW in "${files_for_use_with_bash[@]}"
do
  : 'File must exist'
  if ! sudo -- [ -f "${WW}" ]
  then
    er_x "line ${nL}, ${WW}"
  fi

  : '...of the array files_for_use_with_bash'
  if ! sudo -- [ -e "${WW}.orig" ]
  then
    sudo -- rsync --checksum --archive -- "${WW}" "${WW}.orig"
    sudo -- chmod 400 -- "${WW}.orig"
    sudo -- chattr +i -- "${WW}.orig"
  fi

  : '...per-script-execution file backup'
  sudo -- cp --archive -- "${WW}" "${WW}~" || er_x "line ${nL}, ${WW}"
done
unset WW

:;: 'Env parameters for bashrc'

:;: 'Color code assigned to PS0, ducking xtrace'
## Note,  set [-|-x] , letting xtrace expand this  tput  command alters all xtrace colorization
if [[ -o xtrace ]]
then
  set -
  PS0=$( tput setaf 43 )
  set -x
else
  PS0=$( tput setaf 43 )
fi

:;: 'Set up PROMPT_COMMAND'
: 'Variables dependency level 1'
pc_regx='not found$'
propmt_colors_reset=$(tput sgr0)

: 'Variables dependency level 2'
prompt_cmd_0='printf "%b" "${propmt_colors_reset}"'

: 'Variables dependency level 3'
## Note, PROMPT_COMMAND could have been inherited as a string variable
unset PROMPT_COMMAND
declare -a PROMPT_COMMAND
PROMPT_COMMAND=( [0]="${prompt_cmd_0}" )

if ! [[ "$( declare -pF __vte_prompt_command 2>&1 )" =~ ${pc_regx} ]]
then
  PROMPT_COMMAND+=( __vte_prompt_command )
fi

:;: 'Other parameters'
PS1="[\\u@\\h]\\\$ "
BROWSER=$( command -v firefox )
EDITOR=$( command -v vim )

:;: 'Append user variables and functions into .bashrc.'
## Note, these arrays include some command substitutions which depend on some function definitions, which in
#+  turn must be defined prior to defining these arrays

:;: 'Define lists of parameters to be appended into bashrc'
## Note, there are multiple lists for variables due to layers of dependencies. Later in the process, 
#+  each of these groups is relayed using associative arrays, which do not reliably maintain their internal
#+  ordering, so, some consistent ordering must be imposed here.
vars_for_bashrc_1=( 'BROWSER' 'EDITOR' 'PS0' 'propmt_colors_reset' )
vars_for_bashrc_2=( 'prompt_cmd_0' )
vars_for_bashrc_3=( 'PROMPT_COMMAND' )
fcns_for_bashrc_1=( 'rm' ) #'__vte_osc7' '__vte_prompt_command' 

:;: 'Said variables and functions must have already been defined';:
:;: '  Variables'
missing_vars_and_fns=()

for QQ in "${vars_for_bashrc_1[@]}" "${vars_for_bashrc_2[@]}" "${vars_for_bashrc_3[@]}"
do
  if [[ $( declare -p "${QQ}" 2>&1 ) =~ ${pc_regx} ]]
  then
    missing_vars_and_fns+=( "${QQ}" )
  fi
done
unset QQ

:;: '  Functions'
for UU in "${fcns_for_bashrc_1[@]}"
do
  if [[ $( declare -pF "${UU}" 2>&1 ) =~ ${pc_regx} ]]
  then
    missing_vars_and_fns+=( "${UU}" )
  fi
done
unset UU

:;: '  Test for any missing parameters'
if (( ${#missing_vars_and_fns[@]} > 0 ))
then
  er_x "${nL}", "${missing_vars_and_fns[@]}"
fi

:;: 'Define bashrc_strings_*'
## Note, you want for these array elements to represent just one parameter or function each
unset       bashrc_strings_F1 bashrc_strings_V1 bashrc_strings_V2 bashrc_strings_V3
declare -A  bashrc_strings_F1 bashrc_strings_V1 bashrc_strings_V2 bashrc_strings_V3

: '  bashrc: Variables'
for XX in "${vars_for_bashrc_2[@]}"; do bashrc_strings_V1+=( ["define parameter ${XX}"]=$( declare -p "${XX}" ) ); done
for YY in "${vars_for_bashrc_2[@]}"; do bashrc_strings_V2+=( ["define parameter ${YY}"]=$( declare -p "${YY}" ) ); done
for ZZ in "${vars_for_bashrc_3[@]}"; do bashrc_strings_V3+=( ["define parameter ${ZZ}"]=$( declare -p "${ZZ}" ) ); done
unset XX YY ZZ

: '  bashrc: Functions (a.k.a. "subroutines")'
for AA in "${fcns_for_bashrc_1[@]}"
do
  bashrc_strings_F1+=( ["define subroutines ${AA}"]="function $( declare -pf "${AA}" )" )
done
unset AA

:;: 'Write functions and variable definitions into bashrc files'
write_bashrc_strings bashrc_strings_F1 
write_bashrc_strings bashrc_strings_V1
write_bashrc_strings bashrc_strings_V2
write_bashrc_strings bashrc_strings_V3

## Clean up from section Bash
unset pc_regx prompt_cmd_0
unset files_for_use_with_bash bashrc_strings_F bashrc_strings_V
unset -f write_bashrc_strings

  #EC=101 LN="${nL}" exit

:;: 'Disk space, increase available by removing non-local locales'

## Note, such as...   /usr/lib/locale /usr/share/i18n/locales /usr/share/locale /usr/share/X11/locale , etc.
## Note, for $dirs1 , find  syntax based on Mascheck's
## Note, for $dirs2 , use of bit bucket because GVFS ‘/run/user/1000/doc’ cannot be read, even by root
## Note, for $fsos3 , '--and' is not POSIX compliant
## Note, for $fsos4 , sorts by unique inode and delimits by nulls

## Bug, Hardcoded path, for $dirs2 , '/run/media/root' is a default for mounting external media on
#+  Fedora-like systems

declare -A fsos5
readarray -d '' -t dirs1 < <( find / ! -path / -prune -type d -print0 )

readarray -d '' -t dirs2 < <(
  find "${dirs1[@]}" -type d -name '*locale*' ! -ipath '*/run/media/root/*' -print0 2> /dev/null )

readarray -d '' -t fsos3 < <(
  find "${dirs2[@]}" -type f -size +2048b '(' ! -ipath '*en_*' -a !  -ipath '*/.git/*' ')' -print0 )

if (( ${#fsos3[@]} > 0 ))
then
  ## Note, for loop is run in a process substitution subshell, so unsetting BB is unnecessary
  readarray -d '' -t fsos4 < <( {
    for BB in "${fsos3[@]}"
    do
      printf '%s\0' "$( stat --printf='%i %n\n' -- "${BB}" )"
    done ; } |
      sort --unique |
      tr --delete '\n';
    )

  ## Question, does this assoc array fsos5 need to be declared as such? (I don't think so, but...)

  set -- "${fsos4[@]}"

  while true
  do
    [[ -z ${1:-} ]] && break 1 # <> set-u

    # shellcheck disable=SC2190
    fsos5+=( "${1%% *}" "${1#* }")
    shift 1

    (( $# == 0 )) && break 1
  done
fi

: 'If any larger local data files were found, then remove them interactively'
if [[ -n ${!fsos5[*]} ]]
then
  : 'Inform user of any found FSOs'
  printf '%s, Delete these files? \n' "${scr_nm}"
  declare -p fsos5
  sleep 3

  for AA in "${!fsos5[@]}"
  do
    HH=0
    II=0
    JJ="${fsos5[$AA]#.}"
    printf '%s,   File %d, \n' "${scr_nm}" "$(( ++II ))"

    while true
    do
      if [[ -e ${JJ} ]]
      then
        declare ls_out        
        readarray -t ls_out < <( ls -l --all --human-readable --classify --inode --directory --zero "${JJ}" )
        ## Note, '\x60' is a "backtick"
        printf '%s, output of %bls%b, %s \n' "${scr_nm}" '\x60' '\x60' "$( realpath -e "${JJ}" )"
        printf '%s\n' "${ls_out[@]}"
        unset ls_out

        read -r -p ' > [yN] ' -t 600 yes_or_no
        yes_or_no="${yes_or_no,,?}"
        yes_or_no="${yes_or_no:=n}"

        case "${yes_or_no}" in
          0|1)  printf '  Zero and one are ambiguous, please use letters. \n'
                continue 0001
              ;;\
          y|t)  printf '  %s %b %s %s \n' 'Script,' ' \x60rm -i\x60 ' 'requires a typed [yN] response,' \
                  'it defaults to do-not-delete if a user just presses [enter].'

                if sudo -- command rm --one-file-system --preserve-root=all --interactive -- "${JJ}"
                then
                  unset 'fsos5[$AA]'
                  break 00001
                else
                  er_x "${nL}, unknown error"
                fi
              ;;\
          n|f)  printf '  Keeping this file. \n'
                unset 'fsos5[$AA]'
                break 00001
              ;;\
          *)    HH=$(( ++HH )) # <> set-e, can be just  (( HH++ ))  when errexit's off

                if (( HH < 3 ))
                then
                  printf '  Invalid response (%d), please try again. \n' "${HH}"

                else
                  printf '  Keeping this file. \n'
                  unset 'fsos5[$AA]'
                  break 00001
                fi
              ;;\
        esac
      else
        break 0001
      fi
    done
  done
fi

## Clean up from section "Disk space"
unset dirs1 dirs2 fsos3 fsos4 fsos5 AA HH II JJ yes_or_no

#:;: '<Logs>'
#set -x # <Logs>
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}" # <Logs>
#exec 3>&1 4>&2 # <Logs>
#trap 'trap - INT QUIT USR2; exec 2>&4 1>&3' INT QUIT USR2 # <Logs>
#exec 1> "${logf}" 2>&1 # <Logs>

#:;: '<Logs>'
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}" # <Logs>
#set -x # <Logs>
#exec > >( tee "${logf}" ) 2>&1 ## this works. however, there aren't any colors. 
#exec > >( tee --append "${logf}" ) ## 
#exec 2> >( GREP_COLORS='mt=01;33' grep --color=always -Ee '.*' | tee --append "${logf}" ) ## Buggy

:;: 'Dnf'

## Bug, there should be a n\eeds-restarting loop between each install/upgrade
## Bug, the --security upgrade should be done rpm by rpm

  : 'Beginning section on DNF' # <>

## Note, CUPS cannot be safely removed; too many dependencies
## Note, For some unknown reason, even when  dnf  doesn't change any programs,  dnf
#+  needs-restarting  decides it needs to restart all available Firefox processes, which crashes all of
#+  my tabs.  (Bug?)  So, I'm adding in a few  rpm -qa | wc -l s to only run  dnf
#+  needs-restarting  in the event that any files on disk may actually have been changed.
## Note, these PE's (for_admin, for_bash, etc.) have been tested and should "disappear" by virtue of
#+  whichever expansion does that, leaving just the regular strings as the elements of the array
## Note, this brace grouping (all together of for_admin, for_bash, etc.) is so that "shellcheck disable" will
#+  apply to the entire block

hash_of_installed_pkgs_A=$( rpm --all --query | sha256sum | awk '{ print $1 }' )

## Removals for disk space
pkg_nms_for_removal=( google-noto-sans-cjk-vf-fonts mint-x-icons mint-y-icons transmission )

## Removals for security
#pkg_nms_for_removal+=( blueman bluez )

# shellcheck disable=SC2206
{
    addl_pkgs=(  ${for_admin:=}        ncdu pwgen )
    addl_pkgs+=( ${for_bash:=}         bash bash-completion )
  # addl_pkgs+=( ${for_bashdb:=}       bash-devel make autoconf )
    addl_pkgs+=( ${for_critical_A:=}   sudo nss openssh chrony dnf gpgme xfce4-terminal )
    addl_pkgs+=( ${for_critical_B:=}   NetworkManager NetworkManager-{adsl,bluetooth,libnm,ppp} )
    addl_pkgs+=( ${for_critical_C:=}   NetworkManager-{team,wifi,wwan} )
  # addl_pkgs+=( ${for_careful:=}      systemd auditd sssd )
  # addl_pkgs+=( ${for_db_ish:=}       libreoffice-calc )
  # addl_pkgs+=( ${for_bug_rpts:=}     inxi zsh dash mksh lynx )
  # addl_pkgs+=( ${for_char_sets:=}    enca moreutils uchardet )
    addl_pkgs+=( ${for_duh:=}          info plocate pdfgrep wdiff )
    addl_pkgs+=( ${for_firefox:=}      mozilla-noscript mozilla-privacy-badger mozilla-https-everywhere )
  # addl_pkgs+=( ${for_fun:=}          supertuxkart )
  # addl_pkgs+=( ${for_gcov:=}         gcc )
    addl_pkgs+=( ${for_git:=}          git gh )
  # addl_pkgs+=( ${for_internet:=}     chromium )
  # addl_pkgs+=( ${for_later_other:=}  memstomp gdb valgrind memstrack kernelshark )
  # addl_pkgs+=( ${for_later_trace:=}  bpftrace python3-ptrace fatrace apitrace x11trace )
    addl_pkgs+=( ${for_linting:=}      ShellCheck strace )
  # addl_pkgs+=( ${for_mo_linting:=}   kcov shfmt patch ltrace )
  # addl_pkgs+=( ${for_lockfile:=}     procmail )
  # addl_pkgs+=( ${for_os_dnlds:=}     debian-keyring )
    addl_pkgs+=( ${for_strings:=}      binutils )
  # addl_pkgs+=( ${for_term_tests:=}   gnome-terminal )
  # addl_pkgs+=( ${for_unicode:=}      xterm rxvt-unicode perl-Text-Bidi-urxvt )
    addl_pkgs+=( ${for_security:=}     orca protonvpn-cli xsecurelock )
}

:;: 'Start with removing any unnecessary RPMs'

if [[ -n ${pkg_nms_for_removal:0:8} ]]
then
  ## Note, this  printf  command uses nulls so that  -e  and  %s...  will be read as separate indices
  #+  by  readarray
  readarray -d '' -t grep_args < <( printf -- '-e\0%s.*\0' "${pkg_nms_for_removal[@]}" )
  readarray -t removable_pkgs < <(
    rpm --all --query | grep --ignore-case --extended-regexp "${grep_args[@]}" )

  :;: 'Keep a list, just in case an rpm removal accidentally erases something vital'
  if [[ -n ${removable_pkgs[*]:0:8} ]]
  then
    for QQ in "${!removable_pkgs[@]}"
    do
      ## Note,  dnf , do not use [-y|--yes] with this particular command
      if sudo -- nice --adjustment=-20 -- dnf --allowerasing remove -- "${removable_pkgs[QQ]}"
      then
        unset 'removable_pkgs[QQ]'
      else
        er_x Line "${nL}", "${removable_pkgs[QQ]}"
      fi
    done
    unset QQ
  fi
fi

:;: 'Then do a blanket security upgrade'

## Note, the problem with this "blanket security upgrade" is how it includes kernel and firmware. Better to
#+  capture list of rpms in a no-op cmd, filter out impractical (for a LiveUsb) rpms, then upgrade the rest
#+  one by one

## Run this loop until `dnf --security upgrade` returns 0, or 0 upgradable, rpms
while true
do

  ## Bug: extra grep - sb wi same awk cmd

  ## Get full list of rpms to upgrade, in an array; exit on non-zero
  mapfile -d '' -t pkgs_for_upgrade < <(
    sudo -- dnf --assumeno --security upgrade 2>/dev/null |
      awk '$2 ~ /x86_64|noarch/ { printf "%s\0", $1 }' |
      grep -vEe ^'replacing'$
    )

  ## remove all  kernel  and  firmware  rpms from $pkgs_for_upgrade array
  for HH in "${!pkgs_for_upgrade[@]}"
  do
    if [[ ${pkgs_for_upgrade[HH]} =~ kernel|firmware ]]
    then
      unset_reason+=( [HH]="${BASH_REMATCH[*]}" )
      unset 'pkgs_for_upgrade[HH]'
    fi
  done
  unset HH

  ## If count of upgradeable rpms is 0, then break loop
  if [[ "${#pkgs_for_upgrade[@]}" -eq 0 ]]
  then
    break
  fi

  ## Upgrade the RPM's one at a time
  for II in "${!pkgs_for_upgrade[@]}"
  do
    if sudo -- dnf --assumeyes --security upgrade -- "${pkgs_for_upgrade[II]}"
    then
      unset 'pkgs_for_upgrade[II]'
    else
      printf 'ERROR %d\n' "${II}"
      break
    fi
  done
  unset II

  ## Run `dnf needs-restarting`, collecting PID/commandline pairs
  a_pids=()
  get_pids_for_restarting

    declare -p a_pids
    #exit 101

  ## Send signals to "needs-restarting" PID's, one at a time, with pauses and descriptions between each
  #+  one, so I can see which signal/process combinations cause any problems. This would be a great job
  #+  for logging.

done

  #pause_to_check "$nL" $'Which packages in the \x24addl_pkgs array are already installed?' # <>

:;: 'Find out whether an RPM is installed, one by one'
for UU in "${!addl_pkgs[@]}"
do
  if sudo -- nice --adjustment=-20 -- rpm --query --quiet -- "${addl_pkgs[UU]}"
  then
    pkgs_installed+=( "${addl_pkgs[UU]}" )
    unset 'addl_pkgs[UU]'
  fi
done
unset UU

  #pause_to_check "$nL" $'Upgrade any pre-intstalled packages from the \x24addl_pkgs array' # <>

## Note, this section should upgrade rpms one by one

:;: 'Upgrade any installed RPMs from the main list, en masse'
if [[ -n ${pkgs_installed[*]: -1:1} ]]
then
  sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet upgrade -- "${pkgs_installed[@]}" || er_x "${nL}"
fi

  #pause_to_check "$nL" $'From the \x24addl_pkgs array, install the remainder' # <>

:;: 'Install any as yet uninstalled RPMs from the main list as necessary'
not_yet_installed_pkgs=( "${addl_pkgs[@]}" )

if [[ -n ${not_yet_installed_pkgs[*]: -1:1} ]]
then
  ## Note, if you install multiple rpms at the same time, and one of them causes some error, then you have
  #+  no immediate way of knowing which one caused the error

  for VV in "${not_yet_installed_pkgs[@]}"
  do
    sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet install -- "${VV}" || er_x "${nL}"

    a_pids=()
    get_pids_for_restarting

    if [[ -n ${a_pids[*]:0:1} ]]
    then

      for WW in "${a_pids[@]}"
      do
        ps aux | awk "\$2 ~ /${WW}/ { print }"

        #pause_to_check "$nL" 'Execute a lengthy \x60kill --timeout...\x60 command?'

        sudo -- nice --adjustment=-20 -- "$(type -P kill)" --verbose \
          --timeout 1000 HUP \
          --timeout 1000 USR1 \
          --timeout 1000 TERM \
          --timeout 1000 KILL -- "$WW"

        #sudo -- nice --adjustment=-20 -- "$(type -P kill)" --verbose --timeout 1000 HUP --timeout 1000 USR1 --timeout 1000 TERM --timeout 1000 KILL -- "$WW"

        sleep 3

        ps aux | awk "\$2 ~ /${WW}/ { print }"

        #pause_to_check "$nL" 'Now do you need to manually restart anything?'

      done
      unset WW
    fi
  done
  unset VV
fi
unset pkg_nms_for_removal addl_pkgs
unset for_{admin,bash,bashdb,db_ish,bug_rpts,duh,firefox,fun,gcov,git,internet,later_{other,trace}}
unset for_{linting,lockfile,os_dnlds,strings,term_tests,unicode}
unset grep_args removable_pkgs rr pkgs_installed not_yet_installed_pkgs

  #df --sync --output=fstype,avail,pcent,target -- . | grep --invert-match ^Type # <>
  #EC=101 LN="$nL" exit # <>
  #set -x # <>

  #pause_to_check "$nL" 'Begin section on restarting processes?' # <>

:;: 'Restart any processes that may need to be restarted. Begin by getting a list of any such PIDs'
a_pids=()
get_pids_for_restarting

  #EC=101 LN="$nL" exit # <>

hash_of_installed_pkgs_B=$( rpm --all --query | sha256sum | awk '{ print $1 }' )

## TODO: change temp-vars (II, XX, etc) to fully named vars

if ! [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B}" ]] || [[ "${#a_pids[@]}" -gt 0 ]]
then
  while true
  do

    ## Note,  [[ ... = , this second test,  [[ ${a_pids[*]} = 1 ]]  is correct. This means, do not use 
    #+  ((...)) , and '=' is intended to that '1' on RHS is matched as in Pattern Matching, ie, as "PID 1."
    :;: 'if any PID\s were found... ...and if there are any PID\s other than PID 1...'
    if [[ -n ${a_pids[*]: -1:1} ]] && ! [[ ${a_pids[*]} = 1 ]]
    then
      II=0
      XX="${#a_pids[@]}"

      :;: 'Print some info and wait for it to be read'
      ## Note, '\x27' is a single quote
      printf '\n  %b for restarting, count, %d \n\n' 'PID\x27s' "${XX}"

        sleep 1 # <>

      :;: 'for each signal and for each PID...'
      for YY in "${!a_pids[@]}"
      do
        ## Note, readability
        :;: $'\x60kill\x60 '"loop $(( ++II )) of ${XX}" ;:

        ZZ="${a_pids[YY]}"
        (( ZZ == 1 )) && continue 001
        sleep 1

          #pause_to_check "$nL" '' # <>

        for AA in HUP USR1 TERM KILL
        do

            : "To kill PID $ZZ with signal $AA" # <>
            #pause_to_check "$nL" # <>

          #sleep 1
          sync --file-system

            wait -f # <>

          :;: '...if the PID is still running...'
          if ps --no-headers --quick-pid "${ZZ}"
          then

            :;: '...then \kill\ it with the according per-loop SIGNAL...'
            ## Note, the exit codes for  kill  only indicate whether or not the target PIDs existed, rather
            #+ than whether the  kill  operation succeeded, per  info kill .
            sudo -- "$(type -P kill)" --signal "${AA}" -- "${ZZ}"

            :;: '...and if the PID in question no longer exists then unset the current array index number'
            if ps --no-headers --quick-pid "${ZZ}"
            then
              is_zombie=$( ps aux | awk "\$2 ~ /${ZZ}/ { print \$8 }" )

              if [[ ${is_zombie} = 'Z' ]]
              then
                : 'Process is a zombie; unsetting'
                unset 'a_pids[YY]'
                break 00001
              else
                continue 00001
              fi
            else
              unset 'a_pids[YY]'
              break 0001
            fi
          else
            unset 'a_pids[YY]'
            break 001
          fi
        done
        unset AA
      done
      unset YY ZZ
    else
      break 1
    fi
  done
  unset II XX a_pids is_zombie
fi

  #EC=101 LN="$nL" exit # <>
  #set -x # <>

:;: 'Restart NetworkManager if necessary'

## TODO: use written function here
for BB in "${dns_srv_A}" "${dns_srv_1}"
do
  if ! ping -4qc1 -- "${BB}" > /dev/null 2>&1
  then
    sudo -- nice --adjustment=-20 -- systemctl restart -- NetworkManager.service || er_x "${nL}"
  fi
done
unset BB

# <Logs> Write to TTY and exit
#"$(type -P kill)" --signal USR2 -- "$$" # <Logs>

:;: 'Remind user of commands for the interactive shell'

popd > /dev/null || exit "${nL}"

if ! [[ ${PWD} = ${dev_d1}/${scr_repo_nm} ]]
then
  printf '\n  Now run this command: \n'
  printf '\n\t cd "%s/%s" ; git status \n\n' "${dev_d1}" "${scr_repo_nm}"
fi



:;: 'Clean up & exit'
command rm --force --recursive "${verb__[@]}" "${tmp_dir}"
printf '  %s - Done \n' "$( date +%H:%M:%S )"
EC='00' LN="$nL" exit

