#!/bin/bash

#Requires: iptables-persistent grep awk uniq

mkdir /etc/iptables/firewall
mkdir /etc/iptables/firewall/log
mkdir /etc/iptables/firewall/rules

iptables-save > /etc/iptables/firewall/rules/default
