#!/bin/bash

BINARY=$1
HEX=$2
OUT=$3

ADDR_LENS=`arm-none-eabi-objdump $BINARY -t | grep bench_lens | cut -f 1 -d  ' '`
ADDR_CYCLES=`arm-none-eabi-objdump $BINARY -t | grep bench_cycles | cut -f 1 -d  ' '`

openocd -l /dev/null \
        -f /usr/share/openocd/scripts/board/stm32ldiscovery.cfg \
        &>/dev/null &
# Get the pid of `openocd` (not `sudo opencd`)
OPENOCDPID=$!

sleep 1

TMP=`mktemp`

(echo "init; reset halt; flash write_image erase $HEX; reset run; sleep 2000"; echo "mdw 0x$ADDR_CYCLES 3"; echo "mdw 0x$ADDR_LENS 3"; echo 'exit') | netcat localhost 4444 > $TMP

grep -a -v '>' $TMP | grep -a "$ADDR_CYCLES" | cut -f 2-4 -d ' ' > $OUT
grep -a -v '>' $TMP | grep -a "$ADDR_LENS" | cut -f 2-4 -d ' ' >> $OUT

rm $TMP

# Kill openocd
kill $OPENOCDPID