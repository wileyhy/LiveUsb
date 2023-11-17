#!/bin/bash -Ceux
# setup_firewall()

  ## Checklist

## Aliases
## Note, Creating an alias with a timeout option for all commands? ...is not allowed with firewall-cmd
declare -nx nL=L\INENO
shopt -s expand_aliases
alias firewall-cmd='LN="${nL}"; firewall-cmd'


## Exit codes are very useful with `firewall-cmd`, so...
g_ro_firewall_command_error_codes=(
  [1]="QUERY_FAIL" [2]="WRONG_CLI_OPTION" [11]="ALREADY_ENABLED" [12]="NOT_ENABLED" [13]="COMMAND_FAILED"
  [14]="NO_IPV6_NAT" [15]="PANIC_MODE" [16]="ZONE_ALREADY_SET" [17]="UNKNOWN_INTERFACE"
  [18]="ZONE_CONFLICT" [19]="BUILTIN_CHAIN" [20]="EBTABLES_NO_REJECT" [21]="NOT_OVERLOADABLE"
  [22]="NO_DEFAULTS" [23]="BUILTIN_ZONE" [24]="BUILTIN_SERVICE" [25]="BUILTIN_ICMPTYPE"
  [26]="NAME_CONFLICT" [27]="NAME_MISMATCH" [28]="PARSE_ERROR" [29]="ACCESS_DENIED" [30]="UNKNOWN_SOURCE"
  [31]="RT_TO_PERM_FAILED" [32]="IPSET_WITH_TIMEOUT" [33]="BUILTIN_IPSET" [34]="ALREADY_SET"
  [35]="MISSING_IMPORT" [36]="DBUS_ERROR" [37]="BUILTIN_HELPER" [38]="NOT_APPLIED" [100]="INVALID_ACTION"
  [101]="INVALID_SERVICE" [102]="INVALID_PORT" [103]="INVALID_PROTOCOL" [104]="INVALID_INTERFACE"
  [105]="INVALID_ADDR" [106]="INVALID_FORWARD" [107]="INVALID_ICMPTYPE" [108]="INVALID_TABLE"
  [109]="INVALID_CHAIN" [110]="INVALID_TARGET" [111]="INVALID_IPV" [112]="INVALID_ZONE"
  [113]="INVALID_PROPERTY" [114]="INVALID_VALUE" [115]="INVALID_OBJECT" [116]="INVALID_NAME"
  [117]="INVALID_FILENAME" [118]="INVALID_DIRECTORY" [119]="INVALID_TYPE" [120]="INVALID_SETTING"
  [121]="INVALID_DESTINATION" [122]="INVALID_RULE" [123]="INVALID_LIMIT" [124]="INVALID_FAMILY"
  [125]="INVALID_LOG_LEVEL" [126]="INVALID_AUDIT_TYPE" [127]="INVALID_MARK" [128]="INVALID_CONTEXT"
  [129]="INVALID_COMMAND" [130]="INVALID_USER" [131]="INVALID_UID" [132]="INVALID_MODULE"
  [133]="INVALID_PASSTHROUGH" [133]="INVALID_PASSTHROUGH" [134]="INVALID_MAC" [135]="INVALID_IPSET"
  [136]="INVALID_ENTRY" [137]="INVALID_OPTION" [138]="INVALID_HELPER" [139]="INVALID_PRIORITY"
  [140]="INVALID_POLICY" [141]="INVALID_LOG_PREFIX" [142]="INVALID_NFLOG_GROUP" [143]="INVALID_NFLOG_QUEUE"
  [200]="MISSING_TABLE" [201]="MISSING_CHAIN" [202]="MISSING_PORT" [203]="MISSING_PROTOCOL"
  [204]="MISSING_ADDR" [205]="MISSING_NAME" [206]="MISSING_SETTING" [207]="MISSING_FAMILY"
  [251]="RUNNING_BUT_FAILED" [252]="NOT_RUNNING" [253]="NOT_AUTHORIZED" [254]="UNKNOWN_ERROR"
)
readonly -a g_ro_firewall_command_error_codes


