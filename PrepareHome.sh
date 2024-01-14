#!/bin/bash

# ensure ~/.ssh exists
mkdir -p ~/.ssh

# create link to drop bear authorized keys
if [ -e ~/.ssh/authorized_keys ] ; then
  echo "Authorized keys already exists, skipping..."
else
  echo "Creating authorized_keys link..."
  ln -s /etc/dropbear/authorized_keys ~/.ssh/authorized_keys
fi

# seed .bashrc
if [ -e ~/.bashrc ] ; then
  echo "bash profile already exists, skipping..."
else
  cp /etc/skel/.bashrc ~/
fi

# ~ folder should be 0755
chmod 0755 ~
# ~/.ssh should be 0700
chmod 0700 ~/.ssh
# ~/.ssh/authorized_keys should be 0600
chmod 0600 ~/.ssh/authorized_keys
