#!/bin/bash
set -e
# Available vars 
# $RENEWED_DOMAINS (Ex: "test.domain.tld" or "test.domain.tld test2.domain.tld ...")
# $RENEWED_LINEAGE (Ex: "/etc/letsencrypt/live/test.domain.tld"
#
# Script will restart nginx in case at least one of the nginx domains exists in the renewed certificate domain list
# N.B. : Nginx ssl config must point to letsencrypt "live" directory!

NGINX_RESTART_REQUIRED=0
NGINX_DOMAIN_LIST=$(grep -r "server_name" /etc/nginx/sites-enabled/*|sed 's/.*server_name\(.*\)/\1/'|tr -d "\n" | tr -d ';')

for DOMAIN in $RENEWED_DOMAINS; do
    if [[ $NGINX_DOMAIN_LIST =~ (^|[[:space:]])${DOMAIN}($|[[:space:]]) ]]; then
        NGINX_RESTART_REQUIRED=1
    fi
done

if [ $NGINX_RESTART_REQUIRED -eq 1 ]; then
    echo '#### [INFO] Restarting NGINX'
    /etc/init.d/nginx restart
    echo '#### [INFO] NGINX restarted'
fi
