#!/bin/bash

date_hour=$(date +"%Y-%m-%d-%H:%M:%S")
status_server=$(systemctl is-active httpd)

if [ "$status_server" == "active" ]; then
    msg="ONLINE"
else
    msg="OFFLINE"
fi

# Essa variável guarda o caminho para a pasta compartilhada com o filesystem
archive_name="../seu_diretorio/$date_hour.txt"

echo "$date_hour + httpd + $status_server + $msg" > "$archive_name"

