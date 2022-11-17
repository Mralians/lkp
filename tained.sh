#!/usr/bin/env bash

# SCRIPT: tained.sh
# DESCRIPTION: -
# USAGE: -


for i in $(seq 18);do
  echo $(($i-1)) $(($(cat /proc/sys/kernel/tainted) >> ($i-1)&1))
done

exit 0


