#!/bin/bash
# free disk space: fds.sh


	set -x
	set -euo pipefail

: "Colors"
unset C0 C1
C0=$( tput sgr0 )
C1=$( tput setaf 4 )

: "${C1}Require a list of any applications which should be saved${C0}"
unset ff_Apps
      ff_Apps="./List__Saved_Applications"

if 	[[ -f ${ff_Apps} ]]

then	: 'y'
	unset apps

	mapfile -t apps < "${ff_Apps}"

else	: 'n'
	touch "${ff_Apps}"

	cat <<- EOF | tee /dev/stderr >/dev/null

		fds:    A list of user-protected applications is required.
		        A blank list has been created.
		        To proceed with an empty list, execute this program
		    again. To save any applications, add them to the list
		    one per line, using basenames without version infor-
		    mation. Exiting.

	EOF

	ls --color=auto -Ghl "${ff_Apps}" 1>&2
	exit "${LINENO}"
fi
unset ff_Apps

[[ -n ${apps[0]:0:16} ]] || exit "${LINENO}"

	#declare -p apps
	set -x
	#exit "${LINENO}"



: "${C1}From OS, get count of pkgs actually installed...${C0}"
unset list_actual
dnf_ff=./dnf-list-installed.txt

dnf list --installed > "${dnf_ff}" || exit "${LINENO}"

mapfile -t list_actual < <(
	awk '$1 ~ /\.x86_64|\.noarch|\.i686/ && $1 !~ /^Installed/ { print $1 }' < "${dnf_ff}"
)

  #declare -p PIPESTATUS list_actual #<>
  #exit "${LINENO}" #<>


: "${C1}...and record that data.${C0}"
unset ff_ListActual
      ff_ListActual="./Array__List_Pkgs_Actual"
unset count_actual 
      count_actual="${#list_actual[@]}"

: "${C1}Define function error_symlink()${C0}"
error_symlink() {
	[[ -e $1 ]] || return 1
	[[ -L $1 ]] && {
		echo "${C1}Error, file is a symlink. Exiting.${C0}"
		return 1
	}
	return 0
}

: "${C1}Define function write_list_actual()${C0}"
write_list_actual() {
	printf '%s\n' "${list_actual[@]}" | tee "${ff_ListActual}" >/dev/null || 
		exit "${LINENO}"
}



: "${C1}If the List Actual file already exists...${C0}"
if 	[[ -f ${ff_ListActual} ]]
then
	: 'y'
	error_symlink "${ff_ListActual}" || exit "${LINENO}"
		
	: "${C1}...then hash the datas...${C0}"
	unset hash_Actual hash_ListAct
	      hash_Actual=$( tr '\n' ' ' <<< "${list_actual[@]}" | sha256sum )
        hash_Actual="${hash_Actual%% *}"
	      hash_ListAct=$( tr '\n' ' ' < "${ff_ListActual}" | sha256sum  )
        hash_ListAct="${hash_ListAct%% *}"

	: "${C1}...if the hashes match...${C0}"
	if	[[ ${hash_Actual} == "${hash_ListAct}" ]]
	then
		: 'y'
		: "${C1}...then don#t write any data to disk${C0}"
	else
		: 'n'
		: "${C1}...if the hashes differ, then overwrite previous data${C0}"
		write_list_actual
	fi
		#exit "${LINENO}"
else
	: 'n'
	: "${C1}...if there is no such file, then write data to disk${C0}"
	write_list_actual
fi
unset -f write_list_actual
unset hash_Actual hash_ListAct

[[ -f ${ff_ListActual} ]] || exit "${LINENO}"

	#declare -p count_actual
	#echo "${#list_actual[@]}"
	#ls -lh "${ff_ListActual}"
	#set -x
	#exit "${LINENO}"



#: "${C1}${C0}"
: "${C1}From disk, of pkgs prev recorded as installed, if a list from a prev run of this script is available...${C0}"
unset ff_ListRecorded
      ff_ListRecorded="./Array__List_Pkgs_Recorded"
unset renew__space__err
      renew__space__err="no"
unset count_recorded list_recorded

: "${C1}Define function define_count_recorded()${C0}"
define_count_recorded() {
	: "${C1}...and the integer in in the variable #count_recorded# should be defined${C0}"
	count_recorded="${#list_recorded[@]}"
}

: "${C1}Define function define_list_recorded()${C0}"
define_list_recorded() {
	list_recorded=( "${list_actual[@]}" )
}

: "${C1}Define function read_list_recorded()${C0}"
read_list_recorded() {
	{ mapfile -t list_recorded < "${ff_ListRecorded}" && [[ -n ${list_recorded[*]:0:1} ]]; } || 
		exit "${LINENO}"
}

: "${C1}Define function write_list_recorded()${C0}"
write_list_recorded() {
	printf '%s\n' "${list_recorded[@]}" | tee "${ff_ListRecorded}" >/dev/null || 
		exit "${LINENO}"

	: "${C1}...and make a note to renew the #space_err# array (see below)${C0}"
	#renew__space__err="yes"
}

  ls -alhFi "${ff_ListRecorded}" #<>
  #exit "${LINENO}" #<>

: "${C1}If a file List Recorded exists on disk...()${C0}"
if 	[[ -f ${ff_ListRecorded} ]] \
      && [[ -s ${ff_ListRecorded} ]]
