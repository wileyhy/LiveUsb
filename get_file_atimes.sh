#!/bin/bash


shopt -s extglob
set -x #<>
set -euo pipefail #<>
sudo -v #<>

# Variables
DD=/dev/shm/free-disk-space-sh.d
FF=${DD}/rpm-qa_o
GG=${DD}/arr__all_dirs
HH=${DD}/arr__all_files
II=${DD}/stat-cNW_o
parent_dir=$( realpath -e "${HH%/[a-z]*}/.." )
basenm=${HH##*/}
JJ=${parent_dir}/${basenm}
unset parent_dir basenm
KK=${DD}/realpath_changes


# Reset the filesystem
rm -fr "${DD}" || exit "${LINENO}"
mkdir -p -m 0700 "${DD}" || exit "${LINENO}"
rpm -qa > "${FF}" || exit "${LINENO}"

# Get the dirs
unset all_dirs
all_dirs=( /* )
for yy in "${!all_dirs[@]}"
do
  if [[ ${all_dirs[yy]} == @(/proc|/sys) ]]
  then
    unset "all_dirs[yy]"
  fi
done
unset yy
declare -p all_dirs > "${GG}" || exit "${LINENO}"

# Get the files
unset all_files
find_args=( '(' '!' "-path" "'/proc'" "-a" '!' "-path" "'/sys/'" "-a"
  '!' "-path" "'/run/systemd/transient/'" "-a" '!' "-path" "/run/user/1000/" ')'
)
test_extglb="@(/proc/|/sys/|/run/systemd/transient/|/run/user/1000/)*"

mapfile -d "" -t all_files < <(
  for dd in "${all_dirs[@]}"
  do
    sudo find "${dd}" "${find_args[@]}" -print0 2> /dev/null
  done
)

set +e
all_canonicalized_paths=()

for qq in "${!all_files[@]}"
do
  all_canonicalized_paths[qq]=$( sudo -- realpath -e "${all_files[qq]}" )

  if [[ -n "${all_files[qq]}" ]] && [[ -z ${all_canonicalized_paths[qq]} ]]
  then
    echo realpath returned an empty string
    exit "${LINENO}"
  fi

  if [[ ${all_files[qq]} != ${all_canonicalized_paths[qq]} ]]
  then
    printf '%s --> %s\n' "${all_files[qq]}" "${all_canonicalized_paths[qq]}" > 
    printf '\n\t realpath changed a value\n\n'
    sleep 5
  fi


done
unset qq
set -e

all_files=( "${all_files[@]}" )

declare -p all_files > "${HH}" || exit "${LINENO}"
sudo mv "${HH}" "${JJ}"
sudo chattr +i "${JJ}"
full_count_allFiles=${#all_files[@]}

  echo "all_files[0]: ${all_files[0]}" #<>
  echo "full_count_allFiles: ${full_count_allFiles}" #<>
  exit "${LINENO}" #<>


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
      if [[ "${all_files[ii]}" == ${test_extglb} ]]
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
      echo "full_count_allFiles: $full_count_allFiles"
      sudo wc "${II}"
      break 2
    fi
  done
  unset ii

    echo "count, some_files: ${#some_files[@]}" #<>


  if sudo test -e "${some_files[0]}"
  then
    { sudo -- stat --printf='%W %N\n' "${some_files[@]}" \
      || exit "${LINENO}"
    } \
      | sudo tee -a "${II}" >/dev/null \
        || exit "${LINENO}"
  else
    break 2
  fi
  
  all_files=( "${all_files[@]}" )
  
    echo "count, all_files: ${#all_files[@]}" #<>
    printf '\n\t%s\n\n' "end of big loop ${nn}"
done

