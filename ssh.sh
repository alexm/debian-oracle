#!/bin/sh
#
# open virtualbox
# map host:2200 to oracle-sid:22
# launch oracle-sid
#
REMOTE_USER=vagrant
[ -n "$1" ] && REMOTE_USER="$1"

# 5500 is Oracle Web UI
ssh -XC -p 2200 -L5500:localhost:5500 -o UserKnownHostsFile=/dev/null ${REMOTE_USER}@localhost
