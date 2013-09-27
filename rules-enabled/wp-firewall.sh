#!/bin/bash

# Configuration
FILE="/etc/iptables/firewall/log/wordpress.log"
RULES="/etc/iptables/firewall/rules/wordpress"
LOGFILE="/var/log/apache2/other_vhosts_access.log"
MAXATTEMPTS=10

# Count requests per ip matching a pattern
cat "$LOGFILE" | grep "GET /wp-login.php" | awk '{print $2}' | sort | uniq -dc > $FILE

# Debian example
# LOGFILE="/var/log/apache2/other_vhosts_access.log"
# cat "$LOGFILE" | grep -i "malicious_pattern" | awk '{print $ip_position_in_log_line}' | sort | uniq -dc > $FILE

# Plesk example
# LOGFILE=$(find /var/www/vhosts -name "access_log.processed" -print0 | xargs -0 cat)
# cat "$LOGFILE" |grep -i "wp-login.php" | awk '{print $1}' | sort | uniq -dc > $FILE

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
