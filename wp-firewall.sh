#!/bin/bash

FILE="/etc/iptables/firewall/log/wp-login.log"
DEFRULES="/etc/iptables/firewall/rules/default"
RULES="/etc/iptables/firewall/rules/wordpress"
MAXATTEMPTS=10

iptables-restore $DEFRULES

cat /var/log/apache2/other_vhosts_access.log | grep -i "wp-login.php" | awk '{print $2}'| sort | uniq -dc > $FILE

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
