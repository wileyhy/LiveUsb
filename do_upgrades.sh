#!/bin/bash


## Note, it\s written so that there's only ever just one "needs-restarting" file

## ToDo next, a write_data() function
#+	Files created:
#+		aux [ps]
#+		list-unit-files [systemctl]
#+		needs-restarting [dnf]
#+		status [systemctl]


## Functions, TOC
#+	diff_outputs()
#+	directories_must_exist()
#+	get_list_of()
#+	get_list_rpms_for_upgrade()
#+	get_next_rpm_for_upgrade()
#+	main()
#+	must_use_sudo()
#+	pause_to_check()
#+	pre_diff__two_files_only()
#+	reexecute_daemons()
#+	pre_cmd__remove_files()
#+	reqd_initial_settings()
#+	restart_programs()
#+	restart_pids()
#+	set_variables()
#+	upgrade_next_rpm()


## Usage, \diff_outputs status\
diff_outputs ()
{ 
  local -
  set -Ceux

  local l_file_template
  l_file_template="${g_upgrades_data_d}/${1}"

    [[ -n ${l_file_template} ]] || exit "${LINENO}" ## <>

    local l_list_files ## <>
    l_list_files=( "${l_file_template}"_* ) ## <>
    [[ ${#l_list_files[*]} -eq 2 ]] || exit "${LINENO}" ## <>
    unset l_list_files ## <>

  diff -- "${l_file_template}"*

    :;:
    pause_to_check ## <>
    :;:

  unset l_file_template
}

## Usage, \directories_must_exist dir1 dir2 ...\
directories_must_exist ()
{ 
  local -
  set -Ceu +x

  local -a l_dirs
  local EE
  local -n FF

  readarray -d "" -t l_dirs < <( export | awk '$3 ~ /^g_[_a-z]*.d/ { printf "%s\0", $3 }' | cut -zd"=" -f1 )

    : "count, l_dirs[@]:" "${#l_dirs[@]}" ## <>

  for EE in "${l_dirs[@]}"
  do
      : "EE:" "${EE}" ## <>

    unset -n FF
    local -n FF
    local -n FF="${EE}"

      : "FF:" "${FF}" ## <>

    if ! [[ -e ${FF} ]]
    then
      mkdir -m 0700 "${FF}" || exit "${LINENO}"

    elif ! [[ -d ${FF} ]]
    then
      exit "${LINENO}"
    fi
  done

  unset EE l_dirs
  unset -n FF
}


## Usage, \get_list_of [subcommand]\
get_list_of ()
{ 
  local -
  set -Ceux

  local -Ig g_time
  g_time=$( builtin printf "%(%s)T" )

    declare -p g_time
    #: "g_time:" "${g_time}"
    : "g_upgrades_data_d:" "${g_upgrades_data_d}"
        
  local l_file_template l_subcmd
  l_file_template="${g_upgrades_data_d}/${1}"
  l_subcmd="$1"

    : "l_file_template:" "${l_file_template}"
    : "l_subcmd:" "${l_subcmd}"

  case "${l_subcmd}" in
    aux )
	ps aux | tee -- "${l_file_template}_${g_time}"
        ;; ##
    list-unit-files )
        sudo systemctl list-unit-files | 
          awk '$1 ~ /automount|mount|path|scope|service|slice|socket|swap|target|timer/' | 
	  tee -- "${l_file_template}_${g_time}"
        ;; ##
    needs-restarting )
        local -Ig g_dnf_hist
	g_dnf_hist=$( dnf history | awk 'NR == 3 { print $1 }' )

          declare -p g_dnf_hist
          #: "g_time:" "${g_time}"

	## SO TIRED!

	local l_list_nr
	readarray -d "" -t l_list_nr < <( find "${g_upgrades_data_d}" -type f -name "${l_subcmd}*" -printf0 )
	case ${#l_list_nr[@]} in
		0) : ;; ##
		1) if ! [[ ${l_list_nr[0]##*_} = ${g_dnf_hist} ]]
                   then
                     pre_cmd__remove_files "${l_subcmd}"
		   else
                     	   :
                   fi
		   ;; ##
		*) pre_cmd__remove_files "${l_subcmd}" ;; ##
	esac

	if 
	  readarray -d "" -t l_list_nr < <( find "${g_upgrades_data_d}" -type f -name "${l_subcmd}*" -printf0 )
        fi	  
	if [[ -z ${#l_list_nr[0]} ]] ||
          ! [[ -f ${#l_list_nr[0]} ]]
          ! [[ ${l_list_nr[0]##*_} = ${g_dnf_hist} ]] ||
          [[ ${#l_list_nr[*]} -gt 1 ]]
        then
          sudo dnf --cacheonly needs-restarting | 
	    tee -- "${g_upgrades_data_d}/${l_subcmd}_${g_dnf_hist}"
        ;; ##
    status )
        sudo systemctl status | tee -- "${l_file_template}_${g_time}"
        ;; ##
    * ) exit "${LINENO}"
        ;; ##
  esac
  unset l_file_template l_subcmd
}


## Usage, \get_list_rpms_for_upgrade [security|bugfix]\
get_list_rpms_for_upgrade ()
{ 
  local -
  set -Ceux

  local -Iga g_rpms_2_upgrade
  local l_upgrade_type
  l_upgrade_type="$1"

    : "l_upgrade_type:" "${l_upgrade_type}" ## <>

  time readarray -t g_rpms_2_upgrade < <(
    sudo dnf --assumeno --cacheonly --sec-severity=Low "--${l_upgrade_type}" upgrade 2>&1 |
      awk '$2 ~ /noarch|x86_64/ { print $1 }' )

    : "count 1 of 3, g_rpms_2_upgrade[@]:" "${#g_rpms_2_upgrade[@]}" ## <>

  unset l_upgrade_type
}


get_next_rpm_for_upgrade ()
{ 
  local -
  set -Ceux

  local -Iga g_rpms_2_upgrade
  local DD
  local -a l_types
  g_rpms_2_upgrade=()

    : "count, g_rpms_2_upgrade[@]:" "${#g_rpms_2_upgrade[@]}" ## <>
    : "g_types_of_upgrades[@]:" "${g_types_of_upgrades[@]}" ## <>

  for DD in "${!g_types_of_upgrades[@]}"
  do
      : "index, DD:" "${DD}" ## <>
      :
    :;:
    get_list_rpms_for_upgrade "${g_types_of_upgrades[DD]}"
    :;:
      ## <> Note, defined in get_list_rpms_for_upgrade()
      : "count 2 of 3, g_rpms_2_upgrade[@]:" "${#g_rpms_2_upgrade[@]}" ## <>
      :
    if [[ ${#g_rpms_2_upgrade[@]} -eq 0 ]]
    then
        : "g_types_of_upgrades:" "${g_types_of_upgrades}" ## <>

      unset "g_types_of_upgrades[DD]"
      continue
    else
      break
    fi
  done
  unset DD

    : "count 3 of 3, g_rpms_2_upgrade[@]:" "${#g_rpms_2_upgrade[@]}" ## <>
    : "rpm, g_rpms_2_upgrade[0]:" "${g_rpms_2_upgrade[0]}" ## <>
}


main ()
{ 
  local -
  set -Ceux
  :;:
  reqd_initial_settings
  :;:
  set_variables
  :;:
  must_use_sudo
  :;:
  directories_must_exist
  :;:
  refresh_dnf_cache
  :;:

  ## Must complete any previous group of restarts before upgrading any more rpms
  pre_cmd__remove_files "needs-restarting"
  :;:
  reexecute_daemons
  :;:
  get_list_of "needs-restarting"
  :;:
  if [[ -s "${g_upgrades_data_d}/needs-restarting" ]]
  then
    :;:
    restart_programs
    :;:

      exit 101 ## <>

    :;:
    restart_pids
    :;:
  else
    exit 77
  fi
  :

  ## Main loop
  while true
  do
    :;:
    network_up
    :;:
    get_next_rpm_for_upgrade
    :;:
    upgrade_next_rpm
    :;:
    network_down
    :;:

      exit 101 ## <>

    :;:
    reexecute_daemons
    :;:
    get_list_of "needs-restarting"
    :;:
    pause_to_check ## <>
    :;:
    for HH in "aux" "status" "list-unit-files" "needs-restarting"
    do
      :;:
      pre_diff__two_files_only "${HH}"
      :;:
      diff_outputs "${HH}"
      :;:
    done
    :;:
    restart_programs
    :;:

      exit 101 ## <>

    :;:
    restart_pids
    :;:

      exit 101 ## <>

  done
}


must_use_sudo ()
{ 
  local -
  set -Ceu +x

  if ! sudo -v --
  then
    printf '\nUse of sudo is required.\n\n'
    exit "${LINENO}"
  fi
}


network_down ()
{
  local -
  set -Ceu +x

  local II
  local -a interfaces_down

  readarray -t interfaces_down < <( ip a | awk '$1 ~ /^[0-9]+/ && $2 !~ /^lo/ { print $2 }' | tr -d ':' )
  for II in "${interfaces_down[@]}"
  do
    nmcli device disconnect -- "${II}"
  sleep 1
  done
  nmcli radio wifi off
  sleep 1
  nmcli networking off #|| exit "${LINENO}"
  sleep 1
}


network_up ()
{
  local -
  set -Ceu +x

  local JJ
  local -a interfaces_up

  :;:
  sysd_svc_reqd firewalld
  :;:
  ! [[ "$( firewall-cmd --state )" = "running" ]] && exit "${LINENO}"
  :;:
  sysd_svc_reqd NetworkManager
  :;:

  nmcli networking on
  sleep 1
  nmcli radio wifi on
  sleep 10
  readarray -t interfaces_up < <( ip a | awk '$1 ~ /^[0-9]+/ && $2 !~ /^lo/ { print $2 }' | tr -d ':' )
  for JJ in "${interfaces_up[@]}"
  do
    nmcli device connect -- "${JJ}"
  sleep 1
  done
}


pause_to_check ()
{ 
  local -
  set -Ceux

  local -a KK
  local l_reply
  KK=()
  KK+=("$@")

    [[ -n ${g_scr_nm} ]] || exit "${LINENO}" ## <>

  [[ -n ${KK[*]:0:1} ]] && printf '\n%s, %s(), %s\n' "${g_scr_nm}" "${FUNCNAME[0]}" "${KK[@]}" 1>&2
  printf '\n[Y|y|(enter)|(space)] is yes\nAnything else is { no and exit }\n' 1>&2

  if ! read -N1 -p $'\nReady?\n' -rst 600 l_reply 1>&2; then
    printf '\nExiting, line %d\n\n' "${KK}" 1>&2
    exit "${LINENO}"
  fi

  case "${l_reply}" in
    Y* | y* | $'\n' | \ )
      printf '\nOkay\n\n' 1>&2
    ;; ##
    *)
      printf '\nExiting, line %d\n\n' "${KK}" 1>&2
      exit "${LINENO}"
    ;; ##
  esac

  unset KK l_reply
}


## Usage, \pre_diff__two_files_only [subcommand]\
pre_diff__two_files_only ()
{ 
  local -
  set -Ceux

  local -Ig g_time
  g_time=$( builtin printf "%(%s)T" )
  
    declare -p g_time
    #: "g_time:" "${g_time}" ## <>

  local CC l_file_template l_oldest_f l_sub_cmd 
  local -a l_files
  l_file_template="${g_upgrades_data_d}/${1}"
  l_oldest_f=""
  l_sub_cmd="$1"

    : "l_file_template:" "${l_file_template}" ## <>
    : "l_sub_cmd:" "${l_sub_cmd}" ## <>
    : "l_file_template:" "${l_file_template}" ## <>

  while true; do
    l_files=( "${l_file_template}"_* )

      : "count, l_files[@]" "${#l_files[@]}" ## <>

    case "${#l_files[*]}" in
      0 | 1)

        systemctl -- "${l_sub_cmd}" > "${l_file_template}_${g_time}"
        sleep 1
      ;; ##
      2)
        break
      ;; ##
      *)
        unset l_oldest_f
        local l_oldest_f

        for CC in "${!l_files[@]}"
        do
            : "CC:" "${CC}" ## <>

	  if [[ -z ${l_oldest_f:=} ]] || [[ ${l_files[CC]} -ot ${l_oldest_f} ]]; then
            l_oldest_f="${l_files[CC]}"
          fi
        done
	unset CC

        /bin/rm -f --one-file-system --preserve-root=all --verbose -- "${l_oldest_f}" || exit "${LINENO}"
        :
        :
      ;; ##
    esac
  done
  unset l_file_template l_files l_oldest_f l_sub_cmd
}


reexecute_daemons ()
{ 
  local -
  set -Ceu +x

  sudo -- systemctl -- daemon-reexec

    wait -f ## <>
    : "reexec..." $? ## <>
}


refresh_dnf_cache ()
{
  local -
  set -Ceu +x

  local l_cache_age l_cache_size
  readarray -t l_cache_age < <( find /var/cache/dnf -ctime 2 ) 
  l_cache_size=$( du -s /var/cache/dnf | cut -d $'\t' -f1 )

  if [[ ${l_cache_size} -lt 25000 ]] || [[ ${#l_cache_age[@]} -gt 0 ]]
  then
    :;:
    network_up
    :;:
    sudo -- dnf makecache
    :;:
    network_down
    :;:
  fi
}


## Usage, \pre_cmd__remove_files [subcommand]\
pre_cmd__remove_files ()
{ 
  local -
  set -Ceu +x

  local -Ig g_upgrades_data_d
  local GG l_data_file_basename
  local -a l_datafile_list
  l_data_file_basename="${1}"

  readarray -d "" -t l_datafile_list < <(
    find "${g_upgrades_data_d}/" -type f -name "${l_data_file_basename}*" -print0 || exit "${LINENO}" )

    : "count, l_datafile_list[@]:" "${#l_datafile_list[@]}" ## <>

  for GG in "${l_datafile_list[@]}"
  do
      : "GG:" "${GG}"

    if [[ -f ${GG} ]]
    then
      /bin/rm -f --one-file-system --preserve-root=all --verbose -- "${GG}" || exit "${LINENO}"
    fi
  done

  unset GG l_data_file_basename l_datafile_list
}


reqd_initial_settings ()
{ 
  local -
  set +x

  set -a
  hash -r
}


restart_programs ()
{ 
  ## Search for names of programs from "needs-restarting" in output of "list-unit-files" and in the default
  #+  directory for SystemD service files.

  local -
  set -Ceux

  ## List Unit Files

  local -Ig g_time
  g_time=$( builtin printf "%(%s)T" ) ## No files are written in this function at this level, so no need to set time

    declare -p g_time
    #: "g_time:" "${g_time}"

  local l_sub_command l_file_template
  l_sub_command=list-unit-files
  l_file_template="${g_upgrades_data_d}/${l_sub_command}"

    : "l_file_template:" "${l_file_template}"

  :;:
  get_list_of "${l_sub_command}"
  :;:
  local -a l_systemctl_luf
  readarray -t l_systemctl_luf < "${l_file_template}_${g_time}"
  unset l_sub_command

    : 'count, l_systemctl_luf[@]:' "${#l_systemctl_luf[@]}" ## <>

  ## Needs Restarting

  local l_sub_command
  local -a l_programs_4_restart
  l_sub_command=needs-restarting
  
  if ! [[ -e "${g_upgrades_data_d}/${l_sub_command}" ]]
  then
    :;:
    get_list_of "${l_sub_command}"
    :;:
  fi

  readarray -t l_programs_4_restart < <( awk '{ print $3 }' "${g_upgrades_data_d}/${l_sub_command}" )
  unset l_sub_command

    : "count, l_programs_4_restart[@]:" "${#l_programs_4_restart[@]}" ## <>

  ## Search for names of programs...

  local AA
  for AA in "${l_programs_4_restart[@]}"
  do
      : "AA:" "${AA}"
    { 
      grep --color=auto "${AA##*/}" <<< "${l_systemctl_luf}"
      grep --color=auto -ril "${AA}" -- /usr/lib/systemd/system
    }
  done
  unset AA

    exit 101 ## <>
}


restart_pids ()
{ 

  local -a l_pids_4_restart
  readarray -t l_pids_4_restart < <( awk '{ print $1 }' "${g_upgrades_data_d}/${l_sub_command}" )

    : "count, l_pids_4_restart[@]:" "${#l_pids_4_restart[@]}" ## <>

  
  ## Set the order for killing PID\s
  
  
  ## Reverse numerical
  printf '%d\n' "${l_pids_4_restart[@]}" | sort -nr


  ## Whichever has more than 1 line in `ps axfj`, kill last




  ## Do the kill loop
  local BB
  for BB in "${l_pids_4_restart[@]}"
  do
      : "BB:" "${BB}"

    ## Make sure the PID still exists
    ps -p "${BB}" -o user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,cmd

    pause_to_check

    "$( type -P kill )" \
      --timeout 1000 HUP \
      --timeout 1000 USR1 \
      --timeout 1000 TERM \
      --timeout 1000 KILL --verbose -- "${BB}"
    sleep 3 &
    sync -f &
    wait -f
  done
  unset BB

  :;:
  reexecute_daemons
  :;:
  get_list_of "needs-restarting"
  :;:
    pause_to_check ## <>
  :;:

  unset AA BB l_programs_4_restart l_pids_4_restart l_systemctl_luf
}


set_variables ()
{ 
  local -
  set -Ceu +x

  local -g LC_ALL PATH
  LC_ALL=C readonly LC_ALL
  PATH="/usr/bin:/usr/sbin" || exit "${LINENO}"
  readonly PATH

    : "LC_ALL:" "${LC_ALL}" ## <>
    : "PATH:" "${PATH}" ## <>

  local -g g_diff_data_d g_scr_nm g_upgrades_data_d
  g_diff_data_d=~/diff.d readonly g_diff_data_d
  g_scr_nm="${scr_nm:="do_upgrades.sh"}" readonly g_scr_nm
  g_upgrades_data_d=~/upgrades.d readonly g_upgrades_data_d

    : "g_diff_data_d:" "${g_diff_data_d}" ## <>
    : "g_scr_nm:" "${g_scr_nm}" ## <>
    : "g_upgrades_data_d:" "${g_upgrades_data_d}" ## <>

  local -g g_dnf_hist g_time
  g_dnf_hist=$( dnf history | awk 'NR == 3 { print $1 }' )
  g_time=$( builtin printf "%(%s)T" )

    declare -p g_dnf_hist g_time
    #: "g_time:" "${g_time}"

  local -ga g_rpms_2_upgrade g_types_of_upgrades
  g_rpms_2_upgrade=()
  g_types_of_upgrades=(security bugfix)

    : "g_rpms_2_upgrade[@]:" "${g_rpms_2_upgrade[@]}" ## <>
    : "g_types_of_upgrades[@]:" "${g_types_of_upgrades[@]}" ## <>
}


## Usage, \sysd_svc_reqd [Name.service]\
sysd_svc_reqd ()
{
  local
  set -Ceux

  local l_svc_nm
  l_svc_nm="$1"

    : "l_svc_nm:" "${l_svc_nm}"

  if ! [[ "$( systemctl is-active -- "${l_svc_nm}.service" )" = "active" ]]
  then
    sudo -- systemctl start -- "${l_svc_nm}.service"
    sleep 5
    ! [[ "$( systemctl is-active -- "${l_svc_nm}.service" )" = "active" ]] && exit "${LINENO}"
  fi
  unset l_svc_nm
}


upgrade_next_rpm ()
{ 
  local -
  set -Ceux

    [[ -n ${g_rpms_2_upgrade[0]} ]] || exit "${LINENO}" ## <>

  if ! sudo dnf --assumeyes --cacheonly upgrade -- "${g_rpms_2_upgrade[0]}"
  then
    sudo dnf --assumeyes upgrade -- "${g_rpms_2_upgrade[0]}"
  fi

  :;:
  pre_cmd__remove_files "needs-restarting"
  :;:
}


## Note, what I\d like to do here is sanitize the environment using `env -` and local variables, but I
#+  haven\t worked it through quite yet.
#env -i bash -c main
#bash -c main
main

