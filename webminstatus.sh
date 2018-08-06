#!/bin/bash
set -x

tempfile=$(mktemp /tmp/webminstatus-XXXX.log)

SETATUS=$(service webmin status | grep running)
SEKARANG=$(TZ="Asia/Jakarta" date +'%A %d-%m-%Y %R')

if [ -z "$SETATUS" ]; then
        service webmin restart > $tempfile
        /usr/local/sbin/telegram-notify --error --title "Webmin baru direstart bos" --text "$tempfile" > /dev/null
        /usr/local/sbin/telegram-notify --text "$SEKARANG" > /dev/null
        rm $tempfile
else
        /usr/local/sbin/telegram-notify --success --title "Webmin aman bos" --text "Udah, gitu aja" > /dev/null
        /usr/local/sbin/telegram-notify --text "$SEKARANG" > /dev/null
fi

