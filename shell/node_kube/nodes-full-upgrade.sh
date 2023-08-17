#!/bin/bash

DEBIAN_FRONTEND=noninteractive
sudo apt-get update -yqq && sudo apt-get -yq full-upgrade > /dev/null 2>&1
# sudo ufw disable
echo "=== COMPLETE: full-upgrade ==="
cat <(crontab -l) <(echo "@reboot sudo -u vagrant /home/vagrant/shell/nodes-setup-package.sh") | crontab -
echo "=== ADD: crontab for setup-package.sh ==="
sudo reboot -f
