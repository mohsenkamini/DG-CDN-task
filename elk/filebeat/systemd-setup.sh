#!/bin/bash

sudo dpkg -i filebeat-7.14.2-amd64.deb
cp data/filebeat/data01/systemd-filebeat.yml /etc/filebeat/filebeat.yml
systemctl restart filebeat.service
