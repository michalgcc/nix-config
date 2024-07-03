#!/usr/bin/env bash

# Can be called in KDE Autostart System Settings on login

# Wait for kwallet
kwallet-query -l kdewallet >/dev/null

for KEY in $(ls $HOME/.ssh/id* | grep -v \.pub); do
    ssh-add -q ${KEY} </dev/null
done