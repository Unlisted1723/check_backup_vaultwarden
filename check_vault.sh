#!/bin/bash

FILE="/u01/app/nagios/var/exit_status.txt"

if [ -f "$FILE" ]; then
    echo "OK - Le fichier $FILE existe."
    exit 0
else
    echo "CRITICAL - Le fichier $FILE n'existe pas."
    exit 2
fi
