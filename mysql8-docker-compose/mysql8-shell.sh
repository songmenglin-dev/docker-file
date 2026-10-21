#!/bin/bash
# Enter the mysql8 container shell, or run a command inside it.
# Usage:
#   ./mysql8-shell.sh                          # interactive bash
#   ./mysql8-shell.sh mysqldump -uroot -p...   # run mysqldump
#   ./mysql8-shell.sh mysql -uroot -p... -e 'SELECT 1'
[ -t 0 ] && T="-it" || T="-i"
[ $# -eq 0 ] && set -- bash
exec docker exec $T mysql8 "$@"