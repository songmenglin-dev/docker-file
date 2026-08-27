#!/bin/bash
[ -t 0 ] && T="-it" || T="-i"
exec docker exec $T mysql8 mysql -uroot -p18162161837Xiner "$@"
