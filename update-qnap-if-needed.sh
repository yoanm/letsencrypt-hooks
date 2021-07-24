#!/bin/bash
set -e
# Available vars 
# $RENEWED_DOMAINS (Ex: "test.domain.tld" or "test.domain.tld test2.domain.tld ...")
# $RENEWED_LINEAGE (Ex: "/etc/letsencrypt/live/test.domain.tld"
QNAP_DOMAIN='XXXXXXX.YYYYYYY.ZZZZZZ'
# Be sure to set proper permissions to the folder, private key is unprotected !
QNAP_SHARED_FOLDER='/mnt/Nas/Certbot/'

CERTIFICATE_DIRECTORY=$RENEWED_LINEAGE

CERT_FILE="${CERTIFICATE_DIRECTORY}/fullchain.pem"
KEY_FILE="${CERTIFICATE_DIRECTORY}/privkey.pem"

for DOMAIN in $RENEWED_DOMAINS; do
    case $DOMAIN in
        $QNAP_DOMAIN)
            echo '#### [INFO] Copy new certificate to QNAP shared folder'
            # Copy files to NAS folder, will be automatically taken into acount by crontab
            cp $CERT_FILE $KEY_FILE $QNAP_SHARED_FOLDER
            echo '#### [INFO] Copy new certificate to QNAP shared folder - DONE'
            ;;
    esac
done
