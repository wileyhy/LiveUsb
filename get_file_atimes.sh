#!/bin/bash


set -x #<>
sudo  #<>v

# Variables
DD=/dev/shm/free-disk-space-sh.d
FF=${DD}/rpm-qa_o
GG=${DD}/arr__all_dirs
HH=${DD}/arr__all_files
II=${DD}/stat-cNW_o

# Reset the filesystem
rm -fr "${DD}" || exit "${LINENO}"
mkdir -p -m 0700 "${DD}" || exit "${LINENO}"
rpm -qa > "${FF}" || exit "${LINENO}"

# Get the dirs
unset all_dirs
all_dirs=( /* )
unset "all_dirs[12]"
unset "all_dirs[17]"
declare -p all_dirs > "${GG}" || exit "${LINENO}"

# Get the files
unset all_files
mapfile -d "" -t all_files < <(
  for dd in "${all_dirs[@]}"
  do
    sudo find "${dd}" -print0 2> /dev/null
  done
)
declare -p all_files > "${HH}" || exit "${LINENO}"

  #echo "all_files[0]: ${all_files[0]}" #<>
  #exit "${LINENO}" #<>

## Get all the atimes

#+ While there are still any files listed in the array
while [[ "${#all_files[@]}" -gt 0 ]]
do
  unset ii some_files
  
  #+ Take 1000 at a time
  for (( ii = 0; ii <= 1000; ii++ ))
  do
    #+ One by one, add a file to the \s\ome_files array and then
    #+   unset the same index from the \a\ll_files array
    some_files+=( "${all_files[ii]}" )  
    unset "all_files[ii]"
  done
  
  if [[ -e "${some_files[0]:0:8}" ]]
  then
    sudo -- stat --printf='%W %N\n' "${some_files[@]}" \
      | sudo tee -a "${II}" >/dev/null \
      || exit "${LINENO}"
  else
    break 2
  fi
  
  all_files+=( "${all_files[@]}" )
done

