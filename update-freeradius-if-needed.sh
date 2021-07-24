#!/bin/bash
set -e
# Available vars 
# $RENEWED_DOMAINS (Ex: "test.domain.tld" or "test.domain.tld test2.domain.tld ...")
# $RENEWED_LINEAGE (Ex: "/etc/letsencrypt/live/test.domain.tld"
#
# Script will move private and public key to freeradius config directory and restart it

# Update the following based on your needs (at least update the domain)
TARGET_DOMAIN='radius.domain.tld'
FREERADIUS_CERTIFICATE_FOLDER='/etc/freeradius/3.0/certs'

RESTART_REQUIRED=0
for DOMAIN in $RENEWED_DOMAINS; do
    case $DOMAIN in
        $TARGET_DOMAIN)
            RESTART_REQUIRED=1
        ;;
    esac
done

if [ $RESTART_REQUIRED -eq 1 ]; then
    echo '#### [INFO] Updating freeradius certificates'
    cp ${RENEWED_LINEAGE}/{fullchain,privkey}.pem ${FREERADIUS_CERTIFICATE_FOLDER}/
    chown freerad:freerad ${FREERADIUS_CERTIFICATE_FOLDER}/{fullchain,privkey}.pem
    echo '#### [INFO] Restarting freeradius'
    /etc/init.d/freeradius restart
    echo '#### [INFO] freeradius updated & restarted'
fi
