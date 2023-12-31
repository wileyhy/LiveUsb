#!/bin/bash

function set()
{
  local - # is there a way to undo this setting?  After `local -` all executions of `set` are limited to local scope
  builtin set -x

  local XX regx_0 regx_1 regx_2 regx_3;
  regx_0='not found$'
  regx_1='\-.*x';
  regx_2='\+.*x';
  regx_3='\-';

  if ! [[ $@ =~ ${regx_3} ]];
  then
    for XX in qui__ verb__
    do
      if [[ "$(declare -p "${XX}" 2>&1)" =~ ${regx_0} ]]
      then
        local -Iga "${XX}=()"
      fi
    done
    unset XX
  fi

  if [[ ${#@} -eq 0 ]];
  then
    builtin set;
    return;
  fi;

  if [[ $@ =~ ${regx_1} ]];
  then
    qui__=(--);
    verb__=(--verbose --);

  elif [[ $@ =~ ${regx_2} ]];
  then
    qui__=(--quiet --);
    verb__=(--);
  fi;

  unset XX regx_0 regx_1 regx_2 regx_3;
  builtin set "$@";
}

