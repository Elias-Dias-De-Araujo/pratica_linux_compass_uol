#!/bin/bash

date_hour=$(TZ="America/Fortaleza" date +"%d-%m-%Y %H:%M:%S")
status_server=$(systemctl is-active httpd)

if [ "$status_server" == "active" ]; then
    msg="ONLINE"
else
    msg="OFFLINE"
fi

# Variável guarda o caminho para pasta do filesystem que ficam os logs
archive_name="/sua_pasta/$date_hour.txt"

echo "$date_hour + httpd + $status_server + $msg" > "$archive_name"
