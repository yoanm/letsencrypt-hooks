#!/bin/bash
set -e
# Available vars 
# $RENEWED_DOMAINS (Ex: "test.domain.tld" or "test.domain.tld test2.domain.tld ...")
# $RENEWED_LINEAGE (Ex: "/etc/letsencrypt/live/test.domain.tld"
#
# Script will copy private and public keys used for Zabbix server API (used by Zabbix agents)

# Update the following based on your needs (at least update the domain)
TARGET_DOMAIN='api.zabbix.domain.tld'
ZABBIX_SSL_FOLDER='/etc/zabbix/ssl'

RESTART_REQUIRED=0
for DOMAIN in $RENEWED_DOMAINS; do
    case $DOMAIN in
        $TARGET_DOMAIN)
            RESTART_REQUIRED=1
        ;;
    esac
done

if [ $RESTART_REQUIRED -eq 1 ]; then
    echo '#### [INFO] Update API certificate for zabbix-server'
    cp -f ${RENEWED_LINEAGE}/privkey.pem ${ZABBIX_SSL_FOLDER}/keys/${TARGET_DOMAIN}.key.pem
    cp -f ${RENEWED_LINEAGE}/fullchain.pem ${ZABBIX_SSL_FOLDER}/certs/${TARGET_DOMAIN}.cert.pem
    chown zabbix: ${ZABBIX_SSL_FOLDER}/keys/${TARGET_DOMAIN}.key.pem ${ZABBIX_SSL_FOLDER}/certs/${TARGET_DOMAIN}.cert.pem
    chmod u+r-wx,g+r-wx,o+r-wx ${ZABBIX_SSL_FOLDER}/keys/${TARGET_DOMAIN}.key.pem ${ZABBIX_SSL_FOLDER}/certs/${TARGET_DOMAIN}.cert.pem
    /etc/init.d/zabbix-server restart
    echo '#### [INFO] agent certificate updated, zabbix server restarted'
fi
