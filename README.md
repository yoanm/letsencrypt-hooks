# Let's Encrypt hooks
Several Letsencrypt hooks for automatic certificate renewal and install

When a certificate will be renewed, you can use one of those hooks to install the new certificate to related hosts or processes.

You just have to move the script under Letsencrypt directory and call it on `deploy.sh` script (or update the config to add the hook, or specify hook file from command line)

 - [External QNAP host](./update-qnap-if-needed.sh)
 - [External RouterOs host](./update-routeros-if-needed.sh)
 - [Internal Freeradius process](./update-freeradius-if-needed.sh)
 - [Internal nginx process](./update-nginx-if-needed.sh)
 - [Internal Zabbix server process](./update-zabbix-server-if-needed.sh)
 - [Internal Zabbix agent process](./update-zabbix-agent-if-needed.sh)
