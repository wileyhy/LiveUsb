#!/bin/bash
# set.fn
#   If xtrace is enabled, then also print verbose output from any external commands which offer such 
# options by defining arrays "${ver__[@]}" and "${qui__[@]}".


function set(){

  sub_fn_set(){
    ## Question, is there a way to undo this setting, `local -`?  After `local -`, all executions of `set` are limited to local scope.
    local - 
    builtin set -x

      echo ampersand $@
      return 2

    : 'If there was no input...'
    if [[ ${#@} -eq 0 ]]
    then
      : 'y'
      : '...then simply execute builtin "set" as requested, sanitizing input, and return from this function'
      builtin set
      return
    else
      : 'n'
      : 'If there was some input, however...'

      : 'If the form of the input falls within this regex...'
      ## That is, if the input in some way effects xtrace...
      local regx_3
        regx_3='([-+].*x)|-'

      # Bug, This pattern is inadequate for all possible valid matches, esp. '[-+]o xtrace' and its variations
      if [[ $* =~ ${regx_3} ]]
      then

          # <> This pattern is inadequate for all possible valid matches
          #set -- - ; 
          #ampersand="$@"; 
          #echo "ampersand: $ampersand"; 
          #echo hyphen: $-; 
          #set -x; 
          #re='([-+]x)|-'; 
          #[[ ${ampersand} =~ ${re} ]]; 
          #echo $?; 
          #echo "BASH_REMATCH: $BASH_REMATCH"; 
          #set -

        : 'y'
        : 'Then test for arrays "qui__" and "ver__", for they must be defined as empty if they did not...'
        : '...previously exist.'
        local XX
        for XX in qui__ ver__
        do
          : 'Get the known value for the array'
          local YY regx_0
            YY=$(declare -p "${XX}" 2>&1)
            regx_0="not found$"

          : 'If the output of `declare` ends in "not found", then define the array locally'
          ## N, if the array was not found at this local scope, then it could not have been defined at the 
          #+ global scope, either.
          if [[ ${YY} =~ ${regx_0} ]]
          then
            : 'y'

            : 'So if the array was not defined, then define it, from within the local scope, as empty, and...'
            : '...as global while inheriting any attributes the array may have had at the previous scope.'
            local -Iga "${XX}=()"
          else
            : 'n'
          fi
          unset YY regx_0
        done
        unset XX

        : '...if the input would enable xtrace...'
        local regx_1 regx_2 
          regx_1='\-.*x'
          regx_2='\+.*x|-'
        if [[ $* =~ ${regx_1} ]]
        then
          : 'y-_'
          : '...then also define these arrays such that external commands will also produce verbose output'
          qui__=(--)
          ver__=(--verbose --)

        elif [[ $* =~ ${regx_2} ]]
        then
          : 'n-y'
          : '...if the input would disable xtrace...'
          : '...then also define these arrays such that external commands would also not produce any verbose output'
          qui__=(--quiet --)
          ver__=(--)
        else
          : 'n-n'
        fi
        unset regx_1 regx_2 

        : 'Execute the builtin "set" as originally requested'
        builtin set -- "$@"
      else
        : 'n'
        : 'If the input does not match one of the hardcoded patterns, then execute the input as requested...'
        : '...and return'
        builtin set -- "$@"
        return      
      fi
      unset regx_3
    fi
  }

  sub_fn_set "$@"
  builtin set "$@"
}
