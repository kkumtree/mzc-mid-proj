#!/bin/bash

DEBIAN_FRONTEND=noninteractive

echo "============================================="
echo "=== START: Background job in $HOME"
echo "============================================="

CRON_SUDO_COMMAND="@reboot sudo su -"

CRON_SUDO=vagrant
CRON_SUDO_HOME=/home/$CRON_SUDO
CRON_SUDO_DIR=$CRON_SUDO_HOME/shell
CRON_SUDO_FILE=ubuntu_full_upgrade.sh
CRON_SUDO_JOB=$CRON_SUDO_DIR/$CRON_SUDO_FILE

CRON_LOG_DIR=/vagrant/log/ctrl
CRON_LOG_STDOUT=$CRON_LOG_DIR/$CRON_SUDO_FILE.out.log
CRON_LOG_STDERR=$CRON_LOG_DIR/$CRON_SUDO_FILE.err.log

sudo chmod +w $

# @reboot sudo -u vagrant /home/vagrant/shell/ubuntu_full_upgrade.sh
CRON_SUDO_SCRIPT="$CRON_SUDO_COMMAND $CRON_SUDO $CRON_SUDO_JOB > $CRON_LOG_STDOUT 2> $CRON_LOG_STDERR"

sudo -u root /bin/bash -c "cat <(crontab -l) <(echo $CRON_SUDO_SCRIPT) | crontab -"
echo "============================================="
echo "=== !WAIT!: cronjob for $CRON_SUDO_FILE"
echo "============================================="