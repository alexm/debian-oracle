rsync --rsh="ssh -l vagrant -p 2200 -o UserKnownHostsFile=/dev/null" "$@"
