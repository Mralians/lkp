#!/usr/bin/env bash

set -u
set -e
#set -x

_PID=${1}
_SMAPS="/proc/${_PID}/smaps"
_CLEAR_REFS="/proc/${_PID}/clear_refs"

exec 4<>"${_CLEAR_REFS}"

echo 1 > "${_CLEAR_REFS}"

#kill -STOP "${_PID}"
while sleep 1;do
  clear
  _TOTAL_RSS=$(awk 'BEGIN{metric=0} /^Rss:/{metric+=$2}           END{print metric / 1024}'  "${_SMAPS}")
  _TOTAL_PSS=$(awk 'BEGIN{metric=0} /^Pss:/{metric+=$2}           END{print metric / 1024}'  "${_SMAPS}")
  _TOTAL_SWP=$(awk 'BEGIN{metric=0} /^Swap:/{metric+=$2}          END{print metric / 1024}'  "${_SMAPS}")
  _TOTAL_REF=$(awk 'BEGIN{metric=0} /^Referenced:/{metric+=$2}    END{print metric / 1024}'  "${_SMAPS}")
  printf "RSS(MB):  %10.2f MB\n" "${_TOTAL_RSS}"
  printf "PSS(MB):  %10.2f MB\n" "${_TOTAL_PSS}"
  printf "SWP(MB):  %10.2f MB\n" "${_TOTAL_SWP}"
  printf "REF(MB):  %10.2f MB\n" "${_TOTAL_REF}"
done
#kill -CONT "${_PID}"

exec 4>&-

