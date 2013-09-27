#!/bin/bash

DEFRULES="/etc/iptables/firewall/rules/default"

# Restore default  iptables
iptables-restore $DEFRULES

#Apply all firewall enabled rules
cd rules-enabled

for file in *.sh
do
	sh $file
done