## Functions
:;: "Define fn_fwcmd_exit()";:
fn_fwcmd_exit(){
  local - l_exit_code="$?" l_lineno="${LN:="${nL}"}" l_prev_cmd="$BASH_COMMAND"
  #set - ## []
 
  if ! [[ ${l_prev_cmd} =~ firewall-cmd ]]
  then
    printf 'bash, EXIT trap, previous command, <%s>\n' "$l_prev_cmd"
    return "${l_exit_code}"
  fi

  if [[ ${l_exit_code} = 0 ]]
  then
    return 0
  elif 
    local l_regexp
    l_regexp='\<'"${l_exit_code}"'\>'
    [[ "${!g_ro_firewall_command_error_codes[@]}" =~ $l_regexp ]]
  then
    printf 'Error, firewall-cmd, Line %s, %s\n' "${l_lineno}" "${g_ro_firewall_command_error_codes[l_exit_code]}"
  fi
}

## Traps
trap fn_fwcmd_exit EXIT


  #bash -c 'exit 11' ## <>
  #firewall-cmd --permannt --set-default-zone=drop; echo $? ## <>
  #exit 101 ## <>


#### Network connectivity should be disconnected, radio should be off, etc

## Is NetworkManager running?
systemctl is-active NetworkManager.service
  #+  "active"
nmcli -t -f RUNNING general
  #+  "running"



custom_svc_file_nm=stop-network-manager.service
custm_svc_f="/etc/systemd/system/${custom_svc_file_nm}"
tmp_f="/tmp/${custom_svc_file_nm}" readonly tmp_f
tmp_time=$( date '+%Y-%m-%d %H:%M:%S.%N' )

for FF in "${tmp_f}" "${custm_svc_f}"
do
	if [[ -e ${FF} ]]
	then
		sudo chattr -ai "${FF}"
		sudo rm -fv "${FF}"
	fi
done

while true
do	
	## Note these times are all observed from an F39 instance in which "relatime" is the kernel's 
	#+	default mount option. 

	## "relatime": `touch -d` writes atime and mtime as $tmp_time, but ctime and btime are 15/1,000's of a second 
	#+	later and match each other; none of the x4 timestamps reflect the execution time of `stat`.
	date '+%Y-%m-%d %H:%M:%S.%N'
	touch -d "${tmp_time}" "${tmp_f}"
	sleep 1.5
	date '+%Y-%m-%d %H:%M:%S.%N'
	stat "${tmp_f}"
	
	## "relatime": `chmod` only changes the ctime; a-, m- and b-times remain the same
	date '+%Y-%m-%d %H:%M:%S.%N'
	chmod 0200 "${tmp_f}"
	sleep 1.5
	date '+%Y-%m-%d %H:%M:%S.%N'
	stat "${tmp_f}"

	## "relatime": `printf` alters mtime and ctime to the same time, but atime and btime both remain unchanged, 
	#+	and remain as they were initially
	date '+%Y-%m-%d %H:%M:%S.%N'
	( set +C; printf '\0' > "${tmp_f}" )
	sleep 1.5
	date '+%Y-%m-%d %H:%M:%S.%N'
	stat "${tmp_f}"
	
	## "relatime": again, running `stat` has zero effect on any of the x4 timestamps
	stat_of_file_t=$( stat -c%x "${tmp_f}" ); stat_of_file_t="${stat_of_file_t% *}"
	stat "${tmp_f}"
	
	if 
		[[ "$( stat -c%h "${tmp_f}" )" -ne 1 ]] ||
		! [[ ${stat_of_file_t} = "${tmp_time}" ]]
	then 
		red_flag=b
		rm -f "${tmp_f}"
		if [[ ${red_flag} =~ "bbb" ]]
		then 
			echo Emergency
			exit "${LINENO}"
		continue
		fi
	fi
	break
done

## "relatime": `chown` only changes ctime
sudo chown 0:0 "${tmp_f}"
stat "${tmp_f}"

## "relatime": `chattr` also only changes ctime
sudo chattr +a "${tmp_f}"
stat "${tmp_f}"

## "relatime": `tee -a` changes the mtime and ctime to the same value, and leaves atime and btime untouched.
cat <<- \EOF | sudo tee -a "${tmp_f}"
	[Unit]
	Description=Stop NetworkManager

	[Service]
	Type=oneshot
	ExecStart=/bin/systemctl stop NetworkManager

EOF

## "relatime": again, `chattr` only changes the ctime
sudo chattr +i -a "${tmp_f}"

## "relatime": `lsattr` doesn't changes any timestamps
lsattr "${tmp_f}"

## "relatime": ..and `ls` also doesn't change any timestamps
ls -alhFi "${tmp_f}"

if [[ "$( stat -c%h "${tmp_f}" )" -ne 1 ]]
then 
  #sudo chattr -ai "${tmp_f}"
  #rm -f -- "${tmp_f}"
  exit "${LINENO}"
