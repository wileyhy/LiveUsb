#!/bin/bash
## #!/bin/env -iS bash

## Note: ...undocumented feature??
#+    Use `env -i` or else the script\s execution environment will inherit any exported anything,
#+  including and especially functions, from its caller, e.g., any locally defined functions (such as `rm`)
#+  which might be intended to supercede any of the aliases which some Linux distributions often define and
#+  provide for users\ convenience.  These exported functions which are received from the caller\s
#+  environment get printed above the script\s shebang in xtrace when xtrace and vebose are both enabled on the shebang line.
#+    ...also, using `env` messes up vim\s default bash-colorizations

## LiveUsb1

## Note, written from within a Fedora instance, see hardcoded /run/media/root
## Note, style, function definition syntax, "(){ :" makes plain xtrace easier to read
## Note, style, "! [[ -e" doesn\t show the "!" in xtrace, whereas "[[ ! -e" does, and yet, for `grep`.....
## Note, idempotent script
## Note, find, stat and [[ (and ls) don\t effect ext4 timestamps, as tested, but idempotent chown and chmod
#+  do, and of course touch does; if there\s no change in the file, rsync doesn\t, but if the file changes,
#+  it does. Also, btime on ext4 still isn\t consistent. grep has no effect on times. cp -a effects ctimes
#+  even if file contents do not change.
## TODO: add colors to xtrace comments
## Note, systed services to disable: bluetooth, cups, [ systemd-resolved ? ]; services to possibly enable: sshd, sssd

# <> Debugging
declare -nx nL=L\INENO ## <> Note, this assignment is repeated here; originally it\s located in setup_vars()
#set -x # <>
set -a # <>
set -C # <>
set -u # <>
set -T # <>
set -e # <>
set -o pipefail # <>

#function set()

declare -a qui__ verb__
if [[ -o xtrace ]]
then
  qui__=( [0]="--" )
  verb__=( [0]="--verbose" [1]="--" )
else
  qui__=( [0]="--quiet" [1]="--" )
  verb__=( [0]="--" )
fi
export qui__ verb__

umask 077
hash -r

## How to add colors to xtrace comments
color_yellow=$( tput setaf 11 )
color_reset=$( tput sgr0 )
shopt -s expand_aliases
alias .y:=': $color_yellow ; :'
alias .^:=': $color_reset ; :'

:;: "Variables likely to be manually changed with some regularity, or which absolutely must be defined early on"
# shellcheck disable=SC2034
{
  script_start_time=$( date +%H:%M:%S )
  readonly script_start_time

  scr_repo_nm="LiveUsb"
  scr_nm="LiveUsb1.sh"
  sha256_of_repo_readme="da016cc2869741834138be9f5261f14a00810822a41e366bae736bd07fd19b7c"
  readonly scr_repo_nm scr_nm sha256_of_repo_readme

  data_pttn_uuid="949f3d8c-2dbe-4356-8a6b-3389e4c016d4"
  readonly data_pttn_uuid

  fn_bndry_sh=" ~~~ ~~~ ~~~ "
  fn_bndry_lo=" ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~ "
  readonly fn_bndry_sh fn_bndry_lo
  fn_lvl=0

  alias als_function_boundary_in='local - _="${fn_bndry_lo} ${fn_bndry_sh} ${FUNCNAME[0]}() BEGINS ${fn_bndry_sh} ${fn_lvl} to $(( ++fn_lvl ))" loc_hyphn="$-" loc_exit_code="${EC:-$?}" loc_lineno="${LN:-$nL}"'
  alias als_function_boundary_out='true "${fn_bndry_lo} ${FUNCNAME[1]}()  ENDS  ${fn_bndry_sh} ${fn_lvl} to $(( --fn_lvl ))"'

  user_real_name="Wiley Young"
  user_github_email_address="84648683+wileyhy@users.noreply.github.com"
  user_github_gpg_key="E287D0CF528591CE"
  readonly user_real_name user_github_email_address user_github_gpg_key

  list_of_minimum_reqd_rpms=( [0]="ShellCheck" [1]="firewall-config" [2]="gh" [3]="git" [4]="vim-enhanced" )
  readonly list_of_minimum_reqd_rpms

  :;: "Parameters regarding required files"
  ## Note, the "indexed array," $arrays_of_conf_files , is a meta-array containing a list of names of more
  #+  "indexed arrays." The array names, $files_for_use_with_github_depth_* , each have the same format and 
  #+  are numbered sequentially are created here on one line only and have values assigned to each of them 
  #+  within the next ~50 lines. The list of index numbers is created just once, so the indices in the 
  #+  assignment section below must match the indices created here.
  arrays_of_conf_files=(
    [0]="files_for_use_with_github_depth_0"
    [1]="files_for_use_with_github_depth_1"
    [2]="files_for_use_with_github_depth_2"
    [3]="files_for_use_with_github_depth_3"
  )
  readonly arrays_of_conf_files
  unset "${arrays_of_conf_files[@]}"

  ## Bug? this is really a lot of manually entered data ...of filenames -- it\s a lot to maintain. :-\
  #+  Wouldn\t it be better to just always keep the data directory... in proper intended order...?
  #+  But then the data dir can be changed and there wouldn\t be any process of making sure the DACs
  #+  are correct. On the other hand, it\s easier to maintain a simple set of files. ...but their state
  #+  wouldn\t necessarily have been documented, which is valuable in and of itself. Otherwise, if they
  #+  were changed accidentally, how would you know any change had occurred?

  ## TODO
  #: "  Files, firefox"
  #files_for_use_with_github_depth_0+=( ~/.mozilla )

  : "  Files, gh (cli)"
  files_for_use_with_github_depth_2+=( ~/.config/gh/{config.yml,gpg-agent.conf,hosts.yml,pubring.kbx,trustdb.gpg} )
  files_for_use_with_github_depth_3+=( ~/.config/gh/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev
      ~/.config/gh/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key)


  : "  Files, gpg"
  files_for_use_with_github_depth_1+=( ~/.gnupg/{gpg-agent.conf,pubring.kbx,tofu.db,trustdb.gpg} )
  files_for_use_with_github_depth_2+=( ~/.gnupg/crls.d/DIR.txt
      ~/.gnupg/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev
      ~/.gnupg/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )

  : "  Files, ssh"
  files_for_use_with_github_depth_1+=( ~/.ssh/{id_ed25519{,.pub},known_hosts} )

  : "  Files, top"
  files_for_use_with_github_depth_2+=( ~/.config/procps/toprc )

  : "  Files, vim"
  files_for_use_with_github_depth_0+=( ~/.vimrc )
  : "  End of Files lists"

  ## TODO, I do this duck-xtrace dance a few time in this script, but the procedure isn\t normalized yet; do so
  [[ -o xtrace ]] && xon=yes && set +x
  ps_o=$( ps aux )
  readonly ps_o
  [[ ${xon:=} = yes ]] && set -x
}

:;: "Write to TTY"
printf '  %s - Executing %s \n' "${script_start_time}" "$0"

##  FUNCTION DEFINITIONS, BEGIN ##

:;: "Functions and Aliases TOC..."    ## Conf files?
  ## functions_this_script=(
  #+  "__vte_osc7()"
  #+  "__vte_prompt_command()"
  #+  "clone_repo()"
  #+  "die"
  #+  "enable_git_debug_settings()"
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
  #+  "setup_git_user_dirs()"             # y
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

#:;: "Define __vte_osc7() -- for bashrc only"
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

#:;: "Define __vte_prompt_command() -- for bashrc only"
# shellcheck disable=SC2317
#function __vte_prompt_command(){
    #local - fn_pwd
    #set -
    #fn_pwd=~
    #if ! [[ ${PWD} = ~ ]]; then
        #fn_pwd="${fn_pwd//[[:cntrl:]]}"
        #fn_pwd="${PWD/#"${HOME}"\//\~\/}"
    #fi
    #printf '\033[m\033]7;%s@%s:%s\033' "${USER}" "${HOSTNAME%%.*}" "${fn_pwd}"
    #printf '%s@%s:%s\n' "${USER}" "${HOSTNAME%%.*}" "${fn_pwd}"
    #__vte_osc7
#}

function clone_repo(){ als_function_boundary_in
  #set -x

  local hash_of_read_me_file
  hash_of_read_me_file=$( sha256sum ${scr_repo_nm}/README.md | cut -d" " -f1 )

  [[ ${PWD} = "${dev_d1}" ]] || die

  if ! [[ -d ${scr_repo_nm} ]] || ! [[ -f ${scr_repo_nm}/README.md ]] ||
      ! [[ ${hash_of_read_me_file} = "${sha256_of_repo_readme}" ]]
  then
    git clone --origin github "https://github.com/wileyhy/${scr_repo_nm}" || die
  fi
  unset hash_of_read_me_file
}

:;: "Define \"die\" alias to function error_and_exit()"
alias die='error_and_exit "${nL}"'

