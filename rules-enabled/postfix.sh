#!/bin/bash

# Configuration
FILE="/etc/iptables/firewall/log/postfix.log"
RULES="/etc/iptables/firewall/rules/postfix"
LOGFILE="/usr/local/psa/var/log/maillog"
MAXATTEMPTS=4

# Count requests per ip matching a pattern
cat "$LOGFILE" | grep -i "Message delivery request rate limit exceeded" | awk '{print $15}' | sed 's/.*\[//g' | sed 's/\]//g' | sort | uniq -c > $FILE

# Debian example
# LOGFILE="/var/log/mail.log"
# cat "$LOGFILE" | grep -i "Message delivery request rate limit exceeded" | awk '{print $15}' | sed 's/.*\[//g' | sed 's/\]//g' | sort | uniq -c > $FILE


# Ban malicious IPs
ATTACKER=false
ATTACK=false

while read line
do
	ATTACK=$(echo $line | awk '{print $1}')
	#echo "$ATTACK"
	ATTACKER=$(echo $line | awk '{print $2}')
	#echo "$ATTACKER"
	if [ "$ATTACK" -gt "$MAXATTEMPTS" ]
	then
	echo "$ATTACKER exceeded message delivery request rate $ATTACK times: BANNED"
	iptables -A INPUT -p tcp --dport 25 -s "$ATTACKER" -j REJECT
	iptables -A INPUT -p tcp --dport 995 -s "$ATTACKER" -j REJECT
	fi
done < $FILE

iptables-save > $RULES