fi

sudo touch -d "${tmp_time}" "${custm_svc_f}"
stat "${custm_svc_f}"
sudo chattr +a "${custm_svc_f}"

sudo cat "${tmp_f}" | tee -a "${custm_svc_f}"

if [[ "$( stat -c%h "${tmp_f}" )" -ne 1 ]]
then 
  #sudo chattr -ai "${tmp_f}"
  #sudo rm -f -- "${tmp_f}"
  exit "${LINENO}"
fi

sudo chattr +i -a "${custm_svc_f}"
sudo chattr -ai "${tmp_f}"
sudo rm -f -- "${tmp_f}"

## "relatime": `sha256sum` changes the atime only. `md5sum` and `sha1sum` follow the same pattern.
read -r XX YY < <( sha256sum AA BB | awk '{ printf "%s ", $1 }' )
[[ ${XX} = "${YY}" ]] || exit "${LINENO}"

## "relatime": An attempt to write to this file with `dd` was prevented by `chattr` and as a result none of the 
#+	four timestamps were altered
sudo dd if=/dev/zero of="${tmp_f}" bs=1 count=$( stat -c%s "${tmp_f}" ) status=progress

## "relatime": without immutability, however, `dd` alters mtime and ctime, while leaving atime and btime untouched.
sudo chattr -i "${tmp_f}"
sudo dd if=/dev/zero of="${tmp_f}" bs=1 count=$( stat -c%s "${tmp_f}" ) status=progress

## "relatime": `cat` alters only the atime
cat "${tmp_f}"

## "relatime": an input redirection also alters only the atime
cat < "${tmp_f}"

## Chaning the `mount` options to include "noatime" effects none of the four file timestamps, as expected
mount -o remount,noatime /

## "noatime": `cat` with the "noatime" mount option, however, does not alter any timestamps
cat "${tmp_f}"



sudo rm -f "${tmp_f}"

exit 101

## Lockdown the firewall from the systemd side
svc_nm=firewalld.service; 
svc_file=$( systemctl status "${svc_nm}" | grep -oEe "/[a-z/]*/${svc_nm}" )
svc_options=( 
	[0]="\[Service\]" [1]="\[Service\]" [2]="\[Unit\]" [3]="\[Unit\]"
		[4]="\[Unit\]" [5]="\[Unit\]" 
	[6]="\[Unit\]"
	)
keys=(
	[0]="KillMode" [1]="RefuseManualStop" [2]="Restart" [3]="RestartSec"
		[4]="StartLimitIntervalSec" [5]="StartLimitBurst" 
	[6]="OnFailure"
	)
values=(
	[0]="none" [1]="yes" [2]="always" [3]="1us"
		[4]="30" [5]="10"
	[6]="stop-network-manager.service"
	)

for II in "${!svc_options[@]}"
do
	if ! grep "${svc_option[$II]}" /usr/lib/systemd/system/NetworkManager.service	then
		sudo sed "/${svc_option[$II]}/a ${keys[$II]}=${values[$II]}" "${svc_file}"
	fi
done

exit


## Get data
readarray -d "" -t relevant_cnctns < <(
  nmcli --terse connection show --active |
    awk -F":" '$1 !~ /\<lo\>/  { printf "%s\0", $1 }' |
    sort -z )

readarray -d "" -t relevant_dvcs < <(
  nmcli --terse device |
    awk -F":" '$1 !~ /\<lo\>/  { printf "%s\0", $1 }' |
    sort -z )

readarray -d "" -t relevant_intrfcs < <( 
  ip a | 
    awk -F": " '$1 ~ /[0-9]{1,2}/ && $2 ~ /[[:alnum:]]/ && $2 !~ /\<lo\>/  { printf "%s\0", $2 }' | 
    sort -z )

readarray -d "" -t relevant_srcs < <( 
  ip a | 
    grep -zoEe '\<([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})\>' | 
    grep -zve '00:00:' -e 'ff:ff:' )


## Connections off
for AA in "${relevant_cnctns[@]}"
do
  nmcli connection down "${AA}"
done
unset AA


## Radios off
nmcli radio all off


## Devices off
for BB in "${relevant_dvcs[@]}"
do
  nmcli device disconnect "${BB}"
done
unset BB


## Networking off
nmcli networking off

systemctl try-reload-or-restart NetworkManager.service

## Block all interfaces at the software level
rfkill block all


