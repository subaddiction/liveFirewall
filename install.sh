#!/bin/bash

#Requires: iptables-persistent grep awk uniq

mkdir -p /etc/iptables/firewall
mkdir -p /etc/iptables/firewall/log
mkdir -p /etc/iptables/firewall/rules

iptables-save > /etc/iptables/firewall/rules/default
