#!/bin/bash

DEBIAN_FRONTEND=noninteractive

if [ $# -ne 2 ]; then
  echo "Usage: $0 <target_directory> <type>"
  exit 1
fi

CURRENT_SHELL_NAME=`basename $0 | sed -e 's/\.sh//g'`
INPUT_DIR=$1
TYPE=$2
LOOP_CNT=1

#### START Logging Template ####

### Internal Logging

LOG_DIR_ABSOLUTE="/vagrant/log"
LOG_TYPE=$TYPE
LOG_TIME=`date '+%y%m%d_%H%M%S'`
LOG_PATH="$LOG_DIR_ABSOLUTE/$LOG_TYPE/$LOG_TIME-$CURRENT_SHELL_NAME.log"

## Logging

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$LOG_PATH 2>&1

# ### Next Job

# USER="vagrant"
# USER_HOME="/home/$USER"
# USER_SHELL_DIR="$USER_HOME/shell"
# USER_VARIABLE_DIR="$USER_HOME/variable"

# NEXT_JOB="@reboot sudo"
# NEXT_SHELL="sequence.sh"
# NEXT_SHELL_PATH="$USER_SHELL_DIR/$NEXT_SHELL"

# ###

#### END Logging Template ####

# LOOP_CNT=1

if [[ ! -d "$INPUT_DIR" ]]; then
  echo "ERROR: $INPUT_DIR not found."
  exit 1
fi

echo "=== START AT: $LOG_TIME ==="
for var in $INPUT_DIR/*/*.sh; do
  if [ -f "$var" ]; then
    echo "=== PROGRESS[ $LOOP_CNT ]: $var ==="
    sudo chmod +x $var
    # sudo su - vagrant /bin/bash $var
    /bin/bash $var $TYPE
    echo "=== COMPLETE[ $LOOP_CNT ]: $var ==="
    ((LOOP_CNT++))
  fi
done

echo "=== COMPLETE at $(date '+%y%m%d_%H%M%S') ==="

