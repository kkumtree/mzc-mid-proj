#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# PRE_CRON_SHELL=ubuntu_full_upgrade.sh

CRON_SUDO_COMMAND="@reboot sudo su -"

# cronjob user
CRON_SUDO="vagrant"
CRON_SUDO_HOME="/home/$CRON_SUDO"
CRON_SUDO_DIR="$CRON_SUDO_HOME/shell"

# cronjob script
CRON_SUDO_FILE="controller_sequence.sh"
CRON_SUDO_JOB="$CRON_SUDO_DIR/$CRON_SUDO_FILE"

# cronjob log
CRON_LOG_DIR="/vagrant"
CRON_LOG_TIME=`date '+%y%m%d_%H%M%S'`
CRON_LOG_STDOUT="$CRON_LOG_DIR/$CRON_SUDO_FILE.$CRON_LOG_TIME.out.log"
CRON_LOG_STDERR="$CRON_LOG_DIR/$CRON_SUDO_FILE.$CRON_LOG_TIME.err.log"

# @reboot sudo -u vagrant /home/vagrant/shell/ubuntu_full_upgrade.sh > /vagrant/log/ctrl/ubuntu_full_upgrade.sh.out.log 2> /vagrant/log/ctrl/ubuntu_full_upgrade.sh.err.log
CRON_FULL_SCRIPT="$CRON_SUDO_COMMAND $CRON_SUDO $CRON_SUDO_JOB > $CRON_LOG_STDOUT 2> $CRON_LOG_STDERR"

# # Internal Logging

# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>$CRON_LOG_STDOUT 2>$CRON_LOG_STDERR

echo "============================================="
echo "=== START: $0"
echo "============================================="

sudo apt-get update -yqq && sudo apt-get -yq full-upgrade > /vagrant/full-upgrade.log

# # remove cronjob
# sudo -u root /bin/bash -c "crontab -l | sed -e '/$PRE_CRON_SHELL/d' | crontab -"
# # sudo -u root /bin/bash -c "crontab -l | sed -e '/\(.*reboot-sequence.sh*\)/d' | crontab -"

# add cronjob
sudo touch $CRON_LOG_STDOUT $CRON_LOG_STDERR
sudo chmod +w $CRON_LOG_STDOUT $CRON_LOG_STDERR
sudo -u root /bin/bash -c "cat <(crontab -l) <(echo \"$CRON_FULL_SCRIPT\") | crontab -"

echo "=== COMPLETE: $0 ==="

echo "============================================="
echo "=== !WAIT!: cronjob for $CRON_SUDO_FILE"
echo "============================================="