## Configure devices
for CC in "${relevant_dvcs[@]}"
do
  nmcli device set ifname "${CC}" autoconnect no

  ## What exactly does "managed" mean in this case?
  #nmcli device set ifname "${CC}" managed yes
done
unset CC


## Networking on


## Is FirewallD running?
systemctl is-active firewalld.service
#+  "active"



## Variables
readarray -d "" -t all_zones < <( firewall-cmd --get-zones | tr ' \n' '\0' )
readarray -d "" -t all_policies < <( firewall-cmd --get-policies | tr ' \n' '\0' )
all_zns_and_plcys_target=DROP
default_zn=drop
def_zn_target=DROP
log_deny=unicast
readarray -d "" -t lockdn_cmds < <( firewall-cmd --list-lockdown-whitelist-commands | tr ' \n' '\0' )
readarray -d "" -t lockdn_cntxts < <( firewall-cmd --list-lockdown-whitelist-contexts | tr ' \n' '\0' )
readarray -d "" -t lockdn_uids < <( firewall-cmd --list-lockdown-whitelist-uids | tr ' \n' '\0' )
readarray -d "" -t lockdn_usrs < <( firewall-cmd --list-lockdown-whitelist-users | tr ' \n' '\0' )

  declare -p all_zones all_policies all_zns_and_plcys_target default_zn def_zn_target relevant_intrfcs \
    relevant_srcs log_deny lockdn_cmds lockdn_cntxts lockdn_uids lockdn_usrs
  exit 101



  ## Is the firewall running, according to the firewall itself?  
firewall-cmd --state
  #+  "running"
  
  ## Panic s/b off
firewall-cmd --query-panic && firewall-cmd --panic-off 

  ## Get the "verbose state," as I call it
firewall-cmd --list-all
  #+  $'public (default, active)\n...'

  ## Reset the firewall to begin
firewall-cmd --reset-to-defaults
#firewall-cmd --load-zone-defaults ## Not a useful command for this particular purpose
firewall-cmd --list-all

  ## Get "verbose state," again
firewall-cmd --list-all
  #+  $'public (default, active)\n...'

  ##  Set all possible targets to DROP
  #+    --permanent --set-target --zone
firewall-cmd --permanent --get-zones
  #+  "FedoraServer FedoraWorkstation block dmz drop ..."
firewall-cmd --permanent --get-target --zone=
firewall-cmd --permanent --set-target --zone=

  #+    --permanent --set-target --policy
firewall-cmd --permanent --get-policies
  #+  "allow-host-ipv6 libvirt-routed-in libvirt-routed-out libvirt-to-host"
firewall-cmd --permanent --get-target --policy=
firewall-cmd --permanent --set-target --policy=

  ##    --set-default-zone
firewall-cmd --info-zone
  #+  $'drop\n  target: DROP\n  ...'

firewall-cmd --get-default-zone
firewall-cmd --set-default-zone

  ##    --add-interface=
firewall-cmd --list-interfaces

firewall-cmd --add-interface
firewall-cmd --change-interface
firewall-cmd --get-zone-of-interface
firewall-cmd --query-interface
firewall-cmd --remove-interface

  ##    --add-source=
firewall-cmd --add-source
firewall-cmd --change-source
firewall-cmd --get-zone-of-source
firewall-cmd --list-sources
firewall-cmd --query-source
firewall-cmd --remove-source

  ##    --remove-forward
firewall-cmd --add-forward
firewall-cmd --query-forward
firewall-cmd --remove-forward

  ##    --log-denied
firewall-cmd --get-log-denied
firewall-cmd --set-log-denied

  ##    --remove-masquerade
firewall-cmd --add-masquerade
firewall-cmd --query-masquerade
firewall-cmd --remove-masquerade

  ##    --add-icmp-block
  #+  firewall-cmd --add-icmp-block
  #+  firewall-cmd --list-icmp-blocks
  #+  firewall-cmd --query-icmp-block
  #+  firewall-cmd --remove-icmp-block

  ##    --list-lockdown-whitelist-*
firewall-cmd --list-lockdown-whitelist-commands
firewall-cmd --list-lockdown-whitelist-contexts
firewall-cmd --list-lockdown-whitelist-uids
firewall-cmd --list-lockdown-whitelist-users
firewall-cmd --remove-lockdown-whitelist-command
firewall-cmd --remove-lockdown-whitelist-context
firewall-cmd --remove-lockdown-whitelist-uid
firewall-cmd --remove-lockdown-whitelist-user

  ##    --lockdown-on
