#!/bin/bash
#!/bin/env -iS bash

## LiveUsb1
#+ version 1.2

#! Note, Putting a \LN=$nameref_Lineno\, ie, LINENO or
#!   \main_lineno=$nameref_Lineno\ assignment preceding an \exit\
#!   command lets the value of LN or main_lineno match the line number
#!   of the \exit\ command.
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
#!   \cp -a\ effects times even if file contents do not change.
#!
#! Reportable bug?
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
#!   indicates that intention  :-\ .
#!
#! ToDo, lock file, bc [Ctrl-Z].
#! ToDo, systemd services to disable, bluetooth, cups,
#!   [ systemd-resolved ? ].
#! ToDo, systemd services to possibly enable, sshd, sssd.

  #set -x #<>


## Get & print script start time.
unset     script_start_time
		script_start_time=$( date +%H:%M:%S )
readonly  script_start_time

## Print script start time
printf '%s - Executing %s \n' "${script_start_time}" "$0"

## Set up non-debug shell options.
hash -r
umask 077

# Variables.
scr_nm=LiveUsb1.sh
prev_cmd_exit_code=0
export scr_nm prev_cmd_exit_code



##
:;:;: "Line ${LINENO}, Define \Fn_error_and_exit_"
function _Fn_error_and_exit_ (){

    #local - && set -x #<>

  local local_lineno
        local_lineno=$1
  shift

  ## A line number must be a positional parameters
  if [[ ${local_lineno} != +([[:digit:]]) ]]
  then
    echo need arg lineno
    builtin exit "${LINENO}"
  fi

  printf '%s, Error, line %d, %s\n' "${scr_nm}" "${local_lineno}" "$*" >&2

  [[ ${prev_cmd_exit_code} = 0 ]] && prev_cmd_exit_code=01

    exti_code=${prev_cmd_exit_code}
    LN=${local_lineno} builtin exit "${exti_code}"
}

  #_Fn_error_and_exit_ "${LINENO}" #<>
  #exit "${LINENO}" #<>
  #set -x #<>


## Enable debugging.
:;:;: " Line ${LINENO}, Define \Fn_enable_debug_parameters_ "
function _Fn_enable_debug_parameters_ (){

  ## Set up debug shell options.
  local -

  # shellcheck disable=SC1001
  #! Note, this assignment is repeated here; originally it\s located
  #!   in \Fn_setup_vars_.
  unset       nameref_Lineno
  unset -n    nameref_Lineno
  local -gnx  nameref_Lineno=LINENO
  # shellcheck disable=SC2218
  {
    builtin set -o allexport
    builtin set -o noclobber
    builtin set -o nounset
    builtin set -o functrace
    builtin set -o errexit
    builtin set -o pipefail
  }
}
_Fn_enable_debug_parameters_

  #exit "${LINENO}" #<>
  #set -x #<>



##  Function name
#+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+  _Fn_enable_git_debug_settings_
#+  _Fn_pause_to_check_
#+  _Fn_verbose_flags_


##
:;:;: " Line ${LINENO}, Define \Fn_enable_git_debug_settings_ "
function _Fn_enable_git_debug_settings_ (){

    :;:;: " Variables -- Global git debug settings "
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
}
#_Fn_enable_git_debug_settings_

  #exit "${LINENO}" #<>
  #set -x #<>


##
:;:;: " Line ${LINENO}, Define \Fn_pause_to_check_ "
## Usage,   \Fn_pause_to_check_ ${nameref_Lineno}
function _Fn_pause_to_check_ (){

    local - && set -

    ## Q, Why inherit attributes and values when you assign values anyway?
    local -I exti_code=101

    local -a KK=( "$@" )
    local reply

    [[ -n ${KK[*]:0:1} ]] &&
        printf '\n%s, %s, %s\n' "${scr_nm}" "${FUNCNAME[0]}" "${KK[@]}" >&2
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
}
#_Fn_pause_to_check_

  #exit "${LINENO}" #<>
  set -x #<>


##
:;:;: " Line ${LINENO}, Define \Fn_verbose_flags_ "
function _Fn_verbose_flags_ (){
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
}
_Fn_verbose_flags_ #<>

    #echo mv "${ver__[@]}" foo bar
    #exit "${LINENO}" #<>
    set -x #<>




  :;:;: " Line ${nameref_Lineno}, Variables ...likely to change or" \
      "early-definition required "

  :;:;: " Line ${nameref_Lineno}, Variables, Error handling "
  ## Bug, only way to export namerefs?  \declare -nx nameref_Lineno=...\
  ## Note, variable assignments, backslash escape bc  sed -i
  # shellcheck disable=SC1001
  declare -nx nameref_Lineno=L\INENO

  :;:;: " Line ${nameref_Lineno}, Variables, PATH "
  PATH='/usr/bin:/usr/sbin'
  export PATH

  :;:;: " Line ${nameref_Lineno}, Variables, Other environment variables "
  ## Note, Initialize some env vars found in sourced files, as a workaround for nounset
  ## Note, local style, inline comments, ie, \: foo ## Note, blah\, are useful for
  #+  rebutting false positives from ShellCheck
  LC_ALL=""
  PS1=""

  ## Note, /etc/bashrc and /etc/profile.d/colorls.*sh on Fedora 38
  # shellcheck disable=SC2034
  declare BASHRCSOURCED USER_LS_COLORS

  :;:;: " Line ${nameref_Lineno}, Variables, Login UID and GID "
  ## Note, ps.1, \The real group ID identifies the group of the user who created
  #+   the process\ and \The effective group ID describes the group whose file
  #+   access permissions are used by the process\. See output of,
  #+   \ps ax -o euid,ruid,egid,rgid,pid,ppid,stat,cmd | awk \$1 !~ $2 || $3 !~ $4\\
  ## Note, sudo.1, \SUDO_UID: Set to the user-ID of the user who invoked sudo.\
  if [[ -z ${login_uid:=} ]]
  then
    login_uid=$( id -u "$( logname )" )
  fi

  if [[ -z ${login_gid:=} ]]
  then
    login_gid=$( id -g "$( logname )" )
  fi

  # shellcheck disable=SC2034
  {
    :;:;: " Line ${nameref_Lineno}, Variables, Script metadata "
    global_hyphn=$-
    export global_hyphn

    :;:;: " Line ${nameref_Lineno}, Variables, Repo info "
    script__repo_name=LiveUsb
    scr_nm=LiveUsb1.sh
    datadir_basenm=skel-LiveUsb
    datdir_idfile=.${script__repo_name}_id-key
    readonly script__repo_name scr_nm datadir_basenm datdir_idfile

    :;:;: " Line ${nameref_Lineno}, Variables, File and partition data and metadata "
    sha256_of_repo_readme=67e18b59ecd9140079503836e2dda1315b8799395b8da67693479b3d970f0a1
    data_pttn_uuid=7fcfd195-01
    data_dir_id_sha256=7542c27ad7c381b059009e2b321155b8ea498cf77daaba8c6d186d6a0e356280
    readonly sha256_of_repo_readme data_pttn_uuid data_dir_id_sha256

    :;:;: " Line ${nameref_Lineno}, Variables, User info "
    user_real_name="Wiley Young"
    user_github_email_address=84648683+wileyhy@users.noreply.github.com
    #user_github_gpg_key=0C83679F385F55F914D25A21CD85D53BBCB172C2
    user_github_gpg_key=DB8DF41D08E5E156D02C3BC114588FBF5B11D84C
    readonly user_real_name user_github_email_address user_github_gpg_key

    :;:;: " Line ${nameref_Lineno}, Variables, Required RPM\s "
      list_of_minimum_reqd_rpms+=( [0]="ShellCheck"
                                   [1]="firewall-config"
                                   [2]="geany"
                                   [3]="gh"
                                   [4]="git"
                                   [5]="vim-enhanced" )
    readonly list_of_minimum_reqd_rpms

    :;:;: " Line ${nameref_Lineno}, Files, Required files lists "

    ## Note, the \indexed array,\ $arrays_of_conf_files , is a meta-array containing
    #+   a list of names of more \indexed arrays.\ The array names,
    #+   $files_for_use_with_github_depth_* , each have the same format and are
    #+   numbered sequentially are created here on one line only and have values
    #+   assigned to each of them within the next ~50 lines. The list of index
    #+   numbers is created just once, so the indices in the assignment section
    #+   below must match the indices created here.
      arrays_of_conf_files+=( [0]="files_for_use_with_github_depth_0"
                              [1]="files_for_use_with_github_depth_1"
                              [2]="files_for_use_with_github_depth_2"
                              [3]="files_for_use_with_github_depth_3" )
    readonly arrays_of_conf_files

    :;:;: Unset each value of the array
    unset "${arrays_of_conf_files[@]}"

    ## Note, this is really a lot of manually entered data ...of filenames -- it\s
    #+   a lot to maintain. :-\ Wouldn\t it be better to just always keep the data
    #+   directory... in proper intended order...? But then the data dir can be
    #+   changed and there wouldn\t be any process of making sure the DACs are
    #+   correct. On the other hand, it\s easier to maintain a simple s\et of
    #+   files. ...but their state wouldn\t necessarily have been documented, which
    #+   is valuable in and of itself. Otherwise, if they were changed accidentally,
    #+   how would you know any change had occurred?
    ## ToDo
    #:
    #: "  Line ${nameref_Lineno}, Files, firefox"
    #files_for_use_with_github_depth_0+=( ~/.mozilla )

    :;:;: " Line ${nameref_Lineno}, Files, gh (cli) "
    files_for_use_with_github_depth_2+=(
        ~/.config/gh/{config.yml,gpg-agent.conf,hosts.yml,pubring.kbx,trustdb.gpg} )
    files_for_use_with_github_depth_3+=(
        ~/.config/gh/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev )
    files_for_use_with_github_depth_3+=(
        ~/.config/gh/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )

    :;:;: " Line ${nameref_Lineno}, Files, gpg "
    files_for_use_with_github_depth_1+=(
        ~/.gnupg/{gpg-agent.conf,pubring.kbx,tofu.db,trustdb.gpg} )
    files_for_use_with_github_depth_2+=( ~/.gnupg/crls.d/DIR.txt )
    files_for_use_with_github_depth_2+=(
        ~/.gnupg/openpgp-revocs.d/421C6CBB253AED9D0390ABE7E287D0CF528591CE.rev )
    files_for_use_with_github_depth_2+=(
        ~/.gnupg/private-keys-v1.d/58C9C0ACBE45778C05DE9623560AC4465D8C46C8.key )

    :;:;: " Line ${nameref_Lineno}, Files, ssh "
    files_for_use_with_github_depth_1+=( ~/.ssh/{id_ed25519{,.pub},known_hosts} )

    :;:;: " Line ${nameref_Lineno}, Files, top "
    files_for_use_with_github_depth_2+=( ~/.config/procps/toprc )

    :;:;: " Line ${nameref_Lineno}, Files, vim "
    files_for_use_with_github_depth_0+=( ~/.vimrc )
    :;:;: "   End of Files lists "

  }


