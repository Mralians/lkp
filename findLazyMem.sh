#!/usr/bin/env bash

for filename in /proc/* ;do
  PID=$(basename "${filename}" | grep -o "^[[:digit:]]*")
  if [[ -n ${PID} ]] &&
      [[ -f "/proc/${PID}/smaps" ]] &&
        CONTENT=$(cat < "/proc/${PID}/smaps") &&
          [[ -n "${CONTENT}" ]] &&
            LAZYFREE=$(cat < "/proc/${PID}/smaps" | grep -o "LazyFree:.*" | grep -v "0 kB") &&
              [[ -n "${LAZYFREE}" ]];then
    echo '-----------------------------------------'
    printf "PID: %d\n" "${PID}"
    printf "COMM: %s\n" "$(cat "/proc/${PID}/comm")"
    printf "%s\n" "${LAZYFREE}"
    echo '-----------------------------------------'
  fi
done
