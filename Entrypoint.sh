#!/bin/sh
# Create a random password for developer and echo it to the console
PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo "Your password is: $PASSWORD"
echo -e "$PASSWORD\n$PASSWORD" | sudo passwd developer

# setup permissions
sudo mkdir -p /etc/dropbear
sudo chmod 700 /etc/dropbear
sudo chown -R developer:developer /etc/dropbear
touch /etc/dropbear/authorized_keys
chmod 600 /etc/dropbear/authorized_keys 

exec dropbear -R -w -F -E -p 22 -P /var/run/dropbear.pid