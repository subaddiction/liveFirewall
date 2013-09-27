#!/bin/bash

# Configuration
FILE="/etc/iptables/firewall/log/wordpress.log"
RULES="/etc/iptables/firewall/rules/wordpress"
MAXATTEMPTS=10

# Count requests per ip matching a pattern
cat /var/log/apache2/other_vhosts_access.log | grep "GET /wp-login.php" | awk '{print $2}' | sort | uniq -dc > $FILE

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
