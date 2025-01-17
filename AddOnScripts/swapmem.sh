#!/bin/sh

# Swap usage for running processes
# Original: Erik Ljungstrom 27/05/2011
# http://serverfault.com/questions/303045/what-and-why-is-my-swap-space-used-under-linux/423603#423603

# Need root to look at all processes details

case `whoami` in
    'root') : ;;
    *) exec sudo $0 "$@" ;;
esac

(
    PROC_SWAP=0
    TOTAL_SWAP=0

    for DIR in `find /proc/ -maxdepth 1 -type d | grep "^/proc/[0-9]"` ; do
        PID=`echo $DIR | cut -d / -f 3`
        CMDLINE=`cat /proc/$PID/cmdline 2>/dev/null | tr '\000' ' '`
        for SWAP in `grep Swap $DIR/smaps 2>/dev/null | awk '{ print $2 }'`
        do
            let PROC_SWAP=$PROC_SWAP+$SWAP
        done
        if [ $PROC_SWAP == 0 ]; then
            # Skip processes with no swap usage
            continue
        fi
        echo "$PROC_SWAP        [$PID] $CMDLINE"
        let TOTAL_SWAP=$TOTAL_SWAP+$PROC_SWAP
        PROC_SWAP=0
    done
    echo "$TOTAL_SWAP   Total Swap Used"
) | sort -n