firewall-cmd --lockdown-off
firewall-cmd --lockdown-on
firewall-cmd --query-lockdown

  ## Get the lockdown program, and a spare rpm
firewall-cmd --list-lockdown-whitelist-commands
dnf -y install firewall-config
dnf -y --downloadonly --downloaddir=/root reinstall firewall-config
  ## Can the lockdown program run?
firewall-config
  

firewall-cmd --check-config
firewall-cmd --complete-reload
firewall-cmd --reload
firewall-cmd --runtime-to-permanent
firewall-cmd --get-active-zones
firewall-cmd --get-active-policies



## Note, setting log-denied must happen early or it will unset the interfaces and sources.
firewall-cmd --reset-to-defaults; firewall-cmd --check-config;  firewall-cmd --set-log-denied=unicast; firewall-cmd --set-default-zone=drop; firewall-cmd --zone=drop --add-interface=wlo1; firewall-cmd --zone=drop --add-source=46:42:ae:1f:ab:88; firewall-cmd --zone=drop --add-source=20:79:18:b0:59:1e; firewall-cmd --remove-forward; firewall-cmd --remove-lockdown-whitelist-context=system_u:system_r:NetworkManager_t:s0; firewall-cmd --remove-lockdown-whitelist-context=system_u:system_r:virtd_t:s0-s0:c0.c1023; firewall-cmd --remove-lockdown-whitelist-uid=0; firewall-cmd --list-all;  firewall-cmd --get-log-denied;

shopt -s expand_aliases

declare -nx nL=L\INENO
fn_bndry_sh=" ~~~ ~~~ ~~~ "
fn_bndry_lo=" ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~  ~~~ ~~~ ~~~ "
fn_lvl=0
scr_nm="LiveUsb1.sh"

alias als_function_boundary_in='local - _="${fn_bndry_lo} ${fn_bndry_sh} ${FUNCNAME[0]}() BEGINS ${fn_bndry_sh} ${fn_lvl} to $(( ++fn_lvl ))" loc_hyphn="$-" loc_exit_code="${EC:-$?}" loc_lineno="${LN:-$nL}"'

alias als_function_boundary_out='true "${fn_bndry_lo} ${FUNCNAME[1]}()  ENDS  ${fn_bndry_sh} ${fn_lvl} to $(( --fn_lvl ))"'

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

alias die='error_and_exit "${nL}"'

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

## Vars
default_lockdown_whitelist_cmd="/usr/bin/python3 -sP /usr/bin/firewall-config"
list_rpms=( firewall-config macchanger python3 rfkill )
log_deny="unicast"
svc="firewalld.service"
target_def_zn="drop"
readonly default_lockdown_whitelist_cmd list_rpms log_deny svc target_def_zn


## Need rpms
if ping -c1 8.8.8.8 2>/dev/null 1>&2
then
  sudo -- dnf -y install "${list_rpms[@]}" || die
  sudo -- dnf -y upgrade "*firewall*" || die
fi

## Need running service
systemctl is-enabled "${svc}" || sudo -- systemctl enable "${svc}"
systemctl is-active "${svc}" || sudo -- systemctl start "${svc}"


## Need running firewall
XX="1st_attempt" YY="" ZZ=""

while true
do
	## If the firewall isn't running, then...
	if ! [[ "$( firewall-cmd --state )" = "running" ]]
	then
		## ...on the first attempt...
		if [[ -n ${XX} ]] 
		then
			## ...just try to reload/restart it
			sudo -- systemctl try-reload-or-restart "${svc}"

			## And mark step one as done
			XX="" YY="2nd_attempt"

		## ...on the second attempt...
		elif [[ -n ${YY} ]]
		then	
			## ...parse `systemctl status`, and...
			KK=$( systemctl status "${svc}" | 
				awk '/\s*Active:/ { print $2 }' )

			## ...if it isn't active, then...
			if ! [[ ${KK} = "active" ]]
			then
				## ...unmask, enable, start...
				sudo -- systemctl stop "${svc}"
				sudo -- systemctl unmask "${svc}"	
				sudo -- systemctl enable "${svc}"	
				sudo -- systemctl start "${svc}"

				## ...and mark step two as done.
				YY="" ZZ="3rd_attempt"
			fi
			unset KK

		## ...on the third attempt, error out.
		elif [[ -n ${ZZ} ]]
		then
			die "Firewall is down"
		fi
  else 
    break
  fi
done
unset XX YY ZZ


