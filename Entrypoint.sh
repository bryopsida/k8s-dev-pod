#!/bin/bash

# setup permissions
sudo mkdir -p /etc/dropbear
sudo chmod 700 /etc/dropbear
sudo chown -R developer:developer /etc/dropbear
touch /etc/dropbear/authorized_keys
chmod 600 /etc/dropbear/authorized_keys 
sudo chown -R developer:developer /home/developer

# setup home directory links/permissions etc
# this occurs on every container startup and is meant to be idempotent without overwriting existing files
/usr/local/bin/prepare_home.sh

passwordLoginEnabled=${PASSWORD_LOGIN_ENABLED:-"false"}
if [[ $passwordLoginEnabled == "true" ]]; then
  # Create a random password for developer and echo it to the console
  PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo "developer:$PASSWORD"| sudo chpasswd
  echo "Your password is: $PASSWORD"
  exec dropbear -R -w -F -E -p 3022 -P /var/run/dropbear.pid
else
  echo "Password login is disabled"
  sudo passwd -d developer
  exec dropbear -R -w -F -E -s -p 3022 -P /var/run/dropbear.pid
fi