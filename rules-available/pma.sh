#!/bin/bash

# Configuration
FILE="/etc/iptables/firewall/log/pma.log"
RULES="/etc/iptables/firewall/rules/pma"
MAXATTEMPTS=10

# Count requests per ip matching a pattern
# In plesk we must iterate over all access_log files. matching "access_*log" includes ssl logs
find /var/www/vhosts -name "access_*log" -exec grep -i "GET /\{1,3\}\(phpmyadmin\|pma\)" {} \; > pma.tmp
cat pma.tmp | awk '{print $1}' | sort | uniq -dc > $FILE
rm pma.tmp

# Debian vhosts example
# LOGFILE="/var/log/apache2/other_vhosts_access.log"
# cat "$LOGFILE" | grep -i "GET /\{1,3\}pma" | awk '{print $2}' | sort | uniq -dc > $FILE


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
                iptables -A INPUT -p tcp --dport 80 -s "$ATTACKER" -j DROP
        fi    
done < $FILE

iptables-save > $RULES
