#!/bin/bash


shopt -s extglob
set -x #<>
set -euo pipefail #<>


# Variables
CC=/dev/shm
DD=${CC}/get_file_atimes-sh.d
EE=${DD}/rpm-qa_o
FF=${DD}/arr__all_dirs
GG=${DD}/arr__all_files
HH=${DD}/stat-cNW_o
JJ=${CC}/arr__all_files.immut
LL=${DD}/realpath_changes
MM=${DD}/find_tmpfile



# Reset the filesystem
sudo -v
if sudo test -f "${DD}"
then
  if ! sudo rm -fr "${DD}"
  then
    exit "${LINENO}"
  fi
fi
# shellcheck disable=SC2174
mkdir -p -m 0700 "${DD}" || exit "${LINENO}"
rpm -qa > "${EE}" || exit "${LINENO}"

# Get the dirs
unset all_dirs
all_dirs=( /* )
for yy in "${!all_dirs[@]}"
do
  if [[ ${all_dirs[yy]} == @(/proc|/sys) ]]
  then
    unset "all_dirs[yy]"
  fi
done && unset yy
declare -p all_dirs > "${FF}" || exit "${LINENO}"

# Get the files
unset all_files
all_files=()
arr__args_for_binFind=( '(' '!' "-path" '*/proc/*' "-a" '!' "-path" '/sys/*' "-a"
  '!' "-path" '/run/systemd/transient/*' "-a" '!' "-path" '/run/user/1000/*' "-a"
  '!' "-path" '/run/host/*' ')'
)
test_extglb="@(/proc/|/sys/|/run/systemd/transient/|/run/user/1000/)*"

for dd in "${all_dirs[@]}"
do

  cc=${#all_files[@]}

  sudo find -P "${dd}" "${arr__args_for_binFind[@]}" -print0 2> /dev/null \
    | sudo tee "${MM}" > /dev/null

  mapfile -d "" -t -O $(( ${#all_files[@]} + 1 )) all_files < <(
    sudo cat "${MM}" 
  )

  if [[ ${cc} -ge "${#all_files[@]}" ]]
  then
    printf '\n\tError: array not filling.\n\n'
    exit "${LINENO}"
  fi

  all_files=( "${all_files[@]}" )
  
  sudo test -f "${MM}" && rm -f -v "${MM}"

done && unset dd
sudo test -f "${MM}" && rm -f -v "${MM}"


# Canonicalize all the paths
set +e
declare -A all_canonicalized_paths=()
uu=0

for qq in "${!all_files[@]}"
do
  curr_assoc_indx=$( sudo -- realpath -e "${all_files[qq]}" )
  all_canonicalized_paths=( ["${curr_assoc_indx}"]+="${qq}|" )

  if [[ -z ${all_files[qq]} ]]
  then
    printf 'array "%s" index "%d" is empty\n' "all_files" "${qq}"
    exit "${LINENO}"
  fi

  if [[ -z ${curr_assoc_indx} ]]
  then
    echo realpath returned an empty string
    exit "${LINENO}"
  fi

  if [[ ${all_files[qq]} != "${curr_assoc_indx}" ]]
  then
    printf 'Log: %s --> %s\n' "${all_files[qq]}" "${curr_assoc_indx}" \
      2> /dev/null > "${LL}"

    printf '\n\t realpath changed a value: %d times\n\n' $((++uu))
    sleep 2
  fi

    declare -p all_canonicalized_paths

  if ! [[ ${all_canonicalized_paths[${curr_assoc_indx}]} =~ "${qq}|"$ ]]
  then
    echo Assignment error
    exit "${LINENO}"
  fi

done && unset qq
set -e

all_files=( "${all_files[@]}" )

declare -p all_files > "${GG}" || exit "${LINENO}"
sudo mv "${GG}" "${JJ}"
sudo chattr +i "${JJ}"
full_count_allFiles=${#all_files[@]}

  echo "all_files[0]: ${all_files[0]}" #<>
  echo "full_count_allFiles: ${full_count_allFiles}" #<>
  #exit "${LINENO}" #<>


## Get all the atimes

#+ While there are still any files listed in the array
nn=0

while [[ "${#all_files[@]}" -gt 0 ]]
do
  unset some_files
  nn=$((nn++))

    echo "count, all_files: ${#all_files[@]}" #<>

  #+ Take 1000 at a time
  for (( ii = 0; ii <= 1000; ii++ ))
  do
    #+ One by one, add a file to the \s\ome_files array and then
    #+   unset the same index from the \a\ll_files array
    
      echo 'ii:' "${ii}" #<>
      #echo 'all_files [ii]:' "${all_files[ii]}" #<>

    if [[ -n "${all_files[ii]:-}" ]]
    then
      if [[ ${all_files[ii]} == "${test_extglb}" ]]
      then
        continue
        #echo match found
        #break 2
      fi

      some_files+=( [ii]="${all_files[ii]}" )  
      unset "all_files[ii]"
    else
      echo wtf
      echo "count, all_files: ${#all_files[@]}" #<>
      echo "count, some_files: ${#some_files[@]}" #<>
      echo "full_count_allFiles: ${full_count_allFiles}"
      sudo wc "${HH}"
      break 2
    fi
  done && unset ii

    echo "count, some_files: ${#some_files[@]}" #<>


  if sudo test -e "${some_files[0]}"
  then
    { sudo -- stat --printf='%W %N\n' "${some_files[@]}" \
      || exit "${LINENO}"
    } \
      | sudo tee -a "${HH}" >/dev/null \
        || exit "${LINENO}"
  else
    break 2
  fi
  
  all_files=( "${all_files[@]}" )
  
    echo "count, all_files: ${#all_files[@]}" #<>
    printf '\n\t%s\n\n' "end of big loop ${nn}"
done

