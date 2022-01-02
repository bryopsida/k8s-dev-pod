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