## Zone
if ! [[ "$( firewall-cmd --get-default-zone )" = "${target_def_zn}" ]]
then
	sudo -- firewall-cmd --set-default-zone="${target_def_zn}"

	if ! [[ "$( firewall-cmd --get-default-zone )" = "${target_def_zn}" ]]
	then	
		die "Firewall zone failed to apply"
	fi
fi


## Interfaces
declare -a ip_a_interfaces fwc_assigned_ifcs

## Get the lists of available and assigned (non-loopback) network interfaces
readarray -d "" -t ip_a_interfaces < <( 
  ip a | 
    awk -F": " '$1 ~ /[0-9]{1,2}/ && $2 ~ /[[:alnum:]]/ && $2 !~ /\<lo\>/  { printf "%s\0", $2 }' | 
    sort -z )
readarray -d "" -t fwc_assigned_ifcs < <( 
  firewall-cmd --zone="${target_def_zn}" --list-interfaces | 
    awk 'BEGIN { RS=" " }; { printf "%s\0", $1 }' | 
    sort -z )

## If the counts and strings of each list are not the same, then...
if ! [[ "${#ip_a_interfaces[@]}" -eq "${#fwc_assigned_ifcs[@]}" ]] ||
	! [[ "${ip_a_interfaces[*]}" = "${fwc_assigned_ifcs[*]}" ]]
then
	## ...add each found interface to the default zone...
	for QQ in "${ip_a_interfaces[@]}"
	do
		sudo -- firewall-cmd --zone="${target_def_zn}" --add-interface="${QQ}"
	done

	## ...then verify it. Get the list of assigned interfaces again...
	unset fwc_assigned_ifcs
	readarray -d "" -t fwc_assigned_ifcs < <( 
    firewall-cmd --zone="${target_def_zn}" --list-interfaces | 
      awk 'BEGIN { RS=" " }; { printf "%s\0", $1 }' | 
      sort -z )

	## ...and if the counts and strings of each list are not the same again, then error out.
	if ! [[ "${#ip_a_interfaces[@]}" -eq "${#fwc_assigned_ifcs[@]}" ]] ||
    ! [[ "${ip_a_interfaces[*]}" = "${fwc_assigned_ifcs[*]}" ]]
	then
		die
	fi
fi
#unset ip_a_interfaces fwc_assigned_ifcs


## Sources
[[ -z "${ip_a_interfaces[*]}" ]] && die

## Need interfaces down
for II in "${ip_a_interfaces}"
do
  ifc_state=$( nmcli | awk '$1 ~ /^wlo1/ { print $2 }' )
	if [[ ${ifc_state} = "connected" ]]
  then
    nmcli d disconnect "${II}"
  fi
  unset ifc_state
done
unset II

## For each (non-loopback) interface on the system...
unset all_sys_real_and_fake_macs

## Bug, as I recall, for `macchanger` to work, I have to power down, in 
#+  order, networking, radio, connection and device


for HH in "${ip_a_interfaces[@]}"
do
	## ...reset to permanent MAC addresses, change to a spoofed MAC...
	sudo -- macchanger -p "${HH}" || die
	sudo -- macchanger -ae "${HH}" || die
	
	## ...and get those MAC addresses (real and fake)
	readarray -t macs_per_ifc < <( macchanger -s "${HH}" | 
		grep -oEe '\<([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})\>' )

	for KK in "${macs_per_ifc[@]}"
	do
    ## ...and make uppercase
		all_sys_real_and_fake_macs+=( "${KK^^}" )
	done
	unset KK
done
unset HH

## Get the list of real MAC's directly from `ip a`, just in case
readarray -d "" -t ip_a_macs < <( 
  ip a | 
    grep -zoEe '\<([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})\>' | 
    grep -zve '00:00:' -e 'ff:ff:' )

## Add MAC's from `ip a` to the MAC's from `macchanger`
for LL in "${ip_a_macs[@]}"
do
  ## ...and make uppercase
	all_sys_real_and_fake_macs+=( "${LL^^}" )
done
unset LL

fwc_zone_srcs=$( firewall-cmd --zone="${target_def_zn}" --list-sources )

## For each of the MAC addresses in the full list...
for MM in "${all_sys_real_and_fake_macs[@]}"
do
	## ...if it hasn't been added to the default zone yet...
	if ! [[ "${fwc_zone_srcs}" =~ "${MM}" ]]
	then
		## ...then add it
		sudo -- firewall-cmd --zone="${target_def_zn}" --add-source="${MM}"

    ## ...and update the current list
    fwc_zone_srcs=$( firewall-cmd --zone="${target_def_zn}" --list-sources )
	fi