##
: " Line ${nameref_Lineno}, Functions TOC "

  ##  Function name
  #+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #+  \Fn_clone_repo_
  #+  # \Fn_error_and_exit_
  #+  \Fn_get_pids_for_restarting_
  #+  \Fn_gh_auth_login_command_
  #+  \Fn_increase_disk_space_
  #+  \Fn_min_necc_packages_
  #+  \Fn_must_be_root_
  #+  \Fn_reqd_user_files_
  #+  \Fn_rsync_install_if_missing_
  #+  \Fn_setup_bashrc_
  #+  \Fn_setup_dnf_
  #+  \Fn_setup_gh_cli_
  #+  \Fn_setup_git_
  #+  \Fn_setup_gti_user_dirs_
  #+  \\F_setup_gpg_
  #+  \Fn_setup_network_
  #+  \Fn_setup_ssh_
  #+  \Fn_setup_systemd_
  #+  \\F_setup_temp_dirs_
  #+  \Fn_setup_time_
  #+  \Fn_setup_vim_
  #+  \Fn_test_dns_
  #+  \\F_test_os_
  #+  \Fn_trap_err_
  #+  \Fn_trap_exit_
  #+  \Fn_trap_return_
  #+  \Fn_write_bashrc_strings_
  #+  \Fn_write_ssh_conf_


##
: " Line ${nameref_Lineno}, Define \Fn_clone_repo_ "
function _Fn_clone_repo_ (){ #

  [[ ${PWD} = "${local_dir_1}" ]] #|| _Fn_error_and_exit_ "${LINENO}"

  local AA
    AA=$(
        sha256sum "${local_dir_1}/${script__repo_name}/README.md" \
            | cut --delimiter=" " --fields=1
        )

  if     ! [[ -d ./${script__repo_name} ]] \
      || ! [[ -f ./${script__repo_name}/README.md ]] \
      || ! [[ ${AA} == "${sha256_of_repo_readme}" ]]
  then
    git clone --origin github "https://github.com/wileyhy/${script__repo_name}" || _Fn_error_and_exit_ "${LINENO}"
  fi
  unset AA
  #
}


## ToDo: add a \get_distro\ function


##
#: " Line ${nameref_Lineno}, Define \Fn_get_pids_for_restarting_ "
: " Line ${LINENO}, Define \Fn_get_pids_for_restarting_ "
function _Fn_get_pids_for_restarting_ (){

  # shellcheck disable=SC2034
  local dnf_o
  local pipline0 pipline1
  local -ga a_pids
  a_pids=( )

  ## Note, this pipeline was broken out into its constituent commands in order to
  #+   verify the values mid-stream. Yes, some of the array names are in fact
  #+   spelled uncorrectly.

  ## Note, this s\et of arrays could be a function, but \return\ can only return
  #+   from one function level at at time, or it could be a loop, but the array
  #+   names and command strings would have to be in an associative array, and
  #+   that seems like adding complexity.

  ## ToDo, implement some improved commands,
  #+  dnf --assumeno --security upgrade 2>/dev/null | grep -e ^'Install ' -e ^'Upgrade '
  #+  dnf --assumeno --bugfix upgrade 2>/dev/null | grep -e ^'Install ' -e ^'Upgrade '
  #+  for II in 7656 11807 17897 72230; do ps_o=$( ps aux ); printf '\n%s\n' "$( grep -Ee "\<${II}\>" <<< "${ps_o}" )"; /bin/kill -s HUP "${II}"; sleep 2; done


  readarray -t dnf_o < <(
    sudo -- nice --adjustment=-20 -- dnf needs-restarting 2> /dev/null || _Fn_error_and_exit_ "${LINENO}"
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

}

    #builtin exit "${LINENO}"
    #builtin set -x

##
: " Line ${nameref_Lineno}, Define \Fn_gh_auth_login_command_ "
function _Fn_gh_auth_login_command_ (){

  if gh auth status >/dev/null 2>&1
  then
    gh auth logout
  fi

  ## Bug, output of \gh auth login\: \! Authentication credentials saved in
  #+   plain text\

  ## Note, do not break this line with any backslashed newlines or it will fail
  #+   and you\ll have to refresh auth manually; using short options for just
  #+   this reason
  gh auth login \
      -p ssh \
      -h github.com \
      -s admin:public_key,read:gpg_key,admin:ssh_signing_key \
      -w || {
    _Fn_error_and_exit_ "${LINENO}"
  }

}


##
: " Line ${nameref_Lineno}, Define \Fn_increase_disk_space_ "
function _Fn_increase_disk_space_ (){
  builtin set -x # []

  ## Note, such as...   /usr/lib/locale /usr/share/i18n/locales /usr/share/locale
  #+   /usr/share/X11/locale , etc.
  ## Note, for $dirs1 , find syntax based on Mascheck\s
  ## Note, for $dirs2 , use of bit bucket because GVFS ‘/run/user/1000/doc’ cannot
  #+   be read, even by root
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
    ## Note, for loop is run in a process substitution subshell, so unsetting BB
    #+   is unnecessary
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

    ## Question, does this assoc array Aa_fsos5 need to be declared as such? (I
    #+   don\t think so, but...)

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

  :;:;: " If any larger local data files were found, then remove them" \
      "interactively "
  if [[ -n ${!Aa_fsos5[*]} ]]
  then
    :;:;: " Inform user of any found FSOs "
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
                    _Fn_error_and_exit_ "Unknown error" "${LINENO}"
                  fi
                ;; #
            n | f )
                  printf '  Keeping this file. \n'
                  unset "Aa_fsos5[${AA}]"
                  break 1
                ;; #
            * )   HH=$(( ++HH )) #<> s\et-e, can be just ((HH++)) when errexit\s off

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

}


##
: " Line ${nameref_Lineno}, Define \Fn_min_necc_packages_ "
function _Fn_min_necc_packages_ (){

  local XX

  ## Question? how many $a_pids arrays are there, and are they ever misused?

  for XX in "${list_of_minimum_reqd_rpms[@]}"
  do
    if ! rpm --query --quiet "${XX}"
    then
      sudo -- dnf --assumeyes install "${XX}"

      ## ToDo, comment out this use of $a_pids, re declaring and unsetting
      _Fn_get_pids_for_restarting_

    fi
  done
  unset XX

}


##
: " Line ${nameref_Lineno}, Define \Fn_must_be_root_ "
function _Fn_must_be_root_ (){

  if (( UID == 0 ))
  then
    _Fn_error_and_exit_ "Must be a regular user and use sudo" "${LINENO}"
  elif sudo --validate
  then
    : validation succeeded
  else
    : validation failed
    _Fn_error_and_exit_ "${LINENO}"
  fi

}

  #builtin set -x #<>


