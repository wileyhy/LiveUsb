#!/bin/bash


if [[ "$(firewall-cmd --query-lockdown)" = "yes" ]]
then
  printf '\nfirewall-cmd, Firewall is in lockdown mode. Exiting.\n\n'
  exit 3
fi

sudo -v

set -Caeux

firewall-cmd --state

firewall-cmd --list-all

firewall-cmd --get-log-denied 
sudo firewall-cmd --set-log-denied=unicast 
firewall-cmd --get-log-denied 

firewall-cmd --list-all

firewall-cmd --get-default-zone 
sudo firewall-cmd --set-default-zone=drop
firewall-cmd --get-default-zone 

firewall-cmd --list-all

firewall-cmd --zone=drop --list-interfaces 
sudo firewall-cmd --zone=drop --add-interface=wlo1
firewall-cmd --zone=drop --list-interfaces 

firewall-cmd --list-all

firewall-cmd --zone=drop --list-sources
sudo firewall-cmd --zone=drop --add-source=ea:9a:c9:f3:a6:7d
sudo firewall-cmd --zone=drop --add-source=20:79:18:b0:59:1e
firewall-cmd --zone=drop --list-sources

firewall-cmd --list-all

sudo firewall-cmd --remove-forward

firewall-cmd --list-all

sudo firewall-cmd --runtime-to-permanent 

firewall-cmd --list-lockdown-whitelist-commands 

firewall-cmd --list-lockdown-whitelist-contexts 
sudo firewall-cmd --remove-lockdown-whitelist-context=system_u:system_r:NetworkManager_t:s0
sudo firewall-cmd --remove-lockdown-whitelist-context=system_u:system_r:virtd_t:s0-s0:c0.c1023
firewall-cmd --list-lockdown-whitelist-contexts 

firewall-cmd --list-lockdown-whitelist-uids 
sudo firewall-cmd --remove-lockdown-whitelist-uid=0
firewall-cmd --list-lockdown-whitelist-uids 

firewall-cmd --list-lockdown-whitelist-users 

firewall-cmd --list-all

sudo firewall-cmd --runtime-to-permanent 

sudo firewall-cmd --lockdown-on

firewall-cmd --list-all

