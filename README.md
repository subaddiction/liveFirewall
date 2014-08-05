#liveFirewall

Simple log analyzer with firewall setup

Match patterns on log files and ban malicious IPs



##How to:

-Setup daily logrotation

-Setup scripts parameters (filenames, daily max attempts permitted for IP address)

-Setup a cronjob executing cron.sh :

0,30 * * * * root cd /path/to/liveFirewall/ && sh cron.sh >/dev/null 2>&1



wp-firewall.sh - Ban IPs requesting "wp-login.php" more than 10 times per day

centos-postfix-plesk-firewall.sh - Ban IPs exceeding postfix message delivery request rate