done
unset MM


## Forwarding
firewall-cmd --zone="${target_def_zn}" --remove-forward


## Log denied
if   ! [[ "$( firewall-cmd --get-log-denied )" = "${log_deny}" ]]
then
              firewall-cmd --set-log-denied="${log_deny}"

  if ! [[ "$( firewall-cmd --get-log-denied )" = "${log_deny}" ]]
  then
    die
  fi
fi


## Lockdown whitelists

## Note, Security, Hard code the defaults here, so that if they#re changed 
#+  above in-script, or changed in the rpm, some logging of the change will 
#+  also occur.

## Hard-coded sha1 hash of default lockdown whitelist command. The sha1 hash 
#+  is of the whitelist commandline itself; this is why a `printf` is 
#+  necessary at assignment of $lgr_cmd_0
ro_hard_coded_sha1="a5a8aaea19f048850865ba553fe1f4edd5319d73"
ro_hard_coded_wl_cmd="/usr/bin/python3 -sP /usr/bin/firewall-config"
lgr_cmd_0='declare -p ro_hard_coded_sha1 ro_hard_coded_wl_cmd'

## Note, lgr_cmd_1, Yes, this escape-of-a-single-quote syntax is correct.
lgr_cmd_1='printf "%s\\n" "${default_lockdown_whitelist_cmd}" | sha1sum | awk '\''{ print $1 }'\' 
readonly ro_hard_coded_sha1 ro_hard_coded_wl_cmd

## If the hashes of the command strings are different, 
if ! [[ "$( eval "${lgr_cmd_1}" )"  = ${ro_hard_coded_sha1} ]]
then
  ## There#s an `eval` below, so single-quoting each entire command string (ie, 
  #+  in the $lgr_cmd_[0-9]* variables) is also necessary, in order to abide by 
  #+  bash-5#s word-splitting rules.
  
  log_discrepancy()
  {
    local -
    set -x
    
    [[ "$#@" -eq 1 ]] || die

    local AA
    local -n BB
    local base_var_name range_digits
    base_var_name="${1%_*}"
    readarray -t range_digits < <( seq "${1##*_}" "$2" )

    for AA in "${range_digits[@]}"
    do
      declare -n BB="${base_var_name}_${AA}"
      logger -- "\"${BB[@]}\""\: "$( eval "${BB[@]}" )"
    done
    
    unset AA
    unset -n BB
    unset base_var_name range_digits
  }
  log_discrepancy lgr_cmd_0 1
fi

exit


































readarray -t fwc_llw_cmds < <(
  firewall-cmd --list-lockdown-whitelist-commands )

for CC in "${fwc_llw_cmds[@]}"
do
  
firewall-cmd --add-lockdown-whitelist-command="${ro_hard_coded_wl_cmd}"

readarray -t fwc_llw_cntxts
firewall-cmd --list-lockdown-whitelist-contexts
firewall-cmd --remove-lockdown-whitelist-context=


readarray -t fwc_llw_uids
firewall-cmd --list-lockdown-whitelist-uids
firewall-cmd --remove-lockdown-whitelist-uid=


readarray -t fwc_llw_usrs
firewall-cmd --list-lockdown-whitelist-users



