#liveFirewall

Simple apache2 log analyzer with firewall setup

Match patterns on apache2 log files and ban malicious IPs



##How to:

-Setup apache2 daily logrotation

-Setup scripts parameters (filenames and daily max attempts permitted for IP address)

-Fire scripts with daily cronjobs (set it some minutes before cron.daily runs)



wp-firewall.sh - Ban IPs requesting "wp-login.php" more than 10 times per day