then
	: 'y'
  wc_w_o=$( wc -w "${ff_ListRecorded}" )
  wc_w_0=${wc_w_o%% *}

  if [[ ${wc_w_o} -le 0 ]]
  then
    rm -fv "${ff_ListRecorded}"
  fi
else
  : 'n'
fi
  
if 	[[ -f ${ff_ListRecorded} ]]
then
	: 'y'
	: "${C1}...then read the data in. The reading must have succeeded${C0}"
	error_symlink "${ff_ListRecorded}" || exit "${LINENO}"
	read_list_recorded
else
	: 'n'
	: "${C1}...then make one${C0}"
	define_list_recorded
	write_list_recorded
fi
define_count_recorded

[[ -f ${ff_ListRecorded} ]] || exit "${LINENO}"

	#declare -p count_recorded #<>
	#echo "${#list_recorded[@]}" #<>
	#ls -lh "${ff_ListRecorded}" #<>
	set -x #<>
	exit "${LINENO}" #<>


	
: "${C1}if the actual and recorded counts are the same (of software packages)...${C0}"
if 	[[ ${count_actual} == "${count_recorded}" ]]
then
	: 'y'
	error_symlink "${ff_ListRecorded}" || exit "${LINENO}"

	: "${C1}...then make sure the contents of the lists are the same${C0}"
	# ...by getting and comparing some cryptographic hashes of each array...
	#+ because the package counts can be the same, but the contents of each
	#+ list can differ.
	unset hash_ListAct hash_ListRec
	      hash_ListAct=$( sha256sum < "${ff_ListActual}" )
	      hash_ListRec=$( sha256sum < "${ff_ListRecorded}" )

	: "${C1}If the actual and recorded lists are the same..${C0}"
	if 	[[ ${hash_ListAct} == "${hash_ListRec}" ]]
	then
		: 'y'
		: "${C1}...then move on to next section${C0}"
	else
		: 'n'
		: "${C1}...then remove the existing on-disk list, for pkgs recorded as installed...${C0}"
		error_symlink "${ff_ListRecorded}" || exit "${LINENO}"
		rm -f "${ff_ListRecorded}"

		: "${C1}...write a new file...${C0}"
		define_list_recorded
		write_list_recorded
		define_count_recorded
	fi
	unset hash_ListAct hash_ListRec
else
	: 'n'
	: "${C1}...then the data in the file List Recorded should be corrected...${C0}"
	define_list_recorded
	error_symlink "${ff_ListRecorded}" || exit "${LINENO}"
	write_list_recorded
	define_count_recorded
fi
	
	set -x
	: "${C1}<> Debug: All data created thus far must exist${C0}"
	if	[[ -n ${count_actual} ]] \
        && [[ -n ${count_recorded} ]] \
        && [[ -f ${ff_ListActual} ]] \
        && [[ -f ${ff_ListRecorded} ]]
	then
		: 'y'
	else
		: 'n'
		exit "${LINENO}"
	fi
	exit "${LINENO}"

	echo AJAX
  exit "${LINENO}"


: "${C1}Get data if necessary -- array #space_err# -- SLOW${C0}"
unset ff_SpaceErr
      ff_SpaceErr="./Array__Space_Err"

if 	[[ ${renew_data} == "yes" ]]
then
	: 'y'
	if 	[[ -f ${ff_SpaceErr} ]]
	then
		: 'y'
		rm -f "${ff_SpaceErr}"
	else
		: 'n'
	fi

	unset II pkgs space_err

	: "${C1}Find whether attempted removal of the pkg would cause an error or free some disk space${C0}"
	for II in "${!pkgs[@]}"
	do
		# Create array #space_err# and edit data
		mapfile -O "${II}" -t space_err < <(
			sudo dnf --assumeno remove "${pkgs[II]}" |&
			grep -e ^"Freed space: " -e ^"Error:"
		)
		mapfile -O "${II}" -t space_err < <(
			echo "${space_err[II]}" |
			awk '$1 ~ /^Freed/ { print $3, $4 }'
		)

		# Print results to terminal
		printf '\n%s\t' "${pkgs[II]}"
		echo "${space_err[II]}"
	done
	unset II
fi

: "${C1}The two counts of indices must be the same.${C0}"
unset ff_Indices indices
      ff_Indices=Array__Indices

if [[ ${#pkgs[@]} == "${#space_err[@]}" ]]
then
	: 'y'
	indices=( "${!pkgs[@]}" )
else
	: 'n'
	echo "Indices do not match"
	exit "${LINENO}"
fi

: "${C1}Save arrays${C0}"
declare -p indices | tee array__indices >/dev/null
declare -p pkgs | tee "${ff_Pkgs}" >/dev/null
declare -p space_err | tee "${ff_SpaceErr}" >/dev/null


: "${C1}When output if dnf(1) is an error, unset both arrays #pkgs# and #space_err#${C0}"
unset EE errors
for EE in "${indices[@]}"
do
	if [[ "${space_err[EE]}" == 'Error: ' ]]
	then
		: 'y'
		mapfile -O "${EE}" -t errors <<< "${pkgs[EE]}"
		unset "pkgs[EE]" "space_err[EE]"
	else
		: 'n'
	fi
done
unset EE

: "${C1}Save array${C0}"
declare -p errors | tee array__errors >/dev/null


