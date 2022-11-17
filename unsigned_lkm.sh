#! /usr/bin/env bash

# SCRIPT: unsigned_lkm.sh
# DESCRIPTION: -
# USAGE: -

set -u
set -e
#set -x
#set -n

_EXIT_SUCCESS=0

_MODULES_PATH="/sys/module"

_OUT_OF_TREE_MODULES=("")
out_of_tree_modules() {
  local i=0
  for module in "${_MODULES_PATH}"/*;do
    if [[ -f "${module}/taint" ]];then
      if [[ "$(od -An ""${module}/taint)" != " 000012" ]];then
        _OUT_OF_TREE_MODULES[i]="${module}"
        i=$((++i))
      fi
    fi
  done
}

out_of_tree_modules
printf "%s\n" "${_OUT_OF_TREE_MODULES[@]}"
exit ${_EXIT_SUCCESS}

set +u
set +e
set +x
set +n