##
: " Line ${nameref_Lineno}, Define \Fn_reqd_user_files_ "
function _Fn_reqd_user_files_ (){


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

  :;:;: $'Vars, Is device identified by \x22\x24data_pttn_uuid\x22' 'attached to this machine? If so, get device path'
  local pttn_device_path
  pttn_device_path=$( lsblk --noheadings --output partuuid,path | awk --assign awk_var_ptn="${data_pttn_uuid}" '$1 ~ awk_var_ptn { print $2 }')

  #! Note, error
  [[ -n ${pttn_device_path} ]] || _Fn_error_and_exit_ $'Necessary USB drive isn\x27t plugged in or its filesystem has changed.' "${LINENO}"

  :;:;: " Line ${nameref_Lineno}, Vars, get mountpoints and label "
  local mount_pt data_dir is_mounted
  local -a array_mt_pts
  readarray -t array_mt_pts < <( lsblk --noheadings --output mountpoints "${pttn_device_path}")

  local YY
  for YY in "${!array_mt_pts[@]}"
  do
    [[ -z ${array_mt_pts[YY]} ]] && unset "array_mt_pts[YY]"
  done
  unset YY

  case "${#array_mt_pts[@]}" in
    0 )
      :;:;: " Line ${nameref_Lineno}, Zero matches "
      ## Note, \plugged in and not mounted\ means the LABEL would still be visible,
      #+   if there is one, the USB drive or the filesystem holding the data could
      #+   change, and either change would rewrite the PARTUUID
      local pttn_label
      pttn_label=$( lsblk --noheadings --output label "${pttn_device_path}")
      pttn_label=${pttn_label:=live_usb_tmplabel}
      mount_base__fedora=/run/media/root
      mount_pt=${mount_base__fedora}/${pttn_label}
      data_dir=${mount_pt}/${datadir_basenm}
      is_mounted=no
      unset pttn_label
      ;; #
    1 )
      :;:;: " Line ${nameref_Lineno}, One match "
      mount_pt=${array_mt_pts[*]}
      data_dir=${mount_pt}/${datadir_basenm}
      is_mounted=yes
      ;; #
    * )
      :;:;: " Line ${nameref_Lineno}, Multiple matches "
      _Fn_error_and_exit_ "The target partition is mounted in multiple places" "${LINENO}"
      ;; #
  esac
  unset array_mt_pts

  :;:;: " Line ${nameref_Lineno}, FS mounting must be restricted to root and/or liveuser" ""
  local mount_user
  mount_user=${mount_pt%/*} mount_user=${mount_user##*/}
  [[ ${mount_user} = @(root|liveuser) ]] || _Fn_error_and_exit_ "${LINENO}"
  unset mount_user

  :;:;: " Line ${nameref_Lineno}, USB drive must be mounted "
  if [[ ${is_mounted} = "no" ]]
  then
    if ! [[ -d "${mount_pt}" ]]
    then
      sudo -- mkdir --parents -- "${mount_pt}" || _Fn_error_and_exit_ "${LINENO}"
    fi

    sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || _Fn_error_and_exit_ "${LINENO}"
    is_mounted=yes
    sync -f
  fi

  :;:;: $'FS mounting must auto- \x60umount\x60 after some time, and auto-' $'\x60mount\x60 on access'
  if  mount | grep -Fe "${pttn_device_path}" | grep -q timeout
  then
    sudo -- mount -o remount,x-systemd.idle.timeout=10,nosuid,noexec,dev,nouser,ro -- "${pttn_device_path}"
    sync -f
  fi

  :;:;: " Line ${nameref_Lineno}, Directories from mount-username directory to mount point must" "be readable via ACL, but not writeable "
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${mount_pt%/*}"
  sudo -- setfacl --remove-all --remove-default -- "${mount_pt}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${mount_pt}"

  :;:;: " Line ${nameref_Lineno}, Data directory must already exist "
  if  ! [[ -d ${data_dir} ]] || [[ -L ${data_dir} ]]
  then
    _Fn_error_and_exit_ "${LINENO}"
  fi

  :;:;: " Line ${nameref_Lineno}, Data directory must be readable via ACL, but not writeable" ""
  sudo -- setfacl --remove-all --remove-default --recursive --physical -- "${data_dir}"
  sudo -- setfacl --modify="u:${LOGNAME}:rx" -- "${data_dir}"
  sudo -- find "${data_dir}" -type d -execdir setfacl --modify="u:${LOGNAME}:rx" --recursive --physical '{}' \; #
  sudo -- find "${data_dir}" -type f -execdir setfacl --modify="u:${LOGNAME}:r" '{}' \; #

  :;:;: " Line ${nameref_Lineno}, Data directory verification info must be correct "
  local ZZ
  ZZ=$( sudo -- sha256sum -b "${data_dir}/${datdir_idfile}" | grep -o "${data_dir_id_sha256}")

  if  ! [[ -f ${data_dir}/${datdir_idfile} ]] || [[ -L ${data_dir}/${datdir_idfile} ]]
  then
    _Fn_error_and_exit_ "${LINENO}"
  fi

  if ! [[ ${ZZ} = "${data_dir_id_sha256}" ]]
  then
    _Fn_error_and_exit_ "${LINENO}"
  fi
  unset ZZ

  :;:;: " Line ${nameref_Lineno}, Capture previous umask and s\et a new one "
  local prev_umask
  read -r -a prev_umask < <( umask -p)
  umask 177

  :;:;: " Line ${nameref_Lineno}, For each array of conf files and/or directories "
  local AA
  local -n QQ
  ## Note, It isn\t strictly necessary to declare QQ as a nameref here, since
  #+   unsetting QQ (see below) removes the nameref attribute, but I intend to
  #+   use QQ as a nameref, so declaring QQ without a nameref attribute would be
  #+   confusing

  for AA in "${arrays_of_conf_files[@]}"
  do
    #: Loop A - open

    :;:;: " Line ${nameref_Lineno}, Vars "
    ## Note, if I declare a local nameref, \local -n foo\, then on the next line
    #+   just assign to the nameref directly, \foo=bar\, then on the second loop
    #+   \local -p QQ\ prints the former value of QQ. Perhaps the second
    #+   assignment statement, ie, \foo=bar\ without \local -n\ is global?
    ## Note, remember, namerefs can only be unset with the -n flag to the \unset\
    #+   builtin
    #unset -n QQ
    local -n QQ
    local -n QQ=${AA}   ## good code

    :;:;: " Line ${nameref_Lineno}, For each conf file or dir "
    local BB

    :;:;: " Line ${nameref_Lineno}, If the target conf file/dir does not exist "
    for BB in "${!QQ[@]}"
    do
      #: Loop A:1 - open
      if ! [[ -e ${QQ[BB]} ]]
      then

        :;:;: " Line ${nameref_Lineno}, Vars "
        local source_file
        source_file=${data_dir}/${QQ[BB]#~/}

        :;:;: " Line ${nameref_Lineno}, If the source conf file/dir does not exist, then" "find it "
        if ! [[ -e ${source_file} ]]
        then

          :;:;: " Line ${nameref_Lineno}, If the partition is not mounted which holds the data" "directory, then mount it "
          if [[ ${is_mounted} = no ]]
          then

            sudo -- mount -- "${pttn_device_path}" "${mount_pt}" || _Fn_error_and_exit_ "${LINENO}"

            if  mount | grep -q "${pttn_device_path}"
            then
              is_mounted=yes
            fi
          fi

          :;:;: " Line ${nameref_Lineno}, If the source conf file/dir still does not exist," "then throw an error "
          if ! [[ -e ${source_file} ]]
          then
            _Fn_error_and_exit_ "${QQ[BB]}" "${source_file}" "${LINENO}"
          fi
        fi

        local dest_dir
        dest_dir=${QQ[BB]%/*}
        _Fn_rsync_install_if_missing_  "${source_file}" "${dest_dir}"
        unset source_file dest_dir
      fi
      #: Loop A:1 - shut
    done
    #: Loops A:1 - complete ===

    unset BB
    unset -n QQ
    #: Loop A - shut
  done

  unset AA
  unset mount_pt data_dir is_mounted
  unset pttn_device_path
  #: Loops A - complete ===

  :;:;: " Line ${nameref_Lineno}, Restore previous umask "
  builtin "${prev_umask[@]}"
  unset prev_umask

}

    #exit "${LINENO}"

##
: " Line ${nameref_Lineno}, Define \Fn_rsync_install_if_missing_ "
function _Fn_rsync_install_if_missing_ (){

    # <>
    if [[ -z $(declare -p data_dir) ]]
    then
      exit "${LINENO}"
    fi

  local fn_target_dir fn_source_var
  fn_source_var=$1
  fn_target_dir=$2

  if [[ -e ${fn_target_dir} ]]
  then
    if ! [[ -d ${fn_target_dir} ]]
    then
      _Fn_error_and_exit_ "${fn_target_dir}" "${LINENO}"
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

  ## Bug, variable \data_dir is defined in a different function, \Fn_reqd_user_files_.
  #+ See <> test above, ~line 812

  if [[ -z ${data_dir} ]]
  then
    local unset_local_var_rand5791
    unset_local_var_rand5791=yes

    local -a poss_dat_dirs
    readarray -d "" -t poss_dat_dirs < <(
      find / -type f -path "*${datadir_basenm}*" -name "${datdir_idfile}" \
          -print0 2>/dev/null
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
      _Fn_error_and_exit_ "${fn_target_dir}" "${LINENO}"
    }
  fi

  :;:;: " Unset a local variable defined and assigned in only this" "function, and not any variables by the same name... "
  #+  from any other scope
  [[ ${unset_local_var_rand5791:=} = "yes" ]] &&
    unset unset_local_var_rand5791 data_dir

  unset fn_source_var fn_target_dir

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_bashrc_ "
function _Fn_setup_bashrc_ (){

  :;:;: " Line ${nameref_Lineno}, bashrc -- Do some backups "
  files_for_use_with_bash=( /root/.bashrc ~/.bashrc )

  for WW in "${files_for_use_with_bash[@]}"
  do
    hash -r

    :;:;: " Line ${nameref_Lineno}, bashrc -- RC File must exist "
    if ! sudo -- "$(type -P test)" -f "${WW}"
    then
      _Fn_error_and_exit_ "${WW}" "${LINENO}"
    fi

    ## Note, chmod changes the ctime, even with no change of DAC\s

    :;:;: " Line ${nameref_Lineno}, bashrc -- ...of the array files_for_use_with_bash "
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

    :;:;: " Line ${nameref_Lineno}, bashrc -- ...per-script-execution file backup "
    sudo -- rsync --archive --checksum "${ver__[@]}" "${WW}" "${WW}~" || {
      _Fn_error_and_exit_ "${WW}" "${LINENO}"
    }
  done
  unset WW

  :;:;: " Line ${nameref_Lineno}, bashrc -- Env parameters for bashrc "

  :;:;: " Line ${nameref_Lineno}, bashrc -- PS0 -- Assign color code and duck xtrace "
  ## Note,  s\et [-|-x] , letting xtrace expand this  tput  command alters all
  #+   xtrace colorization
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

  :;:;: " Line ${nameref_Lineno}, bashrc -- PROMPT_COMMAND -- Variables dependency -- level 1" \
      "-- "
  pc_regx="not found"$
  # shellcheck disable=SC2034
  prompt_colors_reset=$(
    tput sgr0
  )

  ## ToDo, append some additional definitions into bashrc
  #+    man { "$( type -P man )" --nh --nj "$@"; }
  #+    export TMOUT=15

  :;:;: " Line ${nameref_Lineno}, bashrc -- PROMPT_COMMAND -- Variables dependency -- level 2" \
      "-- "
  # shellcheck disable=SC2016
  prompt_cmd_0='printf "%b" "${prompt_colors_reset}" '

  :;:;: " Line ${nameref_Lineno}, bashrc -- PROMPT_COMMAND -- Variables dependency -- level 3" \
      "-- "
  ## Note, PROMPT_COMMAND could have been inherited as a string variable
  unset PROMPT_COMMAND
  declare -a PROMPT_COMMAND
  PROMPT_COMMAND=( [0]="${prompt_cmd_0}" )

  if ! [[ "$( declare -pF __vte_prompt_command 2>&1 )" =~ ${pc_regx} ]]
  then
    PROMPT_COMMAND+=( __vte_prompt_command )
  fi

  :;:;: " Line ${nameref_Lineno}, bashrc -- Other parameters "
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

  :;:;: " Line ${nameref_Lineno}, bashrc -- Append user variables and functions into .bashrc" \
      ""
  ## Note, these arrays include some command substitutions which depend on some
  #+   function definitions, which in turn must be defined prior to defining
  #+   these arrays

  :;:;: " Line ${nameref_Lineno}, bashrc -- Define lists of parameters to be appended into" \
      "bashrc "
  ## Note, there are multiple lists for variables due to layers of dependencies.
  #+   Later in this procedure, each of these groups is relayed using associative
  #+   arrays, which do not reliably maintain their internal ordering, so, some
  #+   consistent ordering must be imposed here.
  declare -a vars_for_bashrc_1=(
      [0]="BROWSER" [1]="EDITOR" [2]="PS0" [3]="prompt_colors_reset")
  declare -a vars_for_bashrc_2=([0]="prompt_cmd_0")
  declare -a vars_for_bashrc_3=([0]="PROMPT_COMMAND")
  declare -a fcns_for_bashrc_1=( )

    # indices=( )
    #
    # list_{ index }=( group )
    #
    # identify [ var or fn ] by parsing shell builtins

    ## ToDo, write lists of how the data is to be written in bashrc, and of how
    #+   the data exists originally, then with those endpoints, chart how to
    #+   transform the strings from a simple list to output in bashrc

  :;:;: " Line ${nameref_Lineno}, bashrc -- Variables "
  missing_vars_and_fns=( )

  :;:;: " Note, test for whether the reqd variables are defined in the" \
      "script#s current execution environment "
  for QQ in "${vars_for_bashrc_1[@]}" "${vars_for_bashrc_2[@]}" \
      "${vars_for_bashrc_3[@]}"
  do
    if [[ $( declare -p "${QQ}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${QQ}" )
    fi
  done
  unset QQ

  :;:;: " Line ${nameref_Lineno}, bashrc -- Functions "
  for UU in "${fcns_for_bashrc_1[@]}"
  do
    if [[ $( declare -pF "${UU}" 2>&1 ) =~ ${pc_regx} ]]
    then
      missing_vars_and_fns+=( "${UU}" )
    fi
  done
  unset UU

  :;:;: " Line ${nameref_Lineno}, bashrc -- Test for any missing parameters "
  if (( ${#missing_vars_and_fns[@]} > 0 ))
  then
    _Fn_error_and_exit_ "${missing_vars_and_fns[@]}" "${LINENO}"
  fi

  :;:;: " Line ${nameref_Lineno}, bashrc -- Create Associative arrays of required" \
      "parameters "

  :;:;: " Line ${nameref_Lineno}, bashrc -- Define Aa_bashrc_strngs_* "
  ## Note, you want for these array elements to represent just one parameter or
  #+   function each.  ...what does this mean?
  local -a bashrc_Assoc_arrays
  bashrc_Assoc_arrays=(
      Aa_bashrc_strngs_F1 Aa_bashrc_strngs_V1 Aa_bashrc_strngs_V2 Aa_bashrc_strngs_V3 )
  local -A "${bashrc_Assoc_arrays[@]}"

  :;:;: " Line ${nameref_Lineno}, bashrc -- Variables "
  ## Note, three temp vars are used here because of the correspondence of numbers,
  #+   ie, 1 and 1, 2 and 2, etc between the names of the respective indexed and
  #+   associative arrays. In effect, this is the clearest and shortest way to
  #+   write it in bash (5.2), for the intended purpose, to the best of my
  #+   knowledge.
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

  :;:;: " Line ${nameref_Lineno}, bashrc -- Functions (a.k.a. \"subroutines\") "
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

  :;:;: " Line ${nameref_Lineno}, bashrc -- Write functions and variable definitions into" \
      "bashrc files "
  local KK
  for KK in "${!bashrc_Assoc_arrays[@]}"
  do
    _Fn_write_bashrc_strings_ "${bashrc_Assoc_arrays[${KK}]}"
  done
  unset KK

  :;:;: " Line ${nameref_Lineno}, bashrc -- Clean up "
  unset pc_regx prompt_cmd_0
  unset files_for_use_with_bash
  unset -f _Fn_write_bashrc_strings_
  unset "${bashrc_Assoc_arrays[@]}"
  unset bashrc_Assoc_arrays

}



##
#! Bug, \Fn_setup_dnf_ is too long and too complicated
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_dnf_ "
function _Fn_setup_dnf_ (){

  ## Bug, there should be a n\eeds-restarting loop between each install/upgrade
  ## Bug, the --security upgrade should be done rpm by rpm

    :;:;: " Line ${nameref_Lineno}, Beginning section on DNF "

  ## Note, CUPS cannot be safely removed; too many dependencies
  ## Note, For some unknown reason, even when  dnf  doesn\t change any programs,
  #+   dnf needs-restarting  decides it needs to restart all available Firefox
  #+   processes, which crashes all of my tabs.  (Burg?)  So, I\m adding in a
  #+   few  rpm -qa | wc -l s to only run  dnf needs-restarting  in the event
  #+   that any files on disk may actually have been changed.
  ## Note, these PE\s (for_admin, for_bash, etc.) have been tested and should
  #+   \disappear\ by virtue of whichever expansion does that, leaving just the
  #+   regular strings as the elements of the array
  ## Note, this brace grouping (all together of for_admin, for_bash, etc.) is
  #+   so that \shellcheck disable\ will apply to the entire block

  hash_of_installed_pkgs_A=$(
    rpm --all --query |
      sha256sum |
      cut --delimiter=' ' --fields=1
  )

  :;:;: " Line ${nameref_Lineno}, Define filename for record of previous hash..B "
  local hash_f hash_of_installed_pkgs_B_prev
  hash_f=/tmp/setup_dnf__hash_of_installed_pkgs_B_prev
  hash_of_installed_pkgs_B_prev=""

  :;:;: " If the record already exists... "
  if [[ -f ${hash_f} ]]
  then

    :;:;: "...then read it in "
    read -r hash_of_installed_pkgs_B_prev < "${hash_f}"

    :;:;: " If the old hash...B matches the new hash...A, then" \
        "return from this function "
    if [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B_prev}" ]]
    then
      return
    fi
  fi

  :;:;: " Line ${nameref_Lineno}, Removals for disk space "
  pkg_nms_for_removal=(
      google-noto-sans-cjk-vf-fonts
      mint-x-icons
      mint-y-icons
      transmission )

  :;:;: " Line ${nameref_Lineno}, Removals for security "
  #pkg_nms_for_removal+=( blueman bluez )

  ## Note, xfce4-terminal -- hardcoded WM ...can be used w/o XFCE....

  # shellcheck disable=SC2206
  {
      addl_pkgs=(  ${for_admin:=}         ncdu pwgen )
      addl_pkgs+=( ${for_bash:=}          bash bash-doc )
      addl_pkgs+=( ${for_bashdb:=}          bash-devel make autoconf )
      addl_pkgs+=( ${for_critical_A:=}    libsss_sudo sudo{,-python-plugin} )
      addl_pkgs+=( ${for_critical_B:=}    nss{,-{mdns,softokn{,-freebl},sysinit,util}} )
      addl_pkgs+=( ${for_critical_C:=}    openssh{,-{clients,server}} )
      addl_pkgs+=( ${for_critical_D:=}    chrony )
      addl_pkgs+=( ${for_critical_E:=}    gnupg2{,-smime}
                                            {archlinux,debian,ubu}-keyring )
      addl_pkgs+=( ${for_critical_F:=}      {distribution,fedora}-gpg-keys python3-gpg )
      addl_pkgs+=( ${for_critical_G:=}    NetworkManager
                                            NetworkManager-{adsl,bluetooth,libnm,ppp} )
      addl_pkgs+=( ${for_critical_H:=}      NetworkManager-{team,wifi,wwan} util-linux )
      addl_pkgs+=( ${for_critical_I:=}    firewall-config python3-firewall
                                            firewalld{,-filesystem} )
      addl_pkgs+=( ${for_critical_J:=}    firefox{,-langpacks}
                                            mozilla-{filesystem,https-everywhere}
                                            mozilla-{noscript,privacy-badger} )
      addl_pkgs+=( ${for_critical_K:=}      mozjs102 perl-Mozilla-CA )
      addl_pkgs+=( ${for_critical_L:=}    iptables-{libs,nft} {,python3-}nftables )
      addl_pkgs+=( ${for_critical_M:=}    dnf{,-data,-plugins-core}
                                            python3-dnf{,-plugins-core}
                                            {python3-,}libdnf ) sqlite
      addl_pkgs+=( ${for_critical_M:=}    rpm{,-{build-,}libs} rpm-plugin-{selinux,systemd-inhibit} rpm{-sequoia,-sign-libs} )
      addl_pkgs+=( ${for_critical_M:=}      {delta,python3-}rpm )
      addl_pkgs+=( ${for_critical_N:=}    audit{,-libs} python3-audit )
      addl_pkgs+=( ${for_critical_O:=}    sysstat )
    # addl_pkgs+=( ${for_careful_A:=}     systemd )
    # addl_pkgs+=( ${for_careful_B:=}     sssd{,-{ad,client,common{,-pac}}
    #                                       sssd{ipa,kcm,krb5{,-common},ldap}
    #                                       sssd{nfs-idmap,proxy}} )
    # addl_pkgs+=( ${for_db_ish:=}        libreoffice-calc )
      addl_pkgs+=( ${for_bug_rpts:=}      inxi zsh dash mksh )
      addl_pkgs+=( ${for_char_sets:=}     enca moreutils uchardet )
      addl_pkgs+=( ${for_duh:=}           info plocate lynx )
      addl_pkgs+=( ${for_duh:=}           pdfgrep wdiff )
      addl_pkgs+=( ${for_fs_maint:=}      bleachbit python3-psutil )
      addl_pkgs+=( ${for_fs_maint:=}      stacer )
    # addl_pkgs+=( ${for_fun:=}           supertuxkart )
      addl_pkgs+=( ${for_gcov:=}          gcc )
      addl_pkgs+=( ${for_git:=}           git gh )
    # addl_pkgs+=( ${for_internet:=}      chromium )
    # addl_pkgs+=( ${for_later_other:=}   memstomp gdb valgrind memstrack kernelshark )
    # addl_pkgs+=( ${for_later_trace:=}   bpftrace python3-ptrace fatrace apitrace
    #                                       x11trace )
      addl_pkgs+=( ${for_linting:=}       ShellCheck strace )
      addl_pkgs+=( ${for_mo_linting:=}    kcov shfmt patch ltrace )
      addl_pkgs+=( ${for_lockfile:=}      procmail )
      addl_pkgs+=( ${for_os_dnlds:=}      debian-keyring )
      addl_pkgs+=( ${for_strings:=}       binutils )
      addl_pkgs+=( ${for_term_tests:=}    xfce4-terminal )
      addl_pkgs+=( ${for_term_tests:=}      gnome-terminal xterm konsole5 )
    # addl_pkgs+=( ${for_unicode:=}       xterm rxvt-unicode perl-Text-Bidi-urxvt )
      addl_pkgs+=( ${for_security:=}      orca protonvpn-cli xsecurelock )
  }

  :;:;: " Start with removing any unnecessary RPMs "

  if [[ -n ${pkg_nms_for_removal:0:8} ]]
  then
    ## Note, this  printf  command uses nulls so that  -e  and  %s...  will be
    #+   read as separate indices by  readarray
    readarray -d "" -t grep_args < <(
      printf -- '-e\0%s.*\0' "${pkg_nms_for_removal[@]}"
    )
    readarray -t removable_pkgs < <(
      rpm --all --query | grep --ignore-case --extended-regexp "${grep_args[@]}"
    )

    :;:;: " Keep a list, just in case an rpm removal accidentally" \
        "erases something vital "
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
          _Fn_error_and_exit_ "${removable_pkgs[QQ]}" "${LINENO}"
        fi
        unset DD exp_dt dnf_cmd
      done
      unset QQ
    fi
  fi

  :;:;: " Line ${nameref_Lineno}, Then do a blanket security upgrade "

  ## Note, the problem with this \blanket security upgrade\ is how it
  #+   includes kernel and firmware. Better to capture list of rpms in
  #+   a no-op cmd, filter out impractical (for a LiveUsb) rpms, then
  #+   upgrade the rest one by one

  :;:;: $'Run this loop until \x60dnf --security upgrade\x60 returns 0, or 0' \
      $'upgradable, rpms'
  while true
  do

    :;:;: " Get full list of rpms to upgrade, in an array; exit" \
        "on non-zero "
    readarray -d "" -t pkgs_for_upgrade < <(
      sudo -- dnf --assumeno --security --bugfix upgrade 2>/dev/null |
        awk '$2 ~ /x86_64|noarch/ { printf "%s\0", $1 }' |
        grep -vE ^replacing$
      )

    :;:;: $'remove all  kernel  and  firmware  rpms from array \x24pkgs_for_upgrade array'
    for HH in "${!pkgs_for_upgrade[@]}"
    do
      if [[ ${pkgs_for_upgrade[HH]} =~ kernel|firmware ]]
      then
        unset_reason+=( [HH]="${BASH_REMATCH[*]}" )
        unset "pkgs_for_upgrade[HH]"
      fi
    done
    unset HH

    :;:;: " If count of upgradeable rpms is 0, then break loop "
    if [[ ${#pkgs_for_upgrade[@]} -eq 0 ]]
    then
      break
    fi

    :;:;: " Upgrade the RPM\s one at a time "
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

    :;:;: $'Run \x60dnf needs-restarting\x60, collecting PID/commandline pairs'
    #a_pids=( )
    _Fn_get_pids_for_restarting_

      declare -p a_pids
      #exit 101

    :;:;: $'Send signals to "needs-restarting" PID\x27s, one at a time...'
    #+   with pauses and descriptions between each one, so I can see which
    #+   signal/process combinations cause any problems. This would be a
    #+   great job for logging.

  done

  _Fn_pause_to_check_ "${nameref_Lineno}" $'Which packages in the \x24addl_pkgs' \
      $'array are already installed?' # <>

  :;:;: " Find out whether an RPM is installed, one by one "
  for UU in "${!addl_pkgs[@]}"
  do
    if rpm --query --quiet -- "${addl_pkgs[UU]}"
    then
      pkgs_installed+=( "${addl_pkgs[UU]}" )
      unset "addl_pkgs[UU]"
    fi
  done
  unset UU

    _Fn_pause_to_check_ "${nameref_Lineno}" $'Upgrade any pre-intstalled' \
        $'packages from the \x24addl_pkgs array' # <>

  ## Bug, this section should upgrade rpms one by one

  :;:;: " Upgrade any installed RPMs from the main list, en" \
      "masse "
  if [[ -n ${pkgs_installed[*]: -1:1} ]]
  then
    if ! sudo -- \
            nice --adjustment=-20 -- \
                dnf --assumeyes --quiet upgrade "${pkgs_installed[@]}"
    then
        _Fn_error_and_exit_ "${LINENO}"
    fi
  fi

    _Fn_pause_to_check_ "${nameref_Lineno}" $'From the \x24addl_pkgs array,' \
        $'install the remainder' # <>

  :;:;: " Install any as yet uninstalled RPMs from the main list" \
      "as necessary "
  not_yet_installed_pkgs=( "${addl_pkgs[@]}" )

  if [[ -n ${not_yet_installed_pkgs[*]: -1:1} ]]
  then
    ## Note, if you install multiple rpms at the same time, and one of them
    #+   causes some error, then you have no immediate way of knowing which one
    #+   caused the error

    for VV in "${not_yet_installed_pkgs[@]}"
    do
      sudo -- nice --adjustment=-20 -- dnf --assumeyes --quiet install "${VV}" || {
        _Fn_error_and_exit_ "${LINENO}"
      }

      _Fn_get_pids_for_restarting_

      ## BUG, killing NetworkManager or firewalld stops the systemd service
      #+   process, and neither restart automatically

      ## Question, how is it possible to know from \ps aux\ output whether a
      #+   process was started by a systemd service?  ...grepping
      #+   /usr/lib/systemd/system for the cmdline?
      #
      #{ for XX in /proc/[0-9]*/cmdline; do if [[ -n $XX ]]; then readarray -d "" -t array_cmdln < <( cat "$XX" ); string_cmdln="${array_cmdln[@]}"; if [[ -z ${array_cmdln[*]} ]] || [[ -z $string_cmdln ]]; then continue; fi; if grep -rilqe "$string_cmdln" /usr/lib/systemd/system; then printf 'yes\t'; else printf 'no\t'; fi; printf '%s\n' "${string_cmdln}"; fi; done; } | head -n20

      if [[ -n ${a_pids[*]:0:1} ]]
      then

        for WW in "${!a_pids[@]}"
        do
            : $'\x22${a_pids[WW]}\x22:' "${a_pids[WW]}" # <>

          ps aux |
            awk --assign "CC=${a_pids[WW]}" '$2 ~ CC { print }'

          :;:;: " Ensure a process is still running before trying" \
              "to kill it "

          ## Note, some strings from /proc/[pid]/cmdline include \[]\ brackets;
          #+   \pgrep -f\ parses these as ERE\s and cannot parse fixed strings,
          #+   so a Parameter Expansion is necessary in order to render any
          #+   opening bracket \[\ as non-special for ERE syntax.
          ## Note, subprocesses, killing a daemon, for example, avahi, might also
          #+   kill some other processes which were avahi\s child processes, so
          #+   when the for loop, looping through PID\s to be restarted, gets to
          #+   those child processes, then those child processes are no longer
          #+   active, and \/proc/${a_pids[WW]}/cmdline\ would not exist.
          sleep 1

          :;:;: " Most existing processes have some commandline" \
              "information available "

          :;:;: " If the /proc/PID/cmdline FSO exists and is a file," \
              "then... "
          if [[ -f /proc/${a_pids[WW]}/cmdline ]]
          then
            ## Note, these files are in /proc - of course they have a zero filesize!!

            ## Bug, the bashism \[[\ keyword cannot accept a leading or internal
            #+   \2>/dev/null\, though \test\ and \[\ can.

            :;:;: " If the /proc/PID/cmdline FSO also has a size" \
                "greater than zero... "
            if [[ -n $( tr -d '\0' < "/proc/${a_pids[WW]}/cmdline" ) ]]
            then
              local -a array_of_PIDs_cmdline
              local string_of_PIDs_cmdline

              :;:;: " Load the cmdline into an array "
              readarray -d '' -t array_of_PIDs_cmdline < <(
                cat "/proc/${a_pids[WW]}/cmdline"
              )

              :;:;: $'Skip zombie processes, which have zero length' \
                  $'\x22/proc/[pid]/cmdline\x22 files'
              if [[ -z ${array_of_PIDs_cmdline[*]} ]]
              then
                unset "a_pids[WW]" array_of_PIDs_cmdline
                continue
              fi

              :;:;: " If the commandline cannot be found in ps" \
                  "output, then move on to the next loop "
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
            :;:;: "If the /proc/PID/cmdline FSO does not exist, then begin the next loop"
            unset "a_pids[WW]" string_of_PIDs_cmdline
            continue
          fi

          :;:;: " Kill a particular process "
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
  unset for_{admin,bash,bashdb,db_ish,bugg_rpts,duh,firefox} \
            for_{fun,gcov,git,internet,later_{other,trace}}
  unset for_{linting,lockfile,os_dnlds,strings,term_tests,unicode}
  unset grep_args removable_pkgs rr pkgs_installed not_yet_installed_pkgs

  :;:;: " Restart any processes that may need to be restarted." \
      "Begin by getting a list of any such PIDs "
  _Fn_get_pids_for_restarting_

  :;:;: $'Get new hash of installed packages, ie, \x24{hash..B}'
  hash_of_installed_pkgs_B=$(
    rpm --all --query |
      sha256sum |
      awk '{ print $1 }'
  )

  :;:;: $'Write \x24{hash..B} to disk'

  local hash_of_installed_pkgs_B_prev
  hash_of_installed_pkgs_B_prev="${hash_of_installed_pkgs_B}"

  :;:;: " If the target file exists "
  if [[ -f ${hash_f} ]]
  then

    :;:;: " If the target file is immutable "
    local has_immutable
    has_immutable=$(
      lsattr -l "${hash_f}" |
        awk '$1 ~ /i/ { printf "Yes" }'
    )

    if [[ ${has_immutable} = "Yes" ]]
    then

      :;:;: "...then remove the immutable flag "
      sudo chattr -i "${hash_f}"
    fi

  :;:;: " if the target file does not exist "
  else

    :;:;: " then create it "
    touch "${hash_f}"
  fi

  :;:;: " Make sure the file is writeable "
  [[ -w "${hash_f}" ]] ||
    chmod u+w "${hash_f}"

  :;:;: " State, the file exists and is writeable "

  :;:;: $'Write \x24{hash..B} to disk, and make it RO and immutable.'
  printf '%s\n' "${hash_of_installed_pkgs_B_prev}" |
    tee "${hash_f}"
  chmod 400 "${ver__[@]}" "${hash_f}"
  sudo chattr +i "${hash_f}"
  unset hash_f

  ## ToDo: change temp-vars (II, XX, etc) to fully named vars

  if  ! [[ ${hash_of_installed_pkgs_A} = "${hash_of_installed_pkgs_B}" ]] ||
      [[ ${#a_pids[@]} -gt 0 ]]
  then

    while true
    do

      ## Note,  [[ ... = , this second test,  [[ ${a_pids[*]} = 1 ]]  is correct.
      #+   This means, do not use ((...)) , and \=\ is intended to that \1\ on
      #+   RHS is matched as in Pattern Matching, ie, as \PID 1.\
      :;:;: $'if any PID\x60s were found... ...and if there are any' \
          $'PID\x60s other than PID 1...'
      if  [[ -n ${a_pids[*]: -1:1} ]] &&
          ! [[ ${a_pids[*]} = 1 ]]
      then
        II=0
        XX=${#a_pids[@]}

        :;:;: " Print some info and wait for it to be read "
        ## Note, "\x60" is a grace accent used as a single quote
        printf '\n  %b for restarting, count, %d \n\n' 'PID\x60s' "${XX}"

          sleep 1 # <>

        :;:;: " for each signal and for each PID... "
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

              :;:;: " To kill PID ${ZZ} with signal ${AA} "

            sync --file-system

              wait -f # <>

            :;:;: "...if the PID is still running... "
            if  ps --no-headers --quick-pid "${ZZ}"
            then
              :;:;: " Evidently, I need to give the system a little" \
                "time for processing "
              sleep 1

              ## Bug?? all of the \type -P\ commands s\b consolidated into a s\et
              #+   of variables ...?

              :;:;: $'...then \x60kill\x60 it with the according per-loop SIGNAL...'
              ## Note, the exit codes for  kill  only indicate whether or not the
              #+   target PIDs existed, rather than whether the  kill  operation
              #+   succeeded, per  info kill .
              sudo -- "$( type -P kill )" --signal "${AA}" -- "${ZZ}"

              :;:;: " Evidently, I need to give the system a little" \
                  "MORE time for processing "
              sleep 1

              :;:;: "...and if the PID in question no longer exists" \
                  "then unset the current array index number "
              if  ps --no-headers --quick-pid "${ZZ}" |
                    grep -qv defunct
              then
                is_pid_a_zombie=$(
                  ps aux |
                    awk --assign "EE=${ZZ}" '$2 ~ EE { print $8 }'
                )

                if [[ ${is_pid_a_zombie} = Z ]]
                then
                  :;:;: " Process is a zombie; unsetting "
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


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_gh_cli_ "
function _Fn_setup_gh_cli_ (){

  :;:;: " GH -- s\et config key-value pairs "
  local -A github_configs
  local gh_config_list_out
  github_configs+=( [editor]=vim )
  github_configs+=( [browser]=firefox )
  github_configs+=( [pager]=less )
  github_configs+=( [git_protocol]=ssh )
  gh_config_list_out=$(
    gh config list |
      tr '\n' ' '
  )

  for KK in "${!github_configs[@]}"
  do
    ## Note, \SC2076 (warning): Remove quotes from right-hand side of =~ to match
    #+   as a regex rather than literally.\
    if ! [[ ${gh_config_list_out} =~ ${KK}=${github_configs[${KK}]} ]]
    then
      gh config set "${KK}" "${github_configs[${KK}]}"
    fi
  done
  unset KK
  unset gh_config_list_out github_configs

    wait -f # <>
    hash -r

  ## Bug, \gh auth status\ is executed too many (ie, 3) times. Both the checkmarks
  #+   and the exit code are used

    #gh auth status ## <>

  :;:;: " GH -- Login to github "
  ## Note, this command actually works as desired, neither pipefail nor the ERR
  #+   trap are triggered
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
      _Fn_pause_to_check_ "${nameref_Lineno}" $'Waiting till browser is open' \
          $'before running \x60gh auth\x60 command'
      _Fn_gh_auth_login_command_
    fi
  fi

  ## Bug, when \gh ssh-key list\ fails, then after \Fn_gh_auth_login_command_
  #+   executes, \gh ssh-key list\ is not executed again, when it should be

  :;:;: " GH -- Get SSH & GPG keys "
  for QQ in ssh-key gpg-key
  do
    if ! gh "${QQ}" list > /dev/null 2>&1
    then
      _Fn_gh_auth_login_command_
    fi
  done
  unset QQ

  :;:;: " GH -- Use GitHub CLI as a credential helper "
  gh auth setup-git --hostname github.com

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_git_ "
function _Fn_setup_git_ (){

  ## Note, git ui colors: normal black red green yellow blue magenta cyan white
  #+   git ui attributes: bold dim ul (underline blink reverse)
  ## Note, In vim, since \expandtab\ is s\et in .vimrc, to make some actual tabs,
  #+   press Ctrl-v-[tab]

  ## Bug? in vim, when quoting \EOF\, $tmp_dir changes color, but bash still
  #+   expands the redirection destination file.

  :;:;: " Git -- parameters, dependency level 1 "
  local git_conf_global_f git_ignr git_mesg
  git_conf_global_f=~/.gitconfig
  git_ignr=~/.gitignore
  git_mesg=~/.gitmessage

  :;:;: " Paramters with globs "
  ## Note, use of globs. The RE pattern must match all of the patterns in the
  #+   array assignments
  local git_files_a git_regexp
  git_files_a=( /etc/git* /etc/.git* ~/.git* )
  git_regexp=git"*"

  :;:;: " Git -- parameters, dependency level 2 "
  if [[ -f ${git_conf_global_f} ]]
  then
    local git_cnf_glob_list
    readarray -t git_cnf_glob_list < <(
      git config --global --list
    )
  fi

  ## Note, write large array assignments this way so that they mirror xtrace
  #+   output cleanly
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

  :;:;: " Git -- Files must exist and Permissions "
  read -r -a prev_umask < <(
    umask -p
  )
  umask 133

  :;:;: " Remove any unmatched glob patterns "
  local ZZ

  for ZZ in "${!git_files_a[@]}"
  do
    if [[ ${git_files_a[ZZ]} =~ ${git_regexp} ]]
    then
      unset "git_files_a[ZZ]"
    fi
  done
  unset ZZ git_regexp

  :;:;: $'Git -- Create files and s\et DAC\x60s as necessary - Loop B'
  local AA
  for AA in "${git_files_a[@]}"
  do
    :;:;: '  Loop B - open \\\ '
    sudo -- [ -e "${AA}" ] ||
      sudo -- touch "${AA}"
    sudo -- chmod 0600 "${ver__[@]}" "${AA}"
    :;:;: " Loop B - shut ///  "
  done
  unset AA
  :;:;: " Loops B - complete ===  "

  builtin "${prev_umask[@]}"

  :;:;: " Git -- remove a particular configuration key/value pair" \
      "if present "
  if  printf '%s\n' "${git_cnf_glob_list[@]}" |
        grep gpg.format "${qui__[@]}"
  then
    git config --global --unset gpg.format
  fi

  :;:;: " Git -- setup configuration - Loop C "
  local BB
  for BB in "${!git_keys[@]}"
  do
    :;:;: '  Loop C - open \\\ '

      :;:;: " BB:${BB} "

    if ! grep -e "${BB#*.} = ${git_keys[${BB}]}" "${qui__[@]}" "${git_conf_global_f}"
    then
      git config --global "${BB}" "${git_keys[${BB}]}"
    fi
    :;:;: " Loop C - shut ///  "
  done
  unset BB
  :;:;: " Loops C - complete ===  "

  :;:;: " Git -- gitmessage (global) "
  if ! [[ -f ${git_mesg} ]]
  then
    :;:;: " Heredoc, gitmessage "
    cat <<- "EOF" > "${tmp_dir}/msg"
		Subject line (try to keep under 50 characters)

		Multi-line description of commit,
		feel free to be detailed.

		[Ticket: X]

		EOF

    # shellcheck disable=SC2024 #(info): sudo does not affect redirects....
    tee -- "${git_mesg}" < "${tmp_dir}/msg" > /dev/null || {
      _Fn_error_and_exit_ "${LINENO}"
    }
    chmod 0644 "${ver__[@]}" "${git_mesg}" || {
      _Fn_error_and_exit_ "${LINENO}"
    }
  fi

  :;:;: " Git -- gitignore (global) "
  if  ! [[ -f ${git_ignr} ]] ||
      ! grep swp "${qui__[@]}" "${git_ignr}"
  then
    :;:;: " Heredoc, gitignore "
    cat <<- \EOF > "${tmp_dir}/ign"
		*~
		.*.swp
		.DS_Store

		EOF

    # shellcheck disable=SC2024
    tee -- "${git_ignr}" < "${tmp_dir}/ign" > /dev/null || {
      _Fn_error_and_exit_ "${LINENO}"
    }
    chmod 0644 "${ver__[@]}" "${git_ignr}" || {
      _Fn_error_and_exit_ "${LINENO}"
    }
  fi

  :;:;: $'Git -- Set correct DAC\x60s (ownership and permissions)'
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

  :;:;: " Clean up after section, Git "
  unset git_files_a git_conf_global_f git_mesg git_ignr git_keys

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_gti_user_dirs_ "
function _Fn_setup_gti_user_dirs_ (){

  ## Note, in order to clone into any repo, and keep multiple repos separate,
  #+   cd  is required, or  pushd  /  popd

  :;:;: " Variables -- global, for use for entire script "
  unset     local_dir_1
            local_dir_1=~/MYPROJECTS
  readonly  local_dir_1

  unset     local_dir_2
            local_dir_2=~/OTHERSPROJECTS
  readonly  local_dir_2

  :;:;: " Make dirs "
  local UU
  for UU in "${local_dir_1}" "${local_dir_2}"
  do
    if ! [[ -d ${UU} ]]
    then
      mkdir --mode=0700 "${ver__[@]}" "${UU}" || {
        _Fn_error_and_exit_ "${LINENO}"
      }
    fi
  done
  unset UU

  :;:;: " Change dirs "
  pushd "${local_dir_1}" > /dev/null || {
    _Fn_error_and_exit_ "${LINENO}"
  }

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_gpg_ "
function _Fn_setup_gpg_ (){

  :;:;: " If any files in ~/.gnupg are not owned by either USER or root, then error out and exit "
  local -a problem_files
  problem_files=( )
  readarray -d "" -t problem_files < <(
      find -- ~/.gnupg -xdev \
        \( \
          \(  \!  -uid "${login_gid}" -a  \! -gid 0  \) -o \
          \(  \!  -gid "${login_uid}" -a  \! -uid 0  \) \
        \)  -print0 \
  )
  [[ -n ${problem_files[*]} ]] && {
    _Fn_error_and_exit_ Incorrect ownership on -- "${problem_files[@]}" "${LINENO}"
  }
  unset problem_files

  :;:;: $'If any files are owned by root, then change their ownership to \x24USER'
  sudo -- \
    find -- ~/.gnupg -xdev \( -uid 0 -o -gid 0 \) -execdir \
      chown "${login_uid}:${login_gid}" "${ver__[@]}" \{\} \; || {
        _Fn_error_and_exit_ "${LINENO}"
      }

  :;:;: $'If any dir perms aren\x60t 700 or any file perms aren\x60t 600, then make them so'
  find -- ~/.gnupg -xdev -type d \! -perm 700  -execdir \
    chmod 700 "${ver__[@]}" \{\} \; #
  find -- ~/.gnupg -xdev -type f \! -perm 600  -execdir \
    chmod 600 "${ver__[@]}" \{\} \; #

  :;:;: " GPG -- If a gpg-agent daemon is running, or not, then, either way say so "
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

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_network_ "
function _Fn_setup_network_ (){
  #

  dns_srv_1=8.8.8.8
  dns_srv_A=75.75.75.75
  readonly dns_srv_1 dns_srv_A

  # shellcheck disable=SC2310
  if  ! _Fn_test_dns_ "${dns_srv_1}" ||
      ! _Fn_test_dns_ "${dns_srv_A}"
  then
    printf '\n%s, Attempting to connect to the internet... \n\n' "${scr_nm}"

    :;:;: " Try to get NetworkManager up and running "
    sudo -- nice --adjustment=-20 -- systemctl start -- NetworkManager.service
    wait -f

    :;:;: " Turn on networking "
    sudo -- nmcli n on

    :;:;: " Turn on WiFi "
    sudo -- nmcli r wifi on

    :;:;: " Get interface names "
    readarray -d "" -t ifaces < <(
      nmcli --terse c |
        awk --field-separator : '$1 !~ /lo/ { printf "%s\0", $1 }'
    )

    :;:;: " Connect the interface "
    case "${#ifaces[@]}" in
      0 )
        _Fn_error_and_exit_ "No network device available" "${LINENO}"
        ;; #
      1 )
        nmcli c up "${ifaces[*]}"
        sleep 5
        ;; #
      * )
        _Fn_error_and_exit_ "Multiple network devices available" "${LINENO}"
        ;; #
    esac

    # shellcheck disable=SC2310
    if  ! _Fn_test_dns_ "${dns_srv_1}" ||
        ! _Fn_test_dns_ "${dns_srv_A}"
    then
      printf '\n%s, Network, Giving up, exiting.\n\n' "${scr_nm}"
    else
      printf '\n%s, Network, Success!\n\n' "${scr_nm}"
    fi
  fi

  :;:;: " Clean up from Network "
  ## Note, dns_srv_A will be used at the end of the script
  unset -f _Fn_test_dns_

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_ssh_ "
function _Fn_setup_ssh_ (){
  #

  ## Bug? hardcoded filenames? ...yes, I know it#s mis-spelled.

  local ssh_usr_conf_dir ssh_user_conf_file
  ssh_usr_conf_dir=~/.ssh/
  ssh_user_conf_file=~/.ssh/config

  :;:;: " Make sure the SSH config directory and file for USER" \
      "exist "
  # shellcheck disable=SC2310
  if [[ ! -d ${ssh_usr_conf_dir} ]]
  then
      mkdir -m 0700 "${ssh_usr_conf_dir}" || _Fn_error_and_exit_ "${LINENO}"
  fi

  # shellcheck disable=SC2310
  if [[ ! -f ${ssh_user_conf_file} ]]
  then
      _Fn_write_ssh_conf_ || _Fn_error_and_exit_ "${LINENO}"
  fi

     # <>

  ## ToDo, _rm_ should be an alias
  ## ToDo, all aliases should be prefixed and suffixed with underscores, while
  #+   functions should include at least one underscore

  :;:;: $'Make sure the SSH config file for USER is correct, and write it if it' \
      $'is missing or wrong'
  if ! grep "ForwardAgent yes" "${qui__[@]}" "${ssh_user_conf_file}"
  then
    "$( type -P rm )" \
        --force --one-file-system --preserve-root=all \
        "${ver__[@]}" \
        "${ssh_user_conf_file}"
    _Fn_write_ssh_conf_
  fi
  unset -f _Fn_write_ssh_conf_

  ## Bug, security, these #chown# commands should operate on the files while they
  #+   are still in skel_LiveUsb see also similar code in \Fn_setup_gpg_,
  #+   possibly elsewhere also  :-\

  ## Bug, timestamps, chown changes ctime on every execution, whether or not the
  #+   ownership changes

  :;:;: $'Make sure the SSH config directories and files for USER have correct DAC\x60s'
  {
    sudo -- \
      find -- "${ssh_usr_conf_dir}" -xdev \
        \(  \! -uid "${login_uid}"  -o  \
            \! -gid "${login_gid}"  \
        \) -execdir \
          chown -- "${login_uid}:${login_gid}" "${ver__[@]}" \{\} \; || {
            _Fn_error_and_exit_ "${LINENO}"
          }
    find -- "${ssh_usr_conf_dir}" -xdev -type d -execdir \
      chmod 700 "${ver__[@]}" \{\} \; #
    find -- "${ssh_usr_conf_dir}" -xdev -type f -execdir \
      chmod 600 "${ver__[@]}" \{\} \; #
  }
  unset ssh_usr_conf_dir ssh_user_conf_file

  ## Bug? not necc to restart ssh-agent if both of these vars exist?

    :;:;: "${SSH_AUTH_SOCK:=}" "${SSH_AGENT_PID:=} "
    declare -p SSH_AUTH_SOCK SSH_AGENT_PID # <>

     # <>

  :;:;: " Get the PID of any running SSH Agents -- there may be" \
      "more than one "
  local -a ssh_agent_pids
  readarray -t ssh_agent_pids < <(
    ps h -C 'ssh-agent -s' -o pid |
      tr -d ' '
  )

  :;:;: " Make sure ssh daemon is running (?) "
  if  [[ -z ${SSH_AUTH_SOCK:-} ]] ||
      [[ -z ${SSH_AGENT_PID:-} ]] ||
      [[ -z ${ssh_agent_pids[*]:-} ]]
  then
    :;:;: $'If there aren\x60t any SSH Agents running, then start one'
    ## Note, https://stackoverflow.com/questions/10032461/\
    #+   git-keeps-asking-me-for-my-ssh-key-passphrase
    local HH
    HH=$(
      ssh-agent -s
    )
    eval "${HH}"
    unset HH

    :;:;: "...and try again to get the PID of the SSH Agent "
    readarray -t ssh_agent_pids < <(
      ps h -C 'ssh-agent -s' -o pid |
        tr -d ' '
    )
  fi

     # <>

  case "${#ssh_agent_pids[@]}" in
    0 )
        _Fn_error_and_exit_ "ssh-agent failed to start" "${LINENO}"
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

        :;:;: " If more than one ssh-agent is running, then keep" \
            "the first and kill the rest "
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
  ## Note, returns exit code 1; why is this command here exectly?
  #ssh -T git@github.com

}


##
#: "setup_systemd"
#function _Fn_setup_systemd_ (){
  #
  ### Note, services to disable and mask
  ##+  ModemManager.service
  ##+ ...
  ### Note, services to disable and mask
  ##+ ...
#}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_temp_dirs_ "
function _Fn_setup_temp_dirs_ (){
  #

  tmp_dir=$(
    if ! TMPDIR="" mktemp --directory --suffix=-LiveUsb 2>&1
    then
      _Fn_error_and_exit_ "${LINENO}"
    fi
  )

  [[ -d ${tmp_dir} ]] \
      || _Fn_error_and_exit_ "${LINENO}"
  readonly tmp_dir

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_time_ "
function _Fn_setup_time_ (){
  #

  sudo -- timedatectl set-local-rtc 0
  sudo -- timedatectl set-timezone America/Vancouver

  if sudo -- systemctl start chronyd.service
  then
      : true
  else
      : false
      _Fn_error_and_exit_ "${LINENO}"
  fi

  sudo -- chronyc makestep > /dev/null

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_setup_vim_ "
function _Fn_setup_vim_ (){
  #

  ## Long line reqd
  :;:;: " Heredoc of vim-conf-text "
  cat <<- \EOF | tee -- "${tmp_dir}/vim-conf-text" > /dev/null
		" ~/.vimrc

		" per Google
		set number

		" per https://stackoverflow.com/questions/234564/\
        "   tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim
		filetype plugin indent on
		" show existing tab with 2 spaces width
		set tabstop=2
		" when indenting with ">", use 2 spaces width
		set shiftwidth=2
		" On pressing tab, insert 2 spaces
		set expandtab

		" per https://superuser.com/questions/286290/\
        "   is-there-any-way-to-hook-saving-in-vim-up-to-commiting-in-git
		autocmd BufWritePost * execute '! if [[ -d .git ]]; then git commit -S -a -F -; fi'

		EOF

  :;:;: $'Get an array of the FS location\x28s\x29 of root\x60s vimrc\x28s\x29'
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
        _Fn_error_and_exit_ "${LINENO}"
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

  :;:;: " Write .vimrc "
  if  (( ${#arr_vrc[@]} == 0 )) ||
      ! [[ ${WW} = "${YY}" ]]
  then
    : $'Test returned \x22true,\x22 the number didn\x60t match, so write to .vimrc'

    :;:;: " Set the umask "
    read -ra umask_prior < <(
      umask -p
    )
    umask 177

    :;:;: " Write the root file "
    sudo -- rsync --archive --checksum -- "${tmp_dir}/vim-conf-text" "${strng_vrc}" || {
      _Fn_error_and_exit_ "${LINENO}"
    }

    :;:;: " Copy the root file to ${HOME}" \
        $' and repair DAC\x60s on '"${USER}"$'\x60s copy'
    sudo -- rsync --archive --checksum -- "${strng_vrc}" ~/.vimrc || {
      _Fn_error_and_exit_ "${LINENO}"
    }
    sudo -- chown "${UID}:${UID}" -- ~/.vimrc
    chmod 0400 -- ~/.vimrc

    :;:;: " Reset the umask "
    builtin "${umask_prior[@]}"
  fi
  unset arr_vrc strng_vrc WW YY umask_prior

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_test_dns_ "
function _Fn_test_dns_ (){

  #

  ping -c 1 -W 15 -- "$1" > /dev/null 2>&1
  return "$?"

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_test_os_ "
function _Fn_test_os_ (){

  #

  local kern_rel
  kern_rel=$(
    uname --kernel-release
  )

  ## Note, test of $kern_rel is a test for whether the OS is Fedora (ie,
  #+   "fc38" or "Fedora Core 38")
  if ! [[ ${kern_rel} =~ \.fc[0-9]{2}\. ]]
  then
    _Fn_error_and_exit_ "OS is not Fedora" "${LINENO}"
  fi
  unset kern_rel

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_trap_err_ "
function _Fn_trap_err_ (){


  declare -p BASH BASH_ALIASES BASH_ARGC BASH_ARGV BASH_ARGV0 BASH_CMDS
  declare -p BASH_COMMAND BASH_LINENO BASH_REMATCH BASH_SOURCE BASH_SUBSHELL
  declare -p BASHOPTS BASHPID DIRSTACK EUID FUNCNAME HISTCMD IFS LC_ALL LINENO
  declare -p PATH PIPESTATUS PPID PWD SHELL SHELLOPTS SHLVL UID

}



##
#! Bug, these var assignments $prev_cmd_exit_code and $lineno only fail wh
#+   they\re on line number >=2 of  trap  "args section" ??

:;:;: " Line ${nameref_Lineno}, Define \Fn_trap_exit_ "
## Note, these variable assignments must be on the 1st line of the funtion
#+   in order to capture correct data
# shellcheck disable=SC2317
function _Fn_trap_exit_ (){

  #

  trap - EXIT

  :;:;: " Remove temporary directory, if one exists "
  [[ -d ${tmp_dir:=} ]] &&
    "$( type -P rm )" \
        --force --one-file-system --preserve-root=all --recursive \
        "${ver__[@]}" "${tmp_dir}"

  builtin exit "${prev_cmd_exit_code}"

}


##
:;:;: " Line ${nameref_Lineno}, Define \Fn_write_bashrc_strings_ "
function _Fn_write_bashrc_strings_ (){

  #

  :;:;: " Certain parameters must be defined and have non-zero" \
      "values "
  (( ${#files_for_use_with_bash[@]} == 0 )) && {
    _Fn_error_and_exit_ "${LINENO}"
  }
  (( $# == 0 )) && {
    _Fn_error_and_exit_ "${LINENO}"
  }

  local JJ file_x Aa_index Aa_element
  local -n fn_nameref

  :;:;: " For each s\et of strings to append into bashrc"
  for JJ
  do
    :;:;: 'Loop D - open \\\ '

    unset -n fn_nameref
    local -n fn_nameref="${JJ}"

    :;:;: " For each .bashrc"
    for file_x in "${files_for_use_with_bash[@]}"
    do
      :;:;: 'Loop D:1 - open \\\ '

      :;:;: " file_x, ${file_x} "

      :;:;: " For each definition (function or parameter)"
      for Aa_index in "${!fn_nameref[@]}"
      do
        :;:;: 'Loop D:1:a - open \\\ '

        :;:;: " Aa_index, ${Aa_index} "
        Aa_element="${fn_nameref[${Aa_index}]}"

        :;:;: "(1) If the definition is not yet written into the" \
            "file... "
        if ! sudo -- grep --quiet --fixed-strings "## ${Aa_index}" -- "${file_x}"
        then

          :;:;: " Then write the function definition into the" \
              "file "
          printf '\n## %s \n%s \n' "${Aa_index}" "${Aa_element}" |
            sudo -- tee --append -- "${file_x}" > /dev/null || {
              _Fn_error_and_exit_ "${LINENO}"
            }
        else
          :;:;: " Definition exists, skipping "
        fi

        ## Bug, what if it\s a multiline alias?

        ## Question, can `sed` take variable assignments the way `awk` can?

        :;:;: "(2) If there is an alias by the same name, then" \
            "delete it from the bashrc file at hand... "
        sudo -- sed --in-place "/^alias ${Aa_index##* }=/d" -- "${file_x}"

        :;:;: " Loop D:1:a - shut /// "
      done
      unset Aa_element
      :;:;: " Loops D:1:a - complete === "

      :;:;: " For each file, if absent add a newline at EOF "
      if  sudo -- tail --lines 1 -- "${file_x}" |
            grep --quiet --extended-regexp "[[:graph:]]"
      then
        printf '\n' |
          sudo -- tee --append -- "${file_x}" > /dev/null
      fi

      :;:;: " Loop D:1 - shut /// "
    done
    :;:;: " Loops D:1 - complete === "

    :;:;: " Reset for the next loop, assuming there is one "
    ## Note, ?? use  unset  so that values from previous loops will not interfere
    #+   with the current loop
    shift

    :;:;: " Loop D - shut /// "
  done
  unset JJ
  :;:;: " Loops D - complete === "

}


#! ToDo, look at how each conf file is defined and written, each one's a little
#+   different. Make them uniform with each other, since the purpose of each
#+   section is the same in each case.


##
:;:;: " Define \Fn__write_ssh_conf_ "
function _Fn_write_ssh_conf_ (){
  #

  #! Bug? $ssh_user_conf_file defined in a different function, \Fn_setup_ssh_

  cat <<- \EOF > "${ssh_user_conf_file}"
	Host github.com
	ForwardAgent yes

	EOF

}


##
:;:;: " Define \Fn__run_restorecon_ "
function _Fn__run_restorecon_(){
  local tt=$( date '+%F_%H-%M-%S')
  local ff=~/restorecon
  local files=( "${ff}"_* )

  for FF in "${files[@]}"
  do
    if [[ -f ${FF} ]] \
      && [[ ! -L ${FF} ]]
    then
      rm -fv "${FF}"
    fi
  done
  
  {
    sudo restorecon -F -D -m -R / \
      |& grep -v "Operation not supported"
  } \
    | tee -a "${ff}_${tt}_o"
}


##
:;:;: " Line ${nameref_Lineno}, Functions Complete "

#! ToDo, perhaps there should be a "main" function.


##
#! Note, traps:
#!   EXIT -- for exiting
#!   HUP USR1 TERM KILL -- for restarting processes
#!   INT QUIT USR2 -- for stopping logging
#!   For starting logging ?

:;:;: " Line ${nameref_Lineno}, Define trap on ERR "
trap _Fn_trap_err_ ERR

:;:;: " Line ${nameref_Lineno}, Define trap on EXIT "
trap _Fn_trap_exit_ EXIT

    _Fn_verbose_flags_

##
:;:;: " Line ${nameref_Lineno}, Regular users with sudo, only "
_Fn_must_be_root_


##
:;:;: " Line ${nameref_Lineno}, Test OS "
_Fn_test_os_

  #
  #exit "${LINENO}"
  builtin set -x

##
:;:;: " Line ${nameref_Lineno}, Run r\estorecon "
_Fn__run_restorecon_

  #
  exit "${LINENO}"
  builtin set -x


##
:;:;: " Line ${nameref_Lineno}, Certain files must have been" \
    "installed from off-disk "
#_Fn_reqd_user_files_

  #builtin exit 101
  #


##
:;:;: " Line ${nameref_Lineno}, Network "
_Fn_setup_network_

  #


##
:;:;: " Line ${nameref_Lineno}, Time "
_Fn_setup_time_

  #
  #declare -p
  #exit 101

##
:;:;: " Line ${nameref_Lineno}, Temporary directory "
_Fn_setup_temp_dirs_

  #


##
:;:;: " Line ${nameref_Lineno}, Minimum necessary rpms "
_Fn_min_necc_packages_

  #


##
:;:;: " Line ${nameref_Lineno}, Vim "
_Fn_setup_vim_

  #


##
:;:;: " Line ${nameref_Lineno}, Bash "
_Fn_setup_bashrc_

  #


##
:;:;: " Line ${nameref_Lineno}, Increase disk space "
_Fn_increase_disk_space_

  #


##
:;:;: " Line ${nameref_Lineno}, Dnf "
_Fn_setup_dnf_

  #


##
:;:;: " Line ${nameref_Lineno}, Restart NetworkManager if" \
    "necessary "
#! ToDo: use written function here
for BB in "${dns_srv_A}" "${dns_srv_1}"
do
  if ! ping -4qc1 -- "${BB}" > /dev/null 2>&1
  then
    sudo -- nice --adjustment=-20 -- systemctl restart -- NetworkManager.service || {
      _Fn_error_and_exit_ "${LINENO}"
    }
  fi
done
unset BB


##
:;:;: " Line ${nameref_Lineno}, SSH "
_Fn_setup_ssh_

  #


##
:;:;: " Line ${nameref_Lineno}, GPG "
_Fn_setup_gpg_

  #


##
:;:;: " Line ${nameref_Lineno}, Make and change into directories "
_Fn_setup_gti_user_dirs_

  #


##
:;:;: "Git debug settings"
#_Fn_enable_git_debug_settings_


##
:;:;: " Line ${nameref_Lineno}, Git "
_Fn_setup_git_

  #


##
:;:;: " Line ${nameref_Lineno}, GH -- github CLI configuration "
_Fn_setup_gh_cli_

  #


##
:;:;: " Line ${nameref_Lineno}, Clone repo "
_Fn_clone_repo_

  #


##
:;:;: " Line ${nameref_Lineno}, Remind user of commands for the" \
    "interactive shell "

popd > /dev/null || {
  _Fn_error_and_exit_ "${LINENO}"
}


##
if ! [[ ${PWD} = ${local_dir_1}/${script__repo_name} ]]
then
  printf '\n  Now run this command: \n'
  printf '\n\t cd "%s/%s" ; git status \n\n' "${local_dir_1}" "${script__repo_name}"
fi

  set -v ## <>


##
:;:;: " Line ${nameref_Lineno}, Clean up & exit "
printf '  %s - Done \n' "$( date +%H:%M:%S )"
exti_code=00
main_lineno="${nameref_Lineno}" exit

