#!/bin/bash
# free disk space: fds.sh


## Next step - this script is buggy, but the next step is to figure
#+   out an sqlite cli command to get from rpm/dnf the list of 
#+   packages installed, their size, their protected status, etc.
#+   Remove the protected pkgs from the list, sort it by pkg size
#+   and ask the user to remove the largest packages first.
#+     Because as it's written now, the list is alphabetical with no
#+   size data, which is super slow.



	set -x
	set -euo pipefail

: "Colors"
C0=$( tput sgr0 )
C1=$( tput setaf 4 )



: "${C1} Variables ${C0}"
                   scr_nm="free-disk-space.sh"
                  dd_data="/dev/shm/${scr_nm//./-}.d"

                file_Apps="${dd_data}/List__Saved_Applications"
	                 dnf_ff="${dd_data}/dnf-list-installed.txt"
            ff_ListActual="${dd_data}/Array__List_Pkgs_Actual"
        ff_ListSavedState="${dd_data}/Array__List_PkgsSavedState"
      ff_ProbProtect_pkgs="${dd_data}/List__Protect_pkgs"
                   ff_Err="${dd_data}/List__Err_pkgs"

        renew__space__err="no"
               renew_data="yes"
               ff_Indices="Array__Indices"





: "${C1} Functions ${C0}"

: "${C1}Define function write_list_actual${C0}"
write_list_actual() {
	#printf '%s\n' "${list_actual[@]}" | tee "${ff_ListActual}" >/dev/null || 
		#exit "${LINENO}"
  declare -p list_actual > "${ff_ListActual}"
}

: "${C1}Define function define_count_saved_state${C0}"
define_count_saved_state() {
	: "${C1}...and the integer in in the variable #count_saved_state# should be defined${C0}"
	count_saved_state="${#array_saved_state_pkgnms[@]}"
}

: "${C1}Define function copy_list_as_saved_state${C0}"
copy_list_as_saved_state() {
	array_saved_state_pkgnms=( "${list_actual[@]}" )
}

: "${C1}Define function read_in_array_saved_state_pkgnms${C0}"
read_in_array_saved_state_pkgnms() {
	{ mapfile -t array_saved_state_pkgnms < "${ff_ListSavedState}" && [[ -n ${array_saved_state_pkgnms[*]:0:1} ]]; } || 
		exit "${LINENO}"
}

: "${C1}Define function write_array_saved_state_pkgnms${C0}"
write_array_saved_state_pkgnms() {
	printf '%s\n' "${array_saved_state_pkgnms[@]}" | tee "${ff_ListSavedState}" >/dev/null || 
		exit "${LINENO}"

	: "${C1}...and make a note to renew the #space_err# array (see below)${C0}"
	#renew__space__err="yes"
}




: "${C1} Create working directory ${C0}"
if [[ ! -d ${dd_data} ]]
then
  mkdir -m 0700 "${dd_data}" || exit "${LINENO}"
fi




: "${C1}Require a list of any applications which should be saved${C0}"
if 	[[ -f ${file_Apps} ]]
then	: 'y'
	mapfile -t array_user_selected_protected_apps < "${file_Apps}"
else	: 'n'
	touch "${file_Apps}"
	cat <<- EOF | tee /dev/stderr >/dev/null

		fds:    A list of user-protected applications is required.
		        A blank list has been created.
		        To proceed with an empty list, execute this program
	    	    again. To save any applications, add them to the list
		        one per line, using basenames without version infor-
		        mation. Exiting.

	EOF
	ls --color=auto -Ghl "${file_Apps}" 1>&2
	exit "${LINENO}"
fi

[[ -n ${array_user_selected_protected_apps[0]:0:16} ]] || exit "${LINENO}"

	#declare -p array_user_selected_protected_apps
	set -x
	#exit "${LINENO}"



: "${C1}From OS, get count of pkgs actually installed...${C0}"
sudo dnf list --installed > "${dnf_ff}" || exit "${LINENO}"

mapfile -t list_actual < <(
	awk '$1 ~ /\.x86_64|\.noarch|\.i686/ && $1 !~ /^Installed/ { print $1 }' < "${dnf_ff}"
)

  #declare -p PIPESTATUS list_actual #<>
  #exit "${LINENO}" #<>


: "${C1}...and record that data.${C0}"
count_actual="${#list_actual[@]}"


: "${C1}If the List Actual file already exists...${C0}"
if 	[[ -f ${ff_ListActual} ]]
then
	: 'y'
		
	: "${C1}...then hash the datas...${C0}"
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

[[ -f ${ff_ListActual} ]] || exit "${LINENO}"

	#declare -p count_actual
	#echo "${#list_actual[@]}"
	#ls -lh "${ff_ListActual}"
	#set -x
	#exit "${LINENO}"



#: "${C1}${C0}"
: "${C1}From disk, re List-Saved-State, if a list from a prev run of this script is available...${C0}"
  ls -alhFi "${ff_ListSavedState}" #<>
  #exit "${LINENO}" #<>



  
: "${C1}If a file List-Saved-State exists on disk...${C0}"
if 	[[ -f ${ff_ListSavedState} ]] \
      && [[ -s ${ff_ListSavedState} ]]
then
	: 'y'
  wc_w_o=$( wc -w "${ff_ListSavedState}" )
  wc_w_o=${wc_w_o%% *}

  if [[ ${wc_w_o} -le 0 ]]
  then
    rm -fv "${ff_ListSavedState}"
  fi
else
  : 'n'
fi
  
