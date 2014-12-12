#!/bin/bash

FILE="/etc/iptables/firewall/log/wp-xmlrpc.log"
RULES="/etc/iptables/firewall/rules/firewall"
LOGFILE="/var/log/apache2/other_vhosts_access.log"
MAXATTEMPTS=2

cat $LOGFILE | grep "POST /xmlrpc.php" | awk '{print $2}'| sort | uniq -dc > $FILE

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
		iptables -A INPUT -p tcp --dport 443 -s "$ATTACKER" -j REJECT
	fi	
done < $FILE

iptables-save > $RULES
