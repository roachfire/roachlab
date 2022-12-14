#!/bin/bash

# Set the script to terminate if any commands fail.

set -e
echo "Developer: RoachFire https://github.com/roachfire"
echo "Usage: This script installs and configures some depedencies for the Telegraf application, based of off the install isnturctions found here: https://du.nkel.dev/blog/2021-05-05_proxmox_influxdb/."

# This section makes the necessary edits to /etc/pve/status.cfg to tell Proxmox to report metrics to an internal Telegraf application.
# Check if the file exists
if [ -f /etc/pve/status.cfg ]; then # Replace the text in the file
    echo "Attempting to make changes to /etc/pve/status.cfg to use Telegraf as metrics agent..."
    > /etc/pve/status.cfg
    if 
      ! sed -i.bak '1iinfluxdb: InfluxDB\nserver 127.0.0.1\nport 8089/' /etc/pve/status.cfg; 
    then 
      echo "The file /etc/pve/status.cfg does not exist. Please verify that you are running the latest version of Proxmox and have not deleted the file."
      exit 1
    else
        echo "The file /etc/pve/status.cfg was successfully modified. Continuing..."
    fi
fi

# Adds the influxDB GPG keys.
if ! wget -qO- https://repos.influxdata.com/influxdb.key | tee /etc/apt/trusted.gpg.d/influxdb.asc >/dev/null; then
    echo "Unable to add the influxDB GPG keys to the host."
    exit 1
  else 
    echo "Keys added. Attempting to add influxdb repo to apt..."  
fi

# Adds the influxdata debian bullseye stable repo to the apt sources.
if grep -q "deb https://repos.influxdata.com/debian bullseye stable/" /etc/apt/sources.list.d/influxdb.list; then
  echo "The influxdata repo is already present. Updating apt repo."
else
  echo "The data/file is not present on the system. Attempting to add it."
  touch /etc/apt/sources.list.d/influxdb.list
  echo "deb https://repos.influxdata.com/debian bullseye stable" | tee -a /etc/apt/sources.list.d/influxdb.list
fi

# Updates apt repositories.
if ! apt-get update; then
  echo "Error: unable to update package list, please check logs for errors"
  exit 1
else
  echo "Package list updated. Continuing..."
fi

# Installs Telegraf.
if ! apt-get install telegraf; then
  echo "Error: unable to install Telegraf, please check logs for errors"
  exit 1
else
  echo "Telegraf successfully installed. Continuing..."
fi

# Installs sudo
if ! apt-get install sudo; then
  echo "Error: unable to install sudo, please check logs for errors"
  exit 1
else
  echo "Sudo successfully installed. Continuing..."
fi

# Installs lm-sensors tool.
if ! apt-get install lm-sensors watch; then
  echo "Error: unable to install lm-sensors, please check logs for errors"
  exit 1
else
  echo "lm-sensors successfully installed. Attempting to download Telegraf.conf template from https://raw.githubusercontent.com/roachfire/roachlab/main/monitoring/telegraf.conf and backup original file."
fi

# Backs up the original Telegraf.conf just in case, then downloads the template from GitHub..
if ! cp /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.bak; then
  echo "Error, unable to backup original file."
  exit 1
else
  curl -o telegraf.conf https://raw.githubusercontent.com/roachfire/roachlab/main/monitoring/telegraf.conf
  mv telegraf.conf /etc/telegraf/telegraf.conf
  echo "Operation completted. Refer back to documentation for further setup instructions."
fi
