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

# ## Interrupt for system

# if [ $TYPE = "sys" ]; then
#   echo "============================================="
#   echo "=== INTERRUPT: SYSTEM SETUP after upgrade ==="
#   echo "============================================="
#   /bin/bash /vagrant/shell/shell_initializer.sh /vagrant/shell/$TYPE $TYPE
#   exit 0
# fi

# ### Next Job

USER="vagrant"
USER_HOME="/home/$USER"
USER_SHELL_DIR="$USER_HOME/shell"
# USER_VARIABLE_DIR="$USER_HOME/variable"

# NEXT_JOB="@reboot sudo"
NEXT_SHELL_DIR="$USER_SHELL_DIR"
NEXT_SHELL="shell_initializer.sh"
NEXT_SHELL_PATH="$NEXT_SHELL_DIR/$NEXT_SHELL"

# ###

#### END Logging Template ####

###


###

echo "============================================="
echo "=== START: $0 at $HOME"
echo "=== UID: $UID"
echo "=== USER: $(id -u)"

###

if [ ! -f $HOME/.bash_aliases ]; then
  echo "^*^$HOME/.bash_aliases is not found^*^"
  touch $HOME/.bash_aliases
  echo "^*^$HOME/.bash_aliases is created^*^"
fi


if [ -z "$_CRIO_ROOTLESS" ]; then
  echo "^*^_CRIO_ROOTLESS is set MANUALLY^*^"
  _CRIO_ROOTLESS=1
  export _CRIO_ROOTLESS
  echo 'export _CRIO_ROOTLESS=1' >> $HOME/.bash_aliases
fi

if [ -z "$XDG_RUNTIME_DIR" ]; then
  echo "^*^XDG_RUNTIME_DIR is set MANUALLY^*^"
  XDG_RUNTIME_DIR=/run/user/$(id -u)
  export XDG_RUNTIME_DIR
fi

###

echo "=== XDG_RUNTIME_DIR: >> $XDG_RUNTIME_DIR <<"
echo "=== _CRIO_ROOTLESS: >> $_CRIO_ROOTLESS <<"
echo "============================================="

$NEXT_SHELL_PATH $USER_SHELL_DIR $TYPE

# remove cronjob
# sudo -u vagrant /bin/bash -c "crontab -l | sed -e s/\*\$PRE_CRON_SHELL\*/\#\1/ | crontab -"
crontab -l | sed -e "/$CURRENT_SHELL_NAME/d" | crontab -
# sudo -u root /bin/bash -c "crontab -l | sed -e '/$CURRENT_SHELL_NAME/d' | crontab -"

# # add cronjob
# sudo -u root /bin/bash -c "cat <(crontab -l) <(echo \"$NEXT_JOB $NEXT_SHELL_PATH $TYPE | sudo tee 1>$LOG_PATH 2>&1 \") | crontab -"

echo "=== COMPLETE: $0 ==="

echo "============================================="
echo "=== !CONGRAT!: kube-controller is ready"
echo "============================================="
