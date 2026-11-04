#!/bin/bash
CMD=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.containers[0].command[*]} {.spec.containers[0].args[*]}' 2>/dev/null)
if [ -z "$CMD" ]; then echo "Container has no command"; exit 1; fi
echo "$CMD" | grep -q "/bin/sh" || { echo "Command does not invoke a shell (/bin/sh): '$CMD'"; exit 1; }
echo "$CMD" | grep -q "while true" || { echo "Command has no 'while true' loop: '$CMD'"; exit 1; }
echo "$CMD" | grep -q "time-check.log" || { echo "Command does not append to time-check.log: '$CMD'"; exit 1; }
echo "$CMD" | grep -q "date" || { echo "Command does not write the date: '$CMD'"; exit 1; }
echo "$CMD" | grep -q 'sleep \$TIME_FREQ' || { echo "Command does not sleep \$TIME_FREQ: '$CMD'"; exit 1; }
echo "Command loops writing the date to /opt/time/time-check.log"; exit 0