if 	[[ -f ${ff_ListSavedState} ]]
then
	: 'y'
	: "${C1}...then read the data in. The reading must have succeeded${C0}"
	read_in_array_saved_state_pkgnms
else
	: 'n'
	: "${C1}...then make one${C0}"
	copy_list_as_saved_state
	write_array_saved_state_pkgnms
fi
define_count_saved_state

[[ -f ${ff_ListSavedState} ]] || exit "${LINENO}"

	#declare -p count_saved_state #<>
	#echo "${#array_saved_state_pkgnms[@]}" #<>
	#ls -lh "${ff_ListSavedState}" #<>
	set -x #<>
	#exit "${LINENO}" #<>


	
: "${C1}if the actual and saved-state counts are the same (of software packages)...${C0}"
if 	[[ ${count_actual} == "${count_saved_state}" ]]
then
	: 'y'

	: "${C1}...then make sure the contents of the lists are the same${C0}"
	# ...by getting and comparing some cryptographic hashes of each array...
	#+ because the package counts can be the same, but the contents of each
	#+ list can differ.
	      hash_ListAct=$( sha256sum < "${ff_ListActual}" )
	      hash_ListRec=$( sha256sum < "${ff_ListSavedState}" )

	: "${C1}If the actual and saved-state lists are the same..${C0}"
	if 	[[ ${hash_ListAct} == "${hash_ListRec}" ]]
	then
		: 'y'
		: "${C1}...then move on to next section${C0}"
	else
		: 'n'
		: "${C1}...then remove the existing on-disk Saved-State list...${C0}"
		rm -f "${ff_ListSavedState}"

		: "${C1}...write a new file...${C0}"
		copy_list_as_saved_state
		write_array_saved_state_pkgnms
		define_count_saved_state
	fi
else
	: 'n'
	: "${C1}...then the data in the file List Recorded should be corrected...${C0}"
	copy_list_as_saved_state
	write_array_saved_state_pkgnms
	define_count_saved_state
fi
	
	set -x
	: "${C1}<> Debug: All data created thus far must exist${C0}"
	if	[[ -n ${count_actual} ]] \
        && [[ -n ${count_saved_state} ]] \
        && [[ -f ${ff_ListActual} ]] \
        && [[ -f ${ff_ListSavedState} ]]
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


	: "${C1}Find whether attempted removal of the pkg would cause an error or free some disk space${C0}"
	for II in "${!pkgs[@]}"
	do
    dnf_rm_n_o=$(	sudo dnf --assumeno remove "${pkgs[II]}" )

    if grep -ie Error <<< "${dnf_rm_n_o}"
    then
      printf '%s\n' "${pkgs[II]}" > "${ff_Err}"
      
        "${file_Apps}"
      
      continue
    if grep -ie Problem -e protected <<< "${dnf_rm_n_o}"
    then
      printf '%s\n' "${pkgs[II]}" > "${ff_ProbProtect_pkgs}"
      continue
    elif
      grep -ie Freed <<< "${dnf_rm_n_o}"
    then
      awk_o__size=$( awk '/[Ff]reed/ { print $4, $5 }' <<< "${dnf_rm_n_o}" )
    else
      exit "${LINENO}"
    fi

    printf '\n\nPackage =\t%s\n\n' "${pkgs[II]}"
    printf 'Do you want to remove this package? [y|n]\n\n'
    read -r rm_yn 

    case ${rm_yn} in
      n|N )
        printf 'Do you want to include this package in the save-list? [y|n]\n\n'
        read -r save_yn 

        if [[ ${save_yn} == y ]]
        then
          : 'y'
          printf '$s\n' "${pkgs[II]}" >> "${file_Apps}"
        else
          : 'n'
        fi
        ;;
      y|Y )
        sudo dnf remove "${pkgs[II]}" || exit "${LINENO}"
        write_list_actual
        ;;
    esac
    
		## Create array #space_err# and edit data
		#mapfile -O "${II}" -t space_err < <(
			#sudo dnf --assumeno remove "${pkgs[II]}" |&
			#grep -e ^"Freed space: " -e ^"Error:"
		#)
		#mapfile -O "${II}" -t space_err < <(
			#echo "${space_err[II]}" |
			#awk '$1 ~ /^Freed/ { print $3, $4 }'
		#)

		## Print results to terminal
		printf '\n%s\t' "${pkgs[II]}"
		#echo "${space_err[II]}"
	done
fi

  exit "${LINENO}"



#: "${C1}The two counts of indices must be the same.${C0}"

#if [[ ${#pkgs[@]} == "${#space_err[@]}" ]]
#then
	#: 'y'
	#indices=( "${!pkgs[@]}" )
#else
	#: 'n'
	#echo "Indices do not match"
	#exit "${LINENO}"
#fi

#: "${C1}Save arrays${C0}"
#declare -p indices | tee array__indices >/dev/null
#declare -p pkgs | tee "${ff_Pkgs}" >/dev/null
#declare -p space_err | tee "${ff_SpaceErr}" >/dev/null


#: "${C1}When output if dnf(1) is an error, unset both arrays #pkgs# and #space_err#${C0}"
#unset EE errors
#for EE in "${indices[@]}"
#do
	#if [[ "${space_err[EE]}" == 'Error: ' ]]
	#then
		#: 'y'
		#mapfile -O "${EE}" -t errors <<< "${pkgs[EE]}"
		#unset "pkgs[EE]" "space_err[EE]"
	#else
		#: 'n'
	#fi
#done

#: "${C1}Save array${C0}"
#declare -p errors | tee array__errors >/dev/null


