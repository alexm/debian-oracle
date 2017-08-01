rsync --rsh="ssh -l vagrant -p 2222 -o UserKnownHostsFile=/dev/null" "$@"
