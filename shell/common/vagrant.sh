#!/bin/bash

DEBIAN_FRONTEND=noninteractive

if [ $# -ne 1 ]; then
  echo "Usage: $0 <type>"
  echo "type: [ctrl|lb|node]"
  exit 1
fi

CURRENT_SHELL_NAME=`basename $0 | sed -e 's/\.sh//g'`
TYPE=$1

# sudo mount -a
# sleep 10

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
USER_VARIABLE_DIR="$USER_HOME/variable"
USER_CONF_DIR="$USER_HOME/conf"
USER_SYS_DIR="$USER_HOME/system"

NEXT_JOB="@reboot"
NEXT_SHELL="ubuntu_upgrade.sh"
NEXT_SHELL_DIR="$USER_SHELL_DIR"
NEXT_SHELL_PATH="$NEXT_SHELL_DIR/$NEXT_SHELL"

###

#### END Logging Template ####

echo "==== Start $0 at $HOME ===="

mkdir -p $USER_SHELL_DIR
cp -r /vagrant/shell/common/. $USER_SHELL_DIR/
cp -r /vagrant/shell/$TYPE\_kube/. $USER_SHELL_DIR/

mkdir -p $USER_VARIABLE_DIR
cp -r /vagrant/variable/. $USER_VARIABLE_DIR/

mkdir -p $USER_CONF_DIR
cp -r /vagrant/conf/. $USER_CONF_DIR/

mkdir -p $USER_SYS_DIR
cp -r /vagrant/shell/system/. $USER_SYS_DIR/

sudo chown -R $USER:$USER $USER_SHELL_DIR
sudo chown -R $USER:$USER $USER_VARIABLE_DIR
sudo chown -R $USER:$USER $USER_CONF_DIR
sudo chown -R $USER:$USER $USER_SYS_DIR

sudo -u $USER /bin/bash -c "cat <(crontab -l) <(echo \"$NEXT_JOB $NEXT_SHELL_PATH $TYPE\") | crontab -"

echo "============================================="
echo "=== !WAIT!: cronjob for $NEXT_SHELL"
echo "============================================="

echo "==== Complete $0 at $HOME ===="

sudo reboot -f