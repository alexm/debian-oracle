#!/bin/sh

scp -P 2200 -o UserKnownHostsFile=/dev/null "$@"
