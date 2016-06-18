#!/bin/sh -eux

ubuntu_version="`lsb_release -r | awk '{print $2}'`";
ubuntu_major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

# Disable release-upgrades
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades;

# Update the package list
apt-get -y update;

# Install curl
apt-get -y install curl;

# Upgrade all installed packages incl. kernel and kernel headers
apt-get -y dist-upgrade --force-yes;
reboot;
sleep 60;

# update package index on boot
cat <<EOF >/etc/init/refresh-apt.conf;
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF

# Manage broken indexes on distro disc 12.04.5
if [ "$ubuntu_version" = "12.04" ]; then
    apt-get -y install libreadline-dev dpkg;
fi