:;: "Define enable_git_debug_settings()"
function enable_git_debug_settings(){ als_function_boundary_in
  #set -x

  :;: "Variables -- Global git debug settings"
  GIT_TRACE=true
  GIT_CURL_VERBOSE=true
  GIT_SSH_COMMAND="ssh -vvv"
  GIT_TRACE_PACK_ACCESS=true
  GIT_TRACE_PACKET=true
  GIT_TRACE_PACKFILE=true
  GIT_TRACE_PERFORMANCE=true
  GIT_TRACE_SETUP=true
  GIT_TRACE_SHALLOW=true
  [[ -f ~/.gitconfig ]] && git config --global --list --show-origin --show-scope | cat -n
}

:;: "Define error_and_exit()"
function error_and_exit(){ als_function_boundary_in
  set -x

  ## Some positional parameters must exist
  [[ $# -lt 1 ]] && return 1

  ## The first positional parameter must be a digit, and should be the LINENO from where error_and_exit() is called
  if ! [[ $1 = [0-9]* ]]
  then
    printf '\n%s, %s, Error, first positional parameter must be a line number\n\n' "${scr_nm}" "${FUNCNAME[0]}"
    return 2
  fi

  local loc_lineno
  loc_lineno="$1"
  shift

  printf '%s, Error, line %d, %s\n' "${scr_nm}" "${loc_lineno}" "$*" >&2

  LN="${loc_lineno}" builtin exit "${loc_exit_code}"
}

:;: "Define get_pids_for_restarting()"
function get_pids_for_restarting(){ als_function_boundary_in
  #set -x

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

  readarray -t dnf_o < <( sudo -- nice --adjustment=-20 -- dnf needs-restarting 2> /dev/null || die )
  if [[ ${#dnf_o[@]} -eq 0 ]]
  then
    return 0
  fi

    declare -p dnf_o

  readarray -t pipline0 < <( printf '%s\n' "${dnf_o[@]}" | grep --invert-match --fixed-strings --regexp="/firefox/" )
  if [[ ${#pipline0[@]} -eq 0 ]]
  then
    return 0
  fi

  readarray -t pipline1 < <( printf '%s\n' "${pipline0[@]}" | awk '{ print $1 }' )
  if [[ ${#pipline1[@]} -eq 0 ]]
  then
    return 0
  fi

  readarray -t a_pids < <( printf '%s\n' "${pipline1[@]}" | grep --only-matching --extended-regexp ^"[0-9]*"$ )
  if [[ ${#a_pids[@]} -eq 0 ]]
  then
    return 0
  fi
}

:;: "Define gh_auth_login_command()"
function gh_auth_login_command(){ als_function_boundary_in 
  # set -

  if gh auth status
  then
    gh auth logout
  fi

  ## Bug, output of `gh auth login`: "! Authentication credentials saved in plain text"

  ## Note, do not break this line with any backslashed newlines or it will fail and you\ll have to
  #+  refresh auth manually; using short options for just this reason
  gh auth login -p ssh -h github.com -s admin:public_key,read:gpg_key,admin:ssh_signing_key -w || die

  ## TODO, move these git and gh commands into setup_git() and setup_gh_cli), respectively

  : "GH - Use GitHub CLI as a credential helper"
  git config --global credential.helper "cache --timeout=3600"
  gh auth setup-git --hostname github.com
}

:;: "Define increase_disk_space()"
function increase_disk_space(){ als_function_boundary_in
  #set -x

  ## Note, such as...   /usr/lib/locale /usr/share/i18n/locales /usr/share/locale /usr/share/X11/locale , etc.
  ## Note, for $dirs1 , find  syntax based on Mascheck\s
  ## Note, for $dirs2 , use of bit bucket because GVFS ‘/run/user/1000/doc’ cannot be read, even by root
  ## Note, for $fsos3 , "--and" is not POSIX compliant
  ## Note, for $fsos4 , sorts by unique inode and delimits by nulls

  ## Bug, Hardcoded path, for $dirs2 , /run/media/root is a default for mounting external media on
  #+  Fedora-like systems

  declare -A Aa_fsos5
  readarray -d "" -t dirs1 < <( find -- /  \!  -path / -prune -type d -print0 )

  readarray -d "" -t dirs2 < <(
    find -- "${dirs1[@]}" -type d -name "*locale*"  \!  -ipath "*/run/media/root/*" -print0 2> /dev/null )

  readarray -d "" -t fsos3 < <(
    find -- "${dirs2[@]}" -type f -size +$(( 2**16 ))  \(  \!  -ipath "*en_*" -a  \!  -ipath "*/.git/*"  \)  -print0 )

  if (( ${#fsos3[@]} > 0 ))
  then
    ## Note, for loop is run in a process substitution subshell, so unsetting BB is unnecessary
    readarray -d "" -t fsos4 < <( {
      for BB in "${fsos3[@]}"
      do
        printf '%s\0' "$( stat --printf='%i %n\n' -- "${BB}" )"
      done ; } |
        sort --unique |
        tr --delete '\n'
      )

    ## Question, does this assoc array Aa_fsos5 need to be declared as such? (I don\t think so, but...)

    set -- "${fsos4[@]}"

    while true
    do
      [[ -z ${1:-} ]] && break 1 # <> set-u

      # shellcheck disable=SC2190
      Aa_fsos5+=( "${1%% *}" "${1#* }")
      shift 1

      (( $# == 0 )) && break 1
    done
  fi

  : "If any larger local data files were found, then remove them interactively"
  if [[ -n ${!Aa_fsos5[*]} ]]
  then
    : "Inform user of any found FSOs"
    printf '%s, Delete these files? \n' "${scr_nm}"
    declare -p Aa_fsos5
    sleep 3

    for AA in "${!Aa_fsos5[@]}"
    do
      HH=0
      II=0
      JJ="${Aa_fsos5[$AA]#.}"
      printf '%s,   File %d, \n' "${scr_nm}" $(( ++II ))

      while true
      do
        if [[ -e ${JJ} ]]
        then
          declare ls_out
          readarray -t ls_out < <( ls -l --all --human-readable --classify --inode --directory --zero "${JJ}" )
          ## Note, "\x60" is a "grave accent"
          printf '%s, output of %bls%b, %s \n' "${scr_nm}" '\x60' '\x60' "$( realpath -e "${JJ}" )"
          printf '%s\n' "${ls_out[@]}"
          unset ls_out

          local yes_or_no
          yes_or_no=n
          read -r -p " > [yN] " -t 600 yes_or_no
          yes_or_no="${yes_or_no,,?}"

          case "${yes_or_no}" in
            0|1)  printf '  Zero and one are ambiguous, please use letters. \n'
                  continue 1
                ;; #
            y|t)  printf '  %s %b %s %s \n' "Script," ' \x60rm -i\x60 ' "requires a typed [yN] response," \
                    "it defaults to do-not-delete if a user just presses [enter]."

            if sudo -- "$( type -P rm )" --interactive --one-file-system --preserve-root=all "${verb__[@]}" "${JJ}"
                  then
                    unset "Aa_fsos5[$AA]"
                    break 1
                  else
                    die "Unknown error"
                  fi
                ;; #
            n|f)  printf '  Keeping this file. \n'
                  unset "Aa_fsos5[$AA]"
                  break 1
                ;; #
            *)    HH=$(( ++HH )) # <> set-e, can be just  (( HH++ ))  when errexit\s off

                  if (( HH < 3 ))
                  then
                    printf '  Invalid response (%d), please try again. \n' "${HH}"

                  else
                    printf '  Keeping this file. \n'
                    unset "Aa_fsos5[$AA]"
                    break 1
                  fi
                ;; #
          esac
        else
          break 0001
        fi
      done
    done
  fi
  unset dirs1 dirs2 fsos3 fsos4 Aa_fsos5 AA HH II JJ yes_or_no
}

:;: "Define min_necc_packages()"
function min_necc_packages(){ als_function_boundary_in
  #set -x

  local XX

  ## Bug? how many $a_pids arrays are there, and are they ever misused?

  #local -a a_pids

  ## Bug, command list hardcoded in multiplt places. s/b coded in just one place, ie at TOF w reqd files lists

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
}

:;: "Define must_be_root()"
function must_be_root(){ als_function_boundary_in
  #set -x

  if (( UID == 0 ))
  then
    die "Must be a regular user and use sudo"
  else
    sudo --validate || die
  fi
}

:;: "Define pause_to_check()"
## Usage,   pause_to_check "${nL}"
function pause_to_check(){ als_function_boundary_in
  #set -x
  local -I EC=101 LN="$1"

  shift
  local -a KK=( "$@" )
  local reply 

  [[ -n ${KK[*]:0:1} ]] && printf '\n%s, ${FUNCNAME[0]}(), %s\n' "${scr_nm}" "${KK[@]}" >&2
  printf '\n[Y|y|(enter)|(space)] is yes\nAnything else is { no and exit }\n' >&2

  if ! read -N1 -p $'\nReady?\n' -rst 600 reply >&2
  then
    printf '\nExiting, line %d\n\n' "${KK}" >&2
    builtin exit
  fi

  case $reply in
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
}

:;: "reqd_user_files()"
function reqd_user_files(){ als_function_boundary_in
  #set -x

  ## Note, QQ must be declared as local before unsetting it inside the function so that the `unset` will
  #+  effect the local variable

  : $'Vars: Is device identified by \x22\x24data_pttn_uuid\x22 attached to this machine? If so, get device path'
  ## Note, and yet, when locally declaring and assigning separately a regular variable, ie,
  #+  `local lsblk_out \n lsblk_out=""` the assignment doesn\t need a preceding `local`
  ## Note, I\m using an array with $lsblk_out so I can work around `set -u` by using a ":=" PE, and so that
  #+  I can limit xtrace output by testing for a shortened version of the output of `lsblk`. I.e., I\m testing
  #+  the last line of the array, index "-1", but this is really just a practice, since a lot of times index
  #+  zero gets unset for whatever reason, but if there are any values in the array at all, then index
  #+  "-1" is guaranteed to exist. ...unless the array is completely empty...
  #+	but I don\t want to UNSET ie RESET the array on each loop...
  #+ In this script, index zero should exist, barring any future changes. So, it\s a bit of future-proofing.
  
  ## TODO, with all relevant `awk` commands, change program quoting from double to single and use "--assign"
  #+  with some variable as in this next block.
  
  local pttn_device_path
  pttn_device_path=$( lsblk --noheadings --output partuuid,path | 
    awk --assign awk_var_ptn="${data_pttn_uuid}" '$1 ~ awk_var_ptn { print $2 }' 
  )
  [[ -n ${pttn_device_path} ]] || die $'Necessary USB drive isn\x60t plugged in or its filesystem has changed.'
  :
  : "Vars: get mountpoints and label"
  local -a array_mt_pts
  readarray -t array_mt_pts < <( lsblk --noheadings --output mountpoints "${pttn_device_path}" )

  local YY
  for YY in "${!array_mt_pts[@]}"
  do
    [[ -z ${array_mt_pts[YY]} ]] && unset "array_mt_pts[YY]"
  done
  unset YY

  local mount_pt data_dir is_mounted
  case "${#array_mt_pts[@]}" in
    0 )
      : "  Zero matches"
      ## Note, "plugged in and not mounted" means the LABEL would still be visible, if there is one: the USB
      #+  drive or the filesystem holding the data could change, and either change would rewrite the PARTUUID
      local pttn_label
      pttn_label=$( lsblk --noheadings --output label "${pttn_device_path}" )
      pttn_label="${pttn_label:=live_usb_tmplabel}"
      mount_pt="/run/media/root/${pttn_label}"
      data_dir="${mount_pt}/skel-LiveUsb"
      is_mounted=no
      unset pttn_label
      ;; #
    1 )
      : "  One match"
      mount_pt="${array_mt_pts[*]}"
      data_dir="${mount_pt}/skel-LiveUsb"
      is_mounted=yes
      ;; #
    * )
      : "  Multiple matches"
      die "The target partition is mounted in multiple places"
      ;; #
  esac
  unset array_mt_pts

  #: "Mountpoint must be readable via ACL"
  #: "FS mounting must be restricted to root and/or liveuser"
  #: $'FS mounting must automatically \x60umount\x60 after 15 minutes, and automatically \x60mount\x60 on 
  #+    access by authorized user'
  #: "Data directory must be readable via ACL"

  ## Q, Why is this block commented out?
  #: "Data directory must already exist"
  #if ! [[ -d ${data_dir} ]] || [[ -L ${data_dir} ]]
  #then
    #die "Data directory is missing"
  #fi

  : "Capture previous umask and set a new one"
  local prev_umask
  read -r -a prev_umask < <( umask -p )
  umask 177

  :;: "For each array of conf files and/or directories"
  local AA
  local -n QQ
  ## It isn\t strictly necessary to declare QQ as a nameref here, since unsetting QQ (see below) removes the
  #+  nameref attribute, but I intend to use QQ as a nameref, so declaring QQ without a nameref attribute
  #+  would be confusing

  for AA in "${arrays_of_conf_files[@]}"
  do
    :;: "Loop A - open" ;:

    : "Vars"
    ## Note, if I declare a local nameref, `local -n foo`, then on the next line just assign to the nameref
    #+  directly, `foo=bar`, then on the second loop `local -p QQ` prints the former value of QQ. Perhaps
    #+  the second assignment statement, ie, `foo=bar` without `local -n` is global?
    ## Note, remember, namerefs can only be unset with the -n flag to the `unset` builtin
    #unset -n QQ
    local -n QQ
    local -n QQ="${AA}"   ## good code
    #QQ="${AA}"           ## baaad code

    :;: "For each conf file or dir"
    local BB
    for BB in "${!QQ[@]}"
    do
      :;: "Loop A:1 - open" ;:

      : "Vars"
      local source_file dest_dir
      source_file="${data_dir}/${QQ[BB]#~/}"
      dest_dir="${QQ[BB]%/*}"

      :;: "If the target conf file/dir does not exist"
      if ! [[ -e ${QQ[BB]} ]]
      then

        :;: "If the source conf file/dir does not exist, then find it"
        if ! [[ -e ${source_file} ]]
        then

          : "If the partition is not mounted which holds the data directory, then mount it"
          if [[ ${is_mounted} = no ]]
          then

            : "Mountpoint must exist"
            if ! [[ -d ${mount_pt} ]]
            then
              sudo -- mkdir --parents -- "${mount_pt}" || die
            fi

            sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || die

            if mount | grep -q "${pttn_device_path}"
            then
              is_mounted=yes
            fi
          fi

          :;: "If the source conf file/dir still does not exist, then throw an error"
          if ! sudo -- [ -e "${source_file}" ]
          then
            die "${QQ[BB]}" "${source_file}"
          fi
        fi

        rsync_install_if_missing  "${source_file}" "${dest_dir}"

      fi
      unset source_file dest_dir
      :;: "Loop A:1 - shut" ;:
    done
    :;: "Loops A:1 - complete" ;:

    unset BB
    unset -n QQ
    :;: "Loop A - shut" ;:
  done

  unset AA
  unset mount_pt data_dir is_mounted
  unset pttn_device_path
  :;: "Loops A - complete" ;:

  : "Restore previous umask"
  builtin "${prev_umask[@]}"
  unset prev_umask

    #EC=101 LN="${nL}" exit # <>
}

:;: "Define rsync_install_if_missing()"
function rsync_install_if_missing(){ als_function_boundary_in
  #set -x

  local fn_target_dir fn_umask fn_source_var
  fn_source_var="$1"
  fn_target_dir="$2"

  if [[ -e ${fn_target_dir} ]]
  then
    if ! [[ -d ${fn_target_dir} ]]
    then
      die "${fn_target_dir}"
    fi
  else
    read -r -a fn_umask < <( umask -p )
    umask 077
    mkdir --parents "${verb__[@]}" "${fn_target_dir}"
    builtin "${fn_umask[@]}"
    unset fn_umask
  fi

  ## Bug, variable $data_dir is defined in a different function

  if ! [[ -e ${fn_target_dir}/${fn_source_var#*"${data_dir}"/} ]]
  then
    sudo -- rsync --archive --checksum -- "${fn_source_var}" "${fn_target_dir}" || die "${fn_target_dir}"
  fi
  unset fn_source_var fn_target_dir
}

:;: "Define setup_bashrc()"
function setup_bashrc(){ als_function_boundary_in
  set -x

  :;: "  bashrc -- Do some backups"
  files_for_use_with_bash=( /root/.bashrc ~/.bashrc )

  for WW in "${files_for_use_with_bash[@]}"
  do
    : "  bashrc -- RC File must exist"
    if ! sudo -- [ -f "${WW}" ]
    then
      die "${WW}"
    fi

    ## Bug: chmod changes the ctime, even with no change of DAC\s

    : "  bashrc -- ...of the array files_for_use_with_bash"
    if ! sudo -- [ -e "${WW}.orig" ]
    then
      sudo -- rsync --archive --checksum "${verb__[@]}" "${WW}" "${WW}.orig"
      sudo -- chmod 400 "${verb__[@]}" "${WW}.orig"

      ## Adding attr changes ctime once; removing attr changes ctime every time
      sudo -- chattr +i -- "${WW}.orig"
    fi

    : "  bashrc -- ...per-script-execution file backup"
    sudo -- rsync --archive --checksum "${verb__[@]}" "${WW}" "${WW}~" || die "${WW}"
  done
  unset WW

  :;: "  bashrc -- Env parameters for bashrc"

  :;: "  bashrc -- PS0 -- Assign color code and duck xtrace"
  ## Note,  set [-|-x] , letting xtrace expand this  tput  command alters all xtrace colorization
  if [[ -o xtrace ]]
  then
    set -
    PS0=$( tput setaf 43 )
    set -x
  else
    PS0=$( tput setaf 43 )
  fi

  :;: "  bashrc -- PROMPT_COMMAND -- Variables dependency -- level 1 --"
  pc_regx="not found"$
  prompt_colors_reset=$( tput sgr0 )

  ## TODO, append some additional definitions into bashrc
  #+    man(){ "$( type -P man )" --nh --nj "$@"; }
  #+    export TMOUT=15

  : "  bashrc -- PROMPT_COMMAND -- Variables dependency -- level 2 --"
  prompt_cmd_0='printf "%b" "${prompt_colors_reset}"'

  : "  bashrc -- PROMPT_COMMAND -- Variables dependency -- level 3 --"
  ## Note, PROMPT_COMMAND could have been inherited as a string variable
  unset PROMPT_COMMAND
  declare -a PROMPT_COMMAND
  
  ## Bug? shouldn't this array $PROMPT_COMMAND have as value index 0 the variable $prompt_cmd_0 ?
  #PROMPT_COMMAND=([0]="printf \"%b\" \"\${prompt_colors_reset}\"")
  PROMPT_COMMAND=( [0]="${prompt_cmd_0}" )

  if ! [[ "$( declare -pF __vte_prompt_command 2>&1 )" =~ ${pc_regx} ]]
  then
    PROMPT_COMMAND+=( __vte_prompt_command )
  fi

  : "  bashrc -- Other parameters"
  PS1="[\\u@\\h]\\\$ "
  BROWSER=$( command -v firefox )
  EDITOR=$( command -v vim )

  :;: "  bashrc -- Append user variables and functions into .bashrc."
  ## Note, these arrays include some command substitutions which depend on some function definitions, which in
  #+  turn must be defined prior to defining these arrays

  :;: "  bashrc -- Define lists of parameters to be appended into bashrc"
  ## Note, there are multiple lists for variables due to layers of dependencies. Later in the process,
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

  :;: "  bashrc -- Variables"
  missing_vars_and_fns=()

  : "Note, test for whether the reqd variables are defined in the script#s current execution environment"
  for QQ in "${vars_for_bashrc_1[@]}" "${vars_for_bashrc_2[@]}" "${vars_for_bashrc_3[@]}"
  do
    if [[ $( declare -p "${QQ}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${QQ}" )
    fi
  done
  unset QQ

  :;: "  bashrc -- Functions"
  for UU in "${fcns_for_bashrc_1[@]}"
  do
    if [[ $( declare -pF "${UU}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${UU}" )
    fi
  done
  unset UU

  :;: "  bashrc -- Test for any missing parameters"
  if (( ${#missing_vars_and_fns[@]} > 0 ))
  then
    die, "${missing_vars_and_fns[@]}"
  fi

  :;: "  bashrc -- Create Associative arrays of required parameters"

  : "  bashrc -- Define Aa_bashrc_strngs_*"
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

  : "  bashrc -- Variables"
  ## Note, three temp vars are used here because of the correspondence of numbers, ie, 1 and 1, 2 and 2, etc
  #+  between the names of the respective indexed and associative arrays. In effect, this is the clearest and
  #+  shortest way to write it in bash (5.2), for the intended purpose, to the best of my knowledge.
  local XX YY ZZ
  for XX in "${vars_for_bashrc_1[@]}"; do Aa_bashrc_strngs_V1+=( ["define parameter ${XX}"]=$( declare -p "${XX}" ) ); done
  for YY in "${vars_for_bashrc_2[@]}"; do Aa_bashrc_strngs_V2+=( ["define parameter ${YY}"]=$( declare -p "${YY}" ) ); done
  for ZZ in "${vars_for_bashrc_3[@]}"; do Aa_bashrc_strngs_V3+=( ["define parameter ${ZZ}"]=$( declare -p "${ZZ}" ) ); done
  unset XX YY ZZ

  : "  bashrc -- Functions (a.k.a. \"subroutines\")"
  local AA
  for AA in "${fcns_for_bashrc_1[@]}"
  do
    Aa_bashrc_strngs_F1+=( ["define subroutine ${AA}"]="function $( declare -pf "${AA}" )" )
  done
  unset AA

  :;: "  bashrc -- Write functions and variable definitions into bashrc files"
  local KK
  for KK in "${!bashrc_Assoc_arrays[@]}"
  do
    write_bashrc_strings "${bashrc_Assoc_arrays[$KK]}"
  done
  unset KK

  :;: "  bashrc -- Clean up"
  unset pc_regx prompt_cmd_0
  unset files_for_use_with_bash
  unset -f write_bashrc_strings
  unset "${bashrc_Assoc_arrays[@]}"
  unset bashrc_Assoc_arrays
}

## Bug, setup_dnf is too long and too complicated

:;: "Define setup_dnf()"
function setup_dnf(){ als_function_boundary_in
  #set -x

  ## Bug, there should be a n\eeds-restarting loop between each install/upgrade
  ## Bug, the --security upgrade should be done rpm by rpm

    : "Beginning section on DNF" # <>

  ## Note, CUPS cannot be safely removed; too many dependencies
  ## Note, For some unknown reason, even when  dnf  doesn\t change any programs,  dnf
  #+  needs-restarting  decides it needs to restart all available Firefox processes, which crashes all of
  #+  my tabs.  (Bug?)  So, I\m adding in a few  rpm -qa | wc -l s to only run  dnf
  #+  needs-restarting  in the event that any files on disk may actually have been changed.
  ## Note, these PE\s (for_admin, for_bash, etc.) have been tested and should "disappear" by virtue of
  #+  whichever expansion does that, leaving just the regular strings as the elements of the array
  ## Note, this brace grouping (all together of for_admin, for_bash, etc.) is so that "shellcheck disable" will
  #+  apply to the entire block

  hash_of_installed_pkgs_A=$( rpm --all --query | sha256sum | awk '{ print $1 }' )

  ## Removals for disk space
  pkg_nms_for_removal=( google-noto-sans-cjk-vf-fonts mint-x-icons mint-y-icons transmission )

  ## Removals for security
  #pkg_nms_for_removal+=( blueman bluez )

  ## Bug: xfce4-terminal -- hardcoded WM

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
    # addl_pkgs+=( ${for_critical_N:=}    audit{,-libs} python3-audit )
      addl_pkgs+=( ${for_critical_O:=}    sysstat )

    # addl_pkgs+=( ${for_careful_A:=}     systemd )
    # addl_pkgs+=( ${for_careful_B:=}     sssd{,-{ad,client,common{,-pac},ipa,kcm,krb5{,-common},ldap,nfs-idmap,proxy}} )
    # addl_pkgs+=( ${for_db_ish:=}        libreoffice-calc )
    # addl_pkgs+=( ${for_bug_rpts:=}      inxi zsh dash mksh lynx )
    # addl_pkgs+=( ${for_char_sets:=}     enca moreutils uchardet )
      addl_pkgs+=( ${for_duh:=}           info plocate )
    # addl_pkgs+=( ${for_duh:=}           pdfgrep wdiff )
      addl_pkgs+=( ${for_firefox:=}       mozilla-noscript mozilla-privacy-badger mozilla-https-everywhere )
      addl_pkgs+=( ${for_fs_maint:=}      bleachbit python3-psutil )
    # addl_pkgs+=( ${for_fs_maint:=}      stacer )
    # addl_pkgs+=( ${for_fun:=}           supertuxkart )
    # addl_pkgs+=( ${for_gcov:=}          gcc )
      addl_pkgs+=( ${for_git:=}           git gh )
    # addl_pkgs+=( ${for_internet:=}      chromium lynx )
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

  :;: "Start with removing any unnecessary RPMs"

  if [[ -n ${pkg_nms_for_removal:0:8} ]]
  then
    ## Note, this  printf  command uses nulls so that  -e  and  %s...  will be read as separate indices
    #+  by  readarray
    readarray -d "" -t grep_args < <( printf -- '-e\0%s.*\0' "${pkg_nms_for_removal[@]}" )
    readarray -t removable_pkgs < <(
      rpm --all --query | grep --ignore-case --extended-regexp "${grep_args[@]}" )

    :;: "Keep a list, just in case an rpm removal accidentally erases something vital"
    if [[ -n ${removable_pkgs[*]:0:8} ]]
    then
      for QQ in "${!removable_pkgs[@]}"
      do
        ## Note,  dnf , do not use [-y|--yes] with this particular command
        if sudo -- nice --adjustment=-20 -- dnf --allowerasing remove -- "${removable_pkgs[QQ]}"
        then
          unset "removable_pkgs[QQ]"
        else
          die "${removable_pkgs[QQ]}"
        fi
      done
      unset QQ
    fi
  fi

  :;: "Then do a blanket security upgrade"

  ## Note, the problem with this "blanket security upgrade" is how it includes kernel and firmware. Better to
  #+  capture list of rpms in a no-op cmd, filter out impractical (for a LiveUsb) rpms, then upgrade the rest
  #+  one by one

  ## Run this loop until `dnf --security upgrade` returns 0, or 0 upgradable, rpms
  while true
  do

    ## Bug: extra grep - sb wi same awk cmd

    ## Get full list of rpms to upgrade, in an array; exit on non-zero
    readarray -d "" -t pkgs_for_upgrade < <(
      sudo -- dnf --assumeno --security upgrade 2>/dev/null |
        awk '$2 ~ /x86_64|noarch/ { printf "%s\0", $1 }' |
        grep -vE ^replacing$
      )

    ## remove all  kernel  and  firmware  rpms from $pkgs_for_upgrade array
    for HH in "${!pkgs_for_upgrade[@]}"
    do
      if [[ ${pkgs_for_upgrade[HH]} =~ kernel|firmware ]]
      then
        unset_reason+=( [HH]="${BASH_REMATCH[*]}" )
        unset "pkgs_for_upgrade[HH]"
      fi
    done
    unset HH

    ## If count of upgradeable rpms is 0, then break loop
    if [[ ${#pkgs_for_upgrade[@]} -eq 0 ]]
    then
      break
    fi

    ## Upgrade the RPM\s one at a time
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

    ## Run `dnf needs-restarting`, collecting PID/commandline pairs
    #a_pids=()
    get_pids_for_restarting

      declare -p a_pids
      #exit 101

    ## Send signals to "needs-restarting" PID\s, one at a time, with pauses and descriptions between each
    #+  one, so I can see which signal/process combinations cause any problems. This would be a great job
    #+  for logging.

  done

  #pause_to_check "${nL}" $'Which packages in the \x24addl_pkgs array are already installed?' # <>

  :;: "Find out whether an RPM is installed, one by one"
  for UU in "${!addl_pkgs[@]}"
  do
    if sudo -- nice --adjustment=-20 -- rpm --query --quiet -- "${addl_pkgs[UU]}"
    then
      pkgs_installed+=( "${addl_pkgs[UU]}" )
      unset "addl_pkgs[UU]"
    fi
  done
  unset UU

    #pause_to_check "${nL}" $'Upgrade any pre-intstalled packages from the \x24addl_pkgs array' # <>

  ## Bug, this section should upgrade rpms one by one

  :;: "Upgrade any installed RPMs from the main list, en masse"
  if [[ -n ${pkgs_installed[*]: -1:1} ]]
  then
    sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet upgrade -- "${pkgs_installed[@]}" || die
  fi

    #pause_to_check "${nL}" $'From the \x24addl_pkgs array, install the remainder' # <>

  :;: "Install any as yet uninstalled RPMs from the main list as necessary"
  not_yet_installed_pkgs=( "${addl_pkgs[@]}" )

  if [[ -n ${not_yet_installed_pkgs[*]: -1:1} ]]
  then
    ## Note, if you install multiple rpms at the same time, and one of them causes some error, then you have
    #+  no immediate way of knowing which one caused the error

    for VV in "${not_yet_installed_pkgs[@]}"
    do
      sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet install -- "${VV}" || die

      #a_pids=()
      get_pids_for_restarting

      if [[ -n ${a_pids[*]:0:1} ]]
      then

        for WW in "${a_pids[@]}"
        do
            echo '"${WW}":' "${WW}"

          ## TODO, re awk
          ps aux | awk --assign 'CC=${WW}' '$2 ~ CC { print }'

          #pause_to_check "${nL}" "Execute a lengthy \x60kill --timeout...\x60 command?"

          local EE
          sleep 1
          readarray -d '' -t EE < <( cat "/proc/${WW}/cmdline" )
          pgrep -f "${EE[*]}" >/dev/null || continue

          sudo -- nice --adjustment=-20 -- "$(type -P kill)" --verbose \
            --timeout 1000 HUP \
            --timeout 1000 USR1 \
            --timeout 1000 TERM \
            --timeout 1000 KILL -- "${WW}"

          unset EE
          sleep 3

          ## TODO, re awk
          ps aux | awk "\$2 ~ /${WW}/ { print }"
          ps aux | awk --assign 'DD=${WW}' '$2 ~ DD { print }'

          #pause_to_check "${nL}" "Now do you need to manually restart anything?"

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

    #EC=101 LN="${nL}" exit # <>
    #pause_to_check "${nL}" "Begin section on restarting processes?" # <>

  :;: "Restart any processes that may need to be restarted. Begin by getting a list of any such PIDs"
  #a_pids=()
  get_pids_for_restarting

    #EC=101 LN="${nL}" exit # <>

  hash_of_installed_pkgs_B=$( rpm --all --query | sha256sum | awk '{ print $1 }' )

  ## TODO: change temp-vars (II, XX, etc) to fully named vars

  if ! [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B}" ]] || [[ ${#a_pids[@]} -gt 0 ]]
  then
    while true
    do

      ## Note,  [[ ... = , this second test,  [[ ${a_pids[*]} = 1 ]]  is correct. This means, do not use
      #+  ((...)) , and "=" is intended to that "1" on RHS is matched as in Pattern Matching, ie, as "PID 1."
      :;: $'if any PID\x60s were found... ...and if there are any PID\x60s other than PID 1...'
      if [[ -n ${a_pids[*]: -1:1} ]] && ! [[ ${a_pids[*]} = 1 ]]
      then
        II=0
        XX="${#a_pids[@]}"

        :;: "Print some info and wait for it to be read"
        ## Note, "\x60" is a grace accent used as a single quote
        printf '\n  %b for restarting, count, %d \n\n' 'PID\x60s' "${XX}"

          sleep 1 # <>

        :;: "for each signal and for each PID..."
        for YY in "${!a_pids[@]}"
        do
          ## Note, readability
          :;: $'\x60kill\x60'" loop $(( ++II )) of ${XX}" ;:

          ZZ="${a_pids[YY]}"
          (( ZZ == 1 )) && continue 001
          sleep 1

            #pause_to_check "${nL}" "" # <>

          for AA in HUP USR1 TERM KILL
          do

              : "To kill PID $ZZ with signal ${AA}" # <>
              #pause_to_check "${nL}" # <>

            #sleep 1
            sync --file-system

              wait -f # <>

            :;: "...if the PID is still running..."
            if ps --no-headers --quick-pid "${ZZ}"
            then
              :;: "Evidently, I need to give the system a little time for processing"
              sleep 1

              :;: $'...then \x60kill\x60 it with the according per-loop SIGNAL...'
              ## Note, the exit codes for  kill  only indicate whether or not the target PIDs existed, rather
              #+ than whether the  kill  operation succeeded, per  info kill .
              sudo -- "$( type -P kill )" --signal "${AA}" -- "${ZZ}"

              :;: "Evidently, I need to give the system a little MORE time for processing"
              sleep 1

              :;: "...and if the PID in question no longer exists then unset the current array index number"
              if [[ -n "$( ps --no-headers --quick-pid "${ZZ}" | grep -v defunct )" ]]
              then
                ## TODO, re awk
                is_pid_a_zombie=$( ps aux | awk "\$2 ~ /${ZZ}/ { print \$8 }" )

                if [[ ${is_pid_a_zombie} = Z ]]
                then
                  : "Process is a zombie; unsetting"
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
}

:;: "Define setup_gh_cli()"
function setup_gh_cli(){ als_function_boundary_in
  #set -x

  local -A github_configs
  local gh_config_list_out
  github_configs=( [editor]=vim [browser]=firefox [pager]=less [git_protocol]=ssh )
  gh_config_list_out=$( gh config list | tr '\n' \  )

  for KK in "${!github_configs[@]}"
  do
    if ! [[ ${gh_config_list_out} =~ "${KK}=${github_configs[$KK]}" ]]
    then
      gh config set "${KK}" "${github_configs[$KK]}"
    fi
  done
  unset KK
  unset gh_config_list_out github_configs

    wait -f # <>
    hash -r

  ## Bug, `gh auth status` is executed too many (ie, 3) times. Both the checkmarks and the exit code are used

    #gh auth status ## <>

  :;: "GH -- Login to github"
  ## Note, this command actually works as desired: neither pipefail nor the ERR trap are triggered
  printf -v count_gh_auth_checkmarks "%s" "$( gh auth status |& grep --count $'\xe2\x9c\x93' )"

  if ! gh auth status 2>/dev/null 1>&2 || [[ ${count_gh_auth_checkmarks} -ne 4 ]]
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

  :;: "GH -- Get SSH & GPG keys"
  for QQ in ssh-key gpg-key
  do
    if ! gh "${QQ}" list > /dev/null 2>&1
    then
      gh_auth_login_command
    fi
  done
  unset QQ
}

:;: "Define setup_git()"
function setup_git(){ als_function_boundary_in
  #set -x

  ## Note: git ui colors: normal black red green yellow blue magenta cyan white
  #+  git ui attributes: bold dim ul (underline blink reverse)
  ## Note: In vim, since "expandtab" is set in .vimrc, to make some actual tabs, press Ctrl-v-[tab]

  ## Bug? in vim, when quoting "EOF", $tmp_dir changes color, but bash still expands the redirection
  #+ destination file.

  :;: "Git -- parameters, dependency level 1"
  local git_conf_global_f git_config_sys_conf_file git_ignr git_mesg
  git_conf_global_f=~/.gitconfig
  git_config_sys_conf_file=/etc/gitconfig
  git_ignr=~/.gitignore
  git_mesg=~/.gitmessage

  : "  Paramters with globs"
  ## Note, use of globs. The RE pattern must match all of the patterns in the array assignments
  local git_files_a git_regexp
  git_files_a=( /etc/git* /etc/.git* ~/.git* )
  git_regexp="git*"

  :;: "Git -- parameters, dependency level 2"
  if [[ -f ${git_conf_global_f} ]]
  then
    local git_cnf_glob_list
    readarray -t git_cnf_glob_list < <( git config --global --list )
  fi

  local -A git_keys
  git_keys=(
    [color.diff]=always
    [color.diff.meta]="blue black bold"
    [color.interactive]=always
    [color.ui]=true
    [commit.gpgsign]=true
    [commit.template]="${git_mesg}"
    [core.editor]=vim
    [core.excludesfile]="${git_ignr}"
    [core.pager]="$( type -P less )"
    [gpg.program]="$( type -P gpg2 )"
    [help.autocorrect]=prompt
    [init.defaultBranch]=main
    [user.email]="${user_github_email_address}"
    [user.name]="${user_real_name}"
    [user.signingkey]="${user_github_gpg_key}"
  )

  :;: "Git -- Files must exist and Permissions"
  read -r -a prev_umask < <( umask -p )
  umask 133

  : "  Remove any unmatched glob patterns"
  local ZZ

  for ZZ in "${!git_files_a[@]}"
  do
    if [[ ${git_files_a[ZZ]} =~ "${git_regexp}" ]]
    then
      unset "git_files_a[ZZ]"
    fi
  done
  unset ZZ git_regexp

  :;: $'Git -- Create files and set DAC\x60s as necessary - Loop B' ;:
  local AA
  for AA in "${git_files_a[@]}"
  do
    :;: "  Loop B - open" ;:
    sudo -- [ -e "${AA}" ] || sudo -- touch "${AA}"
    sudo -- chmod 0644 "${verb__[@]}" "${AA}"
    :;: "  Loop B - shut" ;:
  done
  unset AA
  :;: "  Loops B - complete" ;:

  builtin "${prev_umask[@]}"

  :;: "Git -- remove a particular configuration key/value pair if present"
  if printf '%s\n' "${git_cnf_glob_list[@]}" | grep gpg.format "${qui__[@]}"
  then
    git config --global --unset gpg.format
  fi

  :;: "Git -- setup configuration - Loop C" ;:
  local BB
  for BB in "${!git_keys[@]}"
  do
    :;: "  Loop C - open" ;:

      : "BB:$BB" # <>

    if ! grep -e "${BB#*.} = ${git_keys[$BB]}" "${qui__[@]}" "${git_conf_global_f}"
    then
      git config --global "${BB}" "${git_keys[$BB]}"
    fi
    :;: "  Loop C - shut" ;:
  done
  unset BB
  :;: "  Loops C - complete" ;:

  :;: "Git -- gitmessage (global)"
  if ! [[ -f ${git_mesg} ]]
  then
    :;: "  Heredoc: gitmessage"
    cat <<- "EOF" > "${tmp_dir}/msg"
		Subject line (try to keep under 50 characters)

		Multi-line description of commit,
		feel free to be detailed.

		[Ticket: X]

		EOF

    # shellcheck disable=SC2024 #(info): sudo does not affect redirects. Use sudo cat file | ..
    tee -- "${git_mesg}" < "${tmp_dir}/msg" > /dev/null || die
    chmod 0644 "${verb__[@]}" "${git_mesg}" || die
  fi

  :;: "Git -- gitignore (global)"
  if ! [[ -f ${git_ignr} ]] || ! grep swp "${qui__[@]}" "${git_ignr}"
  then
    :;: "  Heredoc: gitignore"
    cat <<- \EOF > "${tmp_dir}/ign"
		*~
		.*.swp
		.DS_Store

		EOF

    # shellcheck disable=SC2024
    tee -- "${git_ignr}" < "${tmp_dir}/ign" > /dev/null || die
    chmod 0644 "${verb__[@]}" "${git_ignr}" || die
  fi

  :;: $'Git -- Set correct DAC\x60s (ownership and permissions)'
  local HH
  for HH in "${git_mesg}" "${git_ignr}"
  do
    if ! [[ "$( stat -c%u "${HH}" )" = "${login_uid}" ]] || ! [[ "$( stat -c%g "${HH}" )" = "${login_gid}" ]]
    then
      sudo -- chown "${login_uid}:${login_gid}" "${verb__[@]}" "${HH}"
    fi

    if ! [[ "$( stat -c%a "${HH}" )" = 0400 ]]
    then
      chmod 0400 "${verb__[@]}" "${HH}"
    fi
  done
  unset HH

  ## Clean up after section "Git"
  unset git_files_a git_config_sys_conf_file git_conf_global_f git_mesg git_ignr git_keys
}

:;: "setup_gpg()"
function setup_gpg(){ als_function_boundary_in
  #set -x

  :;: "If any files in ~/.gnupg are not owned by either USER or root, then error out and exit"
  local -a problem_files
  problem_files=()
  readarray -d "" -t problem_files < <(
    sudo -- \
      find -- ~/.gnupg -xdev \
        \( \
          \(  \!  -uid "${login_gid}" -a  \! -gid 0  \) -o \
          \(  \!  -gid "${login_uid}" -a  \! -uid 0  \) \
        \)  -print0 \
  )
  [[ -n ${problem_files[*]} ]] && die Incorrect ownership on -- "${problem_files[@]}"
  unset problem_files

  :;: $'If any files are owned by root, then change their ownership to \x24USER'
  sudo -- \
    find -- ~/.gnupg -xdev \( -uid 0 -o -gid 0 \) -execdir \
      chown "${login_uid}:${login_gid}" "${verb__[@]}" \{\} \; ||
        die

  :;: $'If any dir perms aren\x60t 700 or any file perms aren\x60t 600, then make them so'
  find -- ~/.gnupg -xdev -type d \! -perm 700  -execdir chmod 700 "${verb__[@]}" \{\} \; #
  find -- ~/.gnupg -xdev -type f \! -perm 600  -execdir chmod 600 "${verb__[@]}" \{\} \; #

  : "GPG -- If a gpg-agent daemon is running, or not, then, either way say so"
  if grep --extended-regexp "[g]pg-a.*daemon" "${qui__[@]}" <<< "${ps_o}"
  then
    printf '\n\tgpg-agent daemon IS RUNNING\n\n'

    ## Why was this command in here???
    #gpgconf --kill "${verb__[@]}" gpg-agent

  else
    printf '\n\tgpg-agent daemon is NOT running\n\n'
  fi

  ## Why was this command in here???
  #gpg-connect-agent "${verb__[@]}" /bye

  GPG_TTY=$( tty )
  export GPG_TTY
}

:;: "Define setup_network()"
function setup_network(){ als_function_boundary_in
  #set -x

  dns_srv_1=8.8.8.8
  dns_srv_A=75.75.75.75
  readonly dns_srv_1 dns_srv_A

  if ! test_dns "${dns_srv_1}" || ! test_dns "${dns_srv_A}"
  then
    printf '\n%s, Attempting to connect to the internet... \n\n' "$scr_nm"

    : "Try to get NetworkManager up and running"
    sudo -- nice --adjustment=-20 -- systemctl start -- NetworkManager.service
    wait -f

    : "Turn on networking"
    sudo -- nmcli n on

    : "Turn on WiFi"
    sudo -- nmcli r wifi on

    : "Get interface name(s)"
    readarray -d "" -t ifaces < <( nmcli --terse c |
      awk --field-separator : '$1 !~ /lo/ { printf "%s\0", $1 }' )

    : "Connect the interface"
    case "${#ifaces[@]}" in
      0 )
        die "No network device available"
        ;; #
      1 )
        nmcli c up "${ifaces[*]}"
        sleep 5
        ;; #
      * )
        die "Multiple network devices available"
        ;; #
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
}

:;: "Define setup_ssh()"
function setup_ssh(){ als_function_boundary_in
  # set -

  ## Bug - security, these #chown# commands should operate on the files while they are still in skel_LiveUsb
  #+  see also similar code in setup_gpg(), possibly elsewhere also  :-\

  ## Bug, chown changes ctime on every execution, whether or not the ownership changes

  :;: $'Make sure the SSH config dir for USER exists and has correct DAC\x60s'
  local ssh_usr_conf_dir
  ssh_usr_conf_dir=~/.ssh/

  if [[ -d ${ssh_usr_conf_dir} ]]
  then
    sudo -- \
      find -- "${ssh_usr_conf_dir}" -xdev  \(  \! -uid "${login_uid}"  -o  \! -gid "${login_gid}"  \) \
        -execdir  chown -- "${login_uid}:${login_gid}" "${verb__[@]}" \{\} \;  ||
          die
    find -- "${ssh_usr_conf_dir}" -xdev -type d -execdir chmod 700 "${verb__[@]}" \{\} \; #
    find -- "${ssh_usr_conf_dir}" -xdev -type f -execdir chmod 600 "${verb__[@]}" \{\} \; #
  else
    die
  fi
  unset ssh_usr_conf_dir

  :;: $'Make sure the SSH config file for USER exists and has correct DAC\x60s'
  local ssh_user_conf_file
  ssh_user_conf_file=~/.ssh/config

  if [[ -f ${ssh_user_conf_file} ]]
  then
    if ! grep "ForwardAgent yes" "${qui__[@]}" "${ssh_user_conf_file}"
    then
      "$( type -P rm )" --force --one-file-system --preserve-root=all "${verb__[@]}" "${ssh_user_conf_file}"
      write_ssh_conf
    fi
  else
    write_ssh_conf
  fi
  unset ssh_user_conf_file
  unset -f write_ssh_conf

  ## Bug? not necc to restart ssh-agent if both of these vars exist?

    #declare -p SSH_AUTH_SOCK SSH_AGENT_PID

  : "Make sure ssh daemon is running (?)"
  if [[ -z ${SSH_AUTH_SOCK:-} ]] || [[ -z ${SSH_AGENT_PID:-} ]]
  then

    ## Bug, window manager is hard coded, "startxfce4"

    :;: "Get the PID of any running SSH Agents -- there may be more than one"
    local -a ssh_agent_pids
    readarray -t ssh_agent_pids < <( ps h -C 'ssh-agent -s' -o pid | tr -d ' ' )

    if [[ -z ${ssh_agent_pids[@]} ]]
    then
      :;: $'If there aren\x60t any SSH Agents running, then start one'
      #ssh-agent -s

      :;: "Try again to get the PID of the SSH Agent"
      local awk_o
      awk_o=$( awk '$0 ~ /ssh-agent/ && $0 !~ /exec -l/ && $0 !~ /grep / && $0 !~ /man / { print $2 }' <<< "${ps_o}" )
      readarray -t ssh_agent_pids <<< "${awk_o[@]}"
      unset awk_o
    else
      case "${#ssh_agent_pids[@]}" in
        1 ) 
            if [[ -z ${SSH_AGENT_PID:-} ]]
            then
              SSH_AGENT_PID="${ssh_agent_pids[*]}"

                declare -p SSH_AGENT_PID
            fi
          ;; #
        * )
            die "More than one ssh-agent is running -- ${ssh_agent_pids[*]}"
          ;; #
      esac
    fi

    ## Bug? `command -p kill "$AA"` executes the bash builtin, judging by the output of `command -p kill`
    #+  without any operands. The output of `$( type -P kill )"` without operands is the same as the output
    #+  of /usr/bin/kill without operands. The documentation is ...somewhat unclear on these points.
    #+    `help command`: "Runs COMMAND with ARGS suppressing shell function lookup...." It seems that what
    #+  is intended is, "...suppressing shell function lookup, but still allowing builtins to be executed,"
    #+  and possibly also aliases and keywords, though I haven\t tested those. The description of the "-p"
    #+  option is particularly misleading: "use a default value for PATH that is guaranteed to find all of
    #+  the standard utilities." That "guarantee" sounds as if use of the "-p" option "shall" (using the
    #+  POSIX defition of the word) result in a binary utility being used, when actually that is not the case.
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

    if [[ ${#ssh_agent_pids[@]} -gt 0 ]]
    then
      case "${#ssh_agent_pids[@]}" in

        ## Bug, the branches of this if-fi block are either kill the current agent, or kill the current agent

        1 )
            if [[ -n ${SSH_AGENT_PID:-} ]]
            then
              : okay

                echo SSH Agent exists
                declare -p SSH_AGENT_PID

            else
              : warning: SSH_AGENT_PID does not exist
            fi
          ;; #
        * )
            #for VV in "${ssh_agent_pids[@]}"
            #do
              #"$( type -P kill )" "${verb__[@]}" "${VV}"
            #done
            #unset VV

            die "More than one ssh-agent is running -- ${ssh_agent_pids[*]}"

            ## Note:  ssh-agent -s  is "generate Bourne shell commands on stdout."
            ssh_agent_o=$( ssh-agent -s )
            eval "${ssh_agent_o}"
          ;; #
      esac
    fi

    ## Bug? hardcoded filename

    ## https://stackoverflow.com/questions/10032461/git-keeps-asking-me-for-my-ssh-key-passphrase
    ssh_agent_o=$( ssh-agent -s )
    eval "${ssh_agent_o}"
    
    ## Note:  ssh-add  and  ssh  don\t have long options.  ssh-add -L  is "list;"  ssh -T  is "disable
    #+  pseudo-terminal allocation."
    ssh-add -v
    ssh-add -L -v
    #ssh -T git@github.com ## Note, returns exit code 1; why is this command here exectly?
  fi
}

:;: "setup_temp_dirs()"
function setup_temp_dirs(){ als_function_boundary_in
  #set -x

  tmp_dir=$( TMPDIR="" mktemp --directory --suffix=-LiveUsb 2>&1 || die )
  [[ -d ${tmp_dir} ]] || die
  readonly tmp_dir
}

:;: "Define setup_time()"
function setup_time(){ als_function_boundary_in
  #set -x

  sudo -- timedatectl set-local-rtc 0
  sudo -- timedatectl set-timezone America/Vancouver
  sudo -- nice --adjustment=-20 -- systemctl start chronyd.service || die
  sudo -- chronyc makestep > /dev/null
}

:;: "Define setup_git_user_dirs()"
function setup_git_user_dirs(){ als_function_boundary_in
  #set -x

  ## Note: in order to clone into any repo, and keep multiple repos separate,  cd  is required, or  pushd  /
  #+   popd

  :;: "Variables -- global, for use for entire script"
  dev_d1=~/MYPROJECTS
  dev_d2=~/OTHERSPROJECTS
  readonly dev_d1
  readonly dev_d2

  :;: "Make dirs"
  local UU
  for UU in "${dev_d1}" "${dev_d2}"
  do
    if ! [[ -d ${UU} ]]
    then
      mkdir --mode=0700 "${verb__[@]}" "${UU}" || die
    fi
  done
  unset UU

  :;: "Change dirs"
  pushd "${dev_d1}" > /dev/null || die
}

:;: "Define setup_vars()"
function setup_vars(){ als_function_boundary_in
  #set -x

  :;: "Vars, dirs, etc"
  ## Bug, only way to export namerefs?  `declare -nx nL=...`

  :;: "Vars... -- Error handling, variables and functions"
  ## Note, variable assignments, backslash escape bc  sed -i
  # shellcheck disable=SC1001
  local -gnx nL=L\INENO

  :;: "Vars... -- PATH"
  PATH="/usr/bin:/usr/sbin"
  export PATH

  :;: "Vars... -- Other environment variables"
  ## Note, Initialize some env vars found in sourced files, as a workaround for nounset
  ## Note, local style, inline comments, ie, ": foo ## Note, blah", are useful for rebutting false positives
  #+  from ShellCheck
  LC_ALL=""
  PS1=""

  ## Note, ps(1), "The real group ID identifies the group of the user who created the process" and "The
  #+  effective group ID describes the group whose file access permissions are used by the process"
  #+ See output of:  `ps ax -o euid,ruid,egid,rgid,pid,ppid,stat,cmd | awk '$1 !~ $2 || $3 !~ $4'`
  ## Note, sudo(1), "SUDO_UID: Set to the user-ID of the user who invoked sudo."
  if [[ -z ${login_uid:=} ]]; then login_uid=$( id -u "$( logname )" ); fi
  if [[ -z ${login_gid:=} ]]; then login_gid=$( id -g "$( logname )" ); fi
  saved_SUDO_UID=$( sudo printenv SUDO_UID )
  saved_SUDO_GID=$( sudo printenv SUDO_GID )

  # shellcheck disable=SC2034
  local -g BASHRCSOURCED USER_LS_COLORS ## Note, /etc/bashrc and /etc/profile.d/colorls.*sh on Fedora 38
}

:;: "Define setup_vim()"
function setup_vim(){ als_function_boundary_in
  #set -x

  : "Heredoc of vim-conf-text"
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
  readarray -d "" -t arr_vrc < <( sudo -- find -- /root -name "*vimrc*" -print0 )

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
        die
      ;; #
  esac

  if (( "${#arr_vrc[@]}" == 1 ))
  then
    read -r WW XX < <( sudo -- sha256sum -- "${tmp_dir}/vim-conf-text" 2>&1 )
    read -r YY XX < <( sudo -- sha256sum -- "${strng_vrc}" 2>&1 )
    unset      XX
  else
    sudo -- touch -- "${strng_vrc}" # <> set-e
  fi

  : "Write .vimrc"
  if (( ${#arr_vrc[@]} == 0 )) || ! [[ ${WW} = "${YY}" ]]
  then
    : $'Test returned \x22true,\x22 the number didn\x60t match, so write to .vimrc'

    : "Set the umask"
    read -ra umask_prior < <( umask -p )
    umask 177

    : "Write the root file"
    sudo -- rsync --archive --checksum -- "${tmp_dir}/vim-conf-text" "${strng_vrc}" || die

    : "Copy the root file to "~"${USER}"$' and repair DAC\x60s on '"${USER}"$'\x60s copy'
    sudo -- rsync --archive --checksum -- "${strng_vrc}" ~/.vimrc || die
    sudo -- chown "${UID}:${UID}" -- ~/.vimrc
    chmod 0400 -- ~/.vimrc

    : "Reset the umask"
    builtin "${umask_prior[@]}"
  fi
  unset arr_vrc strng_vrc WW YY umask_prior
}

:;: "Define test_dns()"
function test_dns(){ als_function_boundary_in
  #set -x

  sudo -- ping -c 1 -W 15 -- "$1" > /dev/null 2>&1
  return "$?"
}

:;: "Define test_os()"
function test_os(){ als_function_boundary_in
  #set -x

  local kern_rel
  kern_rel=$( uname --kernel-release )

  ## Note, test of $kern_rel is a test for whether the OS is Fedora (ie, "fc38" or "Fedora Core 38")
  if ! [[ ${kern_rel} =~ \.fc[0-9]{2}\. ]]
  then
    die "OS is not Fedora"
  fi
}

:;: "Define trap_err()"
function trap_err(){ als_function_boundary_in
  #set -x

  declare -p BASH BASH_ALIASES BASH_ARGC BASH_ARGV BASH_ARGV0 BASH_CMDS BASH_COMMAND BASH_LINENO
  declare -p BASH_REMATCH BASH_SOURCE BASH_SUBSHELL BASHOPTS BASHPID DIRSTACK EUID FUNCNAME HISTCMD IFS
  declare -p LC_ALL LINENO PATH PIPESTATUS PPID PWD SHELL SHELLOPTS SHLVL UID
  declare -p err_trap_hyphn err_trap_ec err_trap_undersc
}

## Bug, these var assignments $loc_exit_code and $lineno only fail when they\re on line number >=2
#+  of  trap  "args section" ??

:;: "Define trap_exit()"
## Note: these variable assignments must be on the 1st line of the funtion in order to capture correct data
# shellcheck disable=SC2317
function trap_exit(){ als_function_boundary_in
  set -x

  trap - EXIT

  #if [[ ${loc_exit_code} = 00 ]]
  #then
    #: "End of script, line ${lineno}"
  #else
    #: "End of EXIT trap"
  #fi

  builtin exit "${loc_exit_code}"
}

:;: "Define trap_return()"
function trap_return(){ :
  local -
  set -x
  als_function_boundary_out
}

:;: "Define write_bashrc_strings()"
function write_bashrc_strings(){ als_function_boundary_in
  #set -x

  :;: "Certain parameters must be defined and have non-zero values"
  (( ${#files_for_use_with_bash[@]} == 0 )) && die
  (( $# == 0 ))                             && die

  local JJ file_x Aa_index Aa_element
  local -n fn_nameref

  for JJ
  do
    :;: "Loop D - For each set of strings to append into bashrc" ;:

    unset -n fn_nameref
    local -n fn_nameref="$JJ"

    for file_x in "${files_for_use_with_bash[@]}"
    do
      :;: "Loop D:1 - For each .bashrc" ;:

      : "file_x, ${file_x}"

      for Aa_index in "${!fn_nameref[@]}"
      do
        :;: "Loop D:1:a - For each definition (function or parameter)" ;:

        : "Aa_index, ${Aa_index}"
        Aa_element="${fn_nameref[${Aa_index}]}"

        :;: "(1) If the definition is not yet written into the file..."
        if ! sudo -- grep --quiet --fixed-strings "## ${Aa_index}" -- "${file_x}"
        then

          : "Then write the function definition into the file"
          printf '\n## %s \n%s \n' "${Aa_index}" "${Aa_element}" |
            sudo -- tee --append -- "${file_x}" > /dev/null || die
        else
          : "Definition exists, skipping"
        fi

        ## Bug: what if it\s a multiline alias?

        ## Question, can `sed` take variable assignments the way `awk` can?

        :;: "(2) If there is an alias by the same name, then delete it from the bashrc file at hand..."
        sudo -- sed --in-place "/^alias ${Aa_index##* }=/d" -- "${file_x}"

        :;: "Loop D:1:a - shut" ;:
      done
      unset Aa_element
      :;: "Loops D:1:a - complete" ;:

      :;: "For each file, if absent add a newline at EOF"
      if sudo -- tail --lines 1 -- "${file_x}" | grep --quiet --extended-regexp "[[:graph:]]"
      then
        printf '\n' | sudo -- tee --append -- "${file_x}" > /dev/null
      fi

      :;: "Loop D:1 - shut" ;:
    done
    :;: "Loops D:1 - complete" ;:

    :;: "Reset for the next loop, assuming there is one"
    ## Note, ?? use  unset  so that values from previous loops will not interfere with the current loop
    shift

    :;: "Loop D - shut" ;:
  done
  unset JJ
  :;: "Loops D - complete" ;:
}

## TODO, look at how each conf file is defined and written, each one's a little different. Make them 
#+  uniform with each other, since the purpose of each section is the same in each case.

function write_ssh_conf(){ als_function_boundary_in
  #set -x

  cat <<- \EOF > "${ssh_user_conf_file}"
	Host github.com
	ForwardAgent yes

	EOF
}

#######  FUNCTION DEFINITIONS COMPLETE #######

  #EC=101 LN="${nL}" exit # <>
  #set -x

:;: "Define trap on RETURN"
trap trap_return RETURN

:;: "Define trap on ERR"
trap trap_err ERR

:;: "Define trap on EXIT"
trap trap_exit EXIT

  #EC=101 LN="${nL}" exit # <>
  #set -x

:;: "Test OS"
test_os

  #EC=101 LN="${nL}" exit # <>
  #set -x

:;: "Variables"
setup_vars

  #EC=101 LN="${nL}" exit # <>
  #set -x
  #die testing

:;: "<Logs>"
#set -x
#logf="${tmp_dir}/log.${scr_nm}.${script_start_time}.txt"
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}"
#exec > >( tee "${logf}" ) 2>&1

## Note, traps
# EXIT -- for exiting
# HUP USR1 TERM KILL -- for restarting processes
# INT QUIT USR2 -- for stopping logging

:;: "Regular users with sudo, only"
must_be_root

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Certain files must have been installed from off-disk"
reqd_user_files

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Network"
setup_network

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Time"
setup_time

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Temporary directory"
setup_temp_dirs

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Vim"
setup_vim

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Minimum necessary rpms"
min_necc_packages

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Bash"
setup_bashrc

  #EC=101 LN="${nL}" exit
  set -x

## Bug, all of the OS changes should be completed BEFORE setting up the dev environment

:;: "Increase disk space"
increase_disk_space

  #EC=101 LN="${nL}" exit
  set -x

#:;: "<Logs>"
#set -x # <Logs>
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}" # <Logs>
#exec 3>&1 4>&2 # <Logs>
#trap "trap - INT QUIT USR2; exec 2>&4 1>&3" INT QUIT USR2 # <Logs>
#exec 1> "${logf}" 2>&1 # <Logs>

#:;: "<Logs>"
#printf '\n%s, beginning logging to file, %s\n' "${scr_nm}" "${logf}" # <Logs>
#set -x # <Logs>
#exec > >( tee "${logf}" ) 2>&1 ## this works. however, there aren\t any colors.
#exec > >( tee --append "${logf}" ) ##
#exec 2> >( GREP_COLORS="mt=01;33" grep --color=always -Ee ".*" | tee --append "${logf}" ) ## Buggy

:;: "Dnf"
setup_dnf

  EC=101 LN="${nL}" exit # <>
  set -x

:;: "Restart NetworkManager if necessary"

## TODO: use written function here
for BB in "${dns_srv_A}" "${dns_srv_1}"
do
  if ! ping -4qc1 -- "${BB}" > /dev/null 2>&1
  then
    sudo -- nice --adjustment=-20 -- systemctl restart -- NetworkManager.service || die
  fi
done
unset BB

# <Logs> Write to TTY and exit
#"$( type -P kill )" --signal USR2 -- "$$" # <Logs>

:;: "SSH"
setup_ssh

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "GPG"
setup_gpg

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Make and change into directories"
setup_git_user_dirs

  #EC=101 LN="${nL}" exit # <>
  set -x

#:;: "Git debug settings"
#enable_git_debug_settings

:;: "Git"
setup_git

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "GH -- github CLI configuration"
setup_gh_cli

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Clone repo"
clone_repo

  #EC=101 LN="${nL}" exit # <>
  set -x

:;: "Remind user of commands for the interactive shell"

popd > /dev/null || die

if ! [[ ${PWD} = ${dev_d1}/${scr_repo_nm} ]]
then
  printf '\n  Now run this command: \n'
  printf '\n\t cd "%s/%s" ; git status \n\n' "${dev_d1}" "${scr_repo_nm}"
fi

  set -v ## <>

:;: "Clean up & exit"
#"$( type -P rm )" --force --one-file-system --preserve-root=all --recursive "${verb__[@]}" "${tmp_dir}"
printf '  %s - Done \n' "$( date +%H:%M:%S )"
EC=00 LN="${nL}" exit

