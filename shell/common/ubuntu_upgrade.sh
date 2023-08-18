#!/bin/bash

DEBIAN_FRONTEND=noninteractive

if [ $# -ne 1 ]; then
  echo "Usage: $0 <type>"
  echo "type: [ctrl|node|lb]"
  exit 1
fi

CURRENT_SHELL_NAME=`basename $0 | sed -e 's/\.sh//g'`
TYPE=$1

sudo mount -a
sleep 10

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

### Next Job

USER="vagrant"
USER_HOME="/home/$USER"
USER_SHELL_DIR="$USER_HOME/shell"
# USER_VARIABLE_DIR="$USER_HOME/variable"

NEXT_JOB="@reboot"
# NEXT_JOB="@reboot sudo"
NEXT_SHELL_DIR="$USER_SHELL_DIR"
NEXT_SHELL="sequence.sh"
NEXT_SHELL_PATH="$NEXT_SHELL_DIR/$NEXT_SHELL"

###

#### END Logging Template ####

echo "============================================="
echo "=== START: $0 at $HOME ===="
echo "============================================="

sudo apt-get update -yqq && sudo apt-get -yqq upgrade 

if [ $TYPE = "ctrl" -o $TYPE = "node" ]; then
  /bin/bash /vagrant/shell/shell_initializer.sh /vagrant/system sys
fi

# remove cronjob
crontab -l | sed -e "/$CURRENT_SHELL_NAME/d" | crontab -

# add cronjob
# cat <(crontab -l) <(echo "$NEXT_JOB $NEXT_SHELL_PATH $TYPE") | crontab -
# sudo -u root /bin/bash -c "cat <(crontab -l) <(echo \"$NEXT_JOB $NEXT_SHELL_PATH $TYPE\") | crontab -"

echo "=== COMPLETE: $0 ==="

echo "============================================="
echo "=== !WAIT!: cronjob for $NEXT_SHELL"
echo "============================================="

echo "==== Complete $0 at $HOME ===="

# sudo reboot -f
