# letsencrypt-hooks
Several Letsencrypt hooks for automatic certificate renewal and install

When a certificate will be renewed, you can use one of those hooks to install the new certificate to related hosts or processes.
You just have to move the script under Letsencrypt directory and call it on `deploy.sh` script (or update the config to add the hook)

 - External QNAP host
 - External RouterOs host
 - Internal Freeradius process
 - Internal nginx process
 - Internal Zabbix server and agent processes
