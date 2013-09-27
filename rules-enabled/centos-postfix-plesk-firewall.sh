#!/bin/bash

# Configuration
FILE="/etc/iptables/firewall/log/postfix.log"
RULES="/etc/iptables/firewall/rules/postfix"
MAXATTEMPTS=10

# Count requests per ip matching a pattern
cat /usr/local/psa/var/log/maillog | grep -i "Message delivery request rate limit exceeded" | awk '{print $15}' | sed 's/.*\[//g' | sed 's/\]//g' | sort | uniq -c > $FILE

# General example
# cat /path/to/apache/logs | grep -i "malicious_pattern" | awk '{print $ip_position_in_log_line}' | sort | uniq -dc > $FILE

# Plesk example
# find /var/www/vhosts -name "access_log.processed" -print0 | xargs -0 cat |grep -i "wp-login.php" | awk '{print $1}' | sort | uniq -dc > $FILE

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
	echo "$ATTACKER attempted $ATTACK times: BANNED"
	iptables -A INPUT -p tcp --dport 80 -s "$ATTACKER" -j REJECT
	fi
done < $FILE

iptables-save > $RULES