which python3
which firewall-config
firewall-cmd --lockdown-on
firewall-cmd --lockdown-off
getenforce
sestatus
firewalld --runtime-to-permanent
firewall-cmd --runtime-to-permanent
firewall-cmd --zone --list-all
firewall-cmd --zone="${target_def_zn}" --list-all
firewall-cmd --query-lockdown
firewall-cmd --lockdown-off
firewall-cmd --stae
firewall-cmd --state
dnf needs-restarting
systemctl try-reload-or-restart "${svc}" 
date
firewall-cmd --query-lockdown
history | grep firewall-cmd
firewall-cmd --list-lockdown-whitelist-commands; firewall-cmd --list-lockdown-whitelist-contexts; firewall-cmd --list-lockdown-whitelist-uids; firewall-cmd --list-lockdown-whitelist-users
firewall-cmd --remove-lockdown-whitelist-context=system_u:system_r:NetworkManager_t:s0 --remove-lockdown-whitelist-context=system_u:system_r:virtd_t:s0-s0:c0.c1023; firewall-cmd --remove-lockdown-whitelist-uid=0
firewall-cmd --list-lockdown-whitelist-commands; firewall-cmd --list-lockdown-whitelist-contexts; firewall-cmd --list-lockdown-whitelist-uids; firewall-cmd --list-lockdown-whitelist-users
history | grep firewall-cmd
history | grep list-all
firewall-cmd --zone="${target_def_zn}" --list-all
history | grep source
firewall-cmd --zone="${target_def_zn}" --add-source=12:59:e7:e4:18:43 --add-source=20:79:18:b0:59:1e #--add-interface=wlo1 --remove-forward
firewall-cmd --zone="${target_def_zn}" --list-all
which macchanger
which rfkill
sudo -- macchanger wlo1
sudo -- macchanger -ab wlo1
sudo -- macchanger -a wlo1
sudo -- macchanger -p wlo1
sudo -- macchanger -a wlo1
sudo -- macchanger -p wlo1
sudo -- macchanger -ae wlo1
sudo -- macchanger -abe wlo1
sudo -- macchanger -ae wlo1
ip a
firewall-cmd --zone="${target_def_zn}" --add-source=20:79:18:d5:ec:f9 --add-source=20:79:18:b0:59:1e --add-source=20:79:18:2b:e0:63 #--add-interface=wlo1 --remove-forward
firewall-cmd --zone="${target_def_zn}" --list-all
firewall-cmd --zone="${target_def_zn}" --add-interface=wlo1
firewall-cmd --zone="${target_def_zn}" --list-all
firewall-cmd --zone="${target_def_zn}" --remove-forward
firewall-cmd --zone="${target_def_zn}" --list-all
firewall-cmd --set-log-denied="${log_deny}"
firewall-cmd --zone="${target_def_zn}" --list-all
history | grep firewall-cmd
firewall-cmd --state
firewall-cmd --get-default-zone
firewall-cmd --zone="${target_def_zn}" --list-all
firewall-cmd --list-all
history | grep firewall-cmd
firewall-cmd --list-lockdown-whitelist-commands; firewall-cmd --list-lockdown-whitelist-contexts; firewall-cmd --list-lockdown-whitelist-uids; firewall-cmd --list-lockdown-whitelist-users
firewall-cmd --list-all
firewall-cmd --lockdown-on
firewall-cmd --lockdown-off
firewall-cmd --list-all
firewall-cmd --runtime-to-permanent
firewall-cmd --list-all
systemctl try-reload-or-restart "${svc}" 
firewall-cmd --list-all
firewall-cmd --state
systemctl status "${svc}" 
firewall-cmd --query-lockdown
firewall-config
bg
systemctl status "${svc}" 
firewall-cmd --query-lockdown
firewall-cmd --state
firewall-cmd --list-all
systemctl status 
history > hist
vim hist 
history | cut -c 8- | head
history | cut -c 8- > hist



sudo -- firewall-cmd --set-default-zone="${target_def_zn}"
sudo -- systemctl start "${svc}"
sudo -- firewall-cmd --set-default-zone="${target_def_zn}"
ip a
sudo -- firewall-cmd --zone="${target_def_zn}" --add-interface=wlo1
sudo -- firewall-cmd --zone="${target_def_zn}" --add-source=52:81:c8:e7:33:f9 --add-source=20:79:18:b0:59:1e
sudo -- firewall-cmd --zone="${target_def_zn}" --remove-forward
sudo -- firewall-cmd --set-log-denied="${log_deny}"
sudo -- firewall-cmd --zone="${target_def_zn}" --list-all
sudo -- firewall-cmd --query-forward
sudo -- firewall-cmd --remove-forward
sudo -- firewall-cmd --zone="${target_def_zn}" --list-all
sudo -- firewall-cmd --zone="${target_def_zn}" --add-source=52:81:c8:e7:33:f9 --add-source=20:79:18:b0:59:1e
sudo -- firewall-cmd --zone="${target_def_zn}" --add-interface=wlo1
sudo -- firewall-cmd --zone="${target_def_zn}" --list-all
sudo -- firewall-cmd --query-lockdown
sudo -- firewall-cmd --lockdown=on
sudo -- firewall-cmd --lockdown-on
sudo -- firewall-cmd --query-lockdown
sudo -- firewall-cmd --runtime-to-permanent
sudo -- firewall-cmd --check-config || die
sudo -- firewall-cmd --reload
sudo -- firewall-cmd --zone="${target_def_zn}" --list-all
sudo -- firewall-cmd -

