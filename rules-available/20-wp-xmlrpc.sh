#!/bin/bash

FILE="/etc/iptables/firewall/log/wp-xmlrpc.log"
RULES="/etc/iptables/firewall/rules/firewall"
LOGFILE="/var/log/apache2/other_vhosts_access.log"
MAXATTEMPTS=2

cat $LOGFILE | grep "POST /xmlrpc.php" | awk '{print $2}'| sort | uniq -dc > $FILE

# In plesk we must iterate over all access_log files. matching "access_*log" includes ssl logs
#find /var/www/vhosts -name "access_*log" -exec grep -i "POST /\{1,3\}xmlrpc.php" {} \; > wp-xmlrpc.tmp
#cat wp-xmlrpc.tmp | awk '{print $1}' | sort | uniq -dc > $FILE
#rm wp-xmlrpc.tmp


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
