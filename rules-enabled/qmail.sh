#!/bin/bash

# Configuration
FILE="/root/firewall/rules/qmail.log"
LOGFILE="/usr/local/psa/var/log/maillog"
MAXATTEMPTS=1

# Count requests per ip matching a pattern
#cat "$LOGFILE" | grep -i "Message delivery request rate limit exceeded" | awk '{print $15}' | sed 's/.*\[//g' | sed 's/\]//g' | sort | uniq -c > $FILE
#cat "/usr/local/psa/var/log/maillog" |grep "INFO: LOGIN" | awk '{print $10}' | sed 's/^.*\[::ffff://g' | sed 's/\].*$//g' | sort | uniq -c

# Count per-domain sent mail
cat "$LOGFILE" |grep -i "qmail-remote-handlers" |grep -i "from=" |awk '{print $6}'| sed 's/^.*@//g' | sort | uniq -c > $FILE

# Ban malicious IPs
COMPROMISED=false
ATTACK=false

while read line
do
        ATTACK=$(echo $line | awk '{print $1}')
        #echo "$ATTACK"
        COMPROMISED=$(echo $line | awk '{print $2}')
        #echo "$ATTACKER"
        if [ "$ATTACK" -gt "$MAXATTEMPTS" ]
        then
        echo "$COMPROMISED sent $ATTACK messages"
    
        #/usr/local/psa/bin/domain --update "$COMPROMISED" -mail_service off
    
        echo "test run - domain not deactivated"
    
        fi  
done < $FILE
