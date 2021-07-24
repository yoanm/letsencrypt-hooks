#!/bin/sh
set -e
# Available vars 
# $RENEWED_DOMAINS (Ex: "test.domain.tld" or "test.domain.tld test2.domain.tld ...")
# $RENEWED_LINEAGE (Ex: "/etc/letsencrypt/live/test.domain.tld" 
#
# Script will replace routerOs certificate if the domain match
# N.B.: Hook requires https://github.com/yoanm/letsencrypt-routeros to be installed

# Update the following based on your needs (at least update router ip and domain)
## If presents in domain list, routerOs will be updated with the newly created certificates
ROUTEROS_DOMAIN="router.domain.tld"
## RouterOs ip for ssh/scp
ROUTEROS_IP=A.B.C.D
## RouterOs username for ssh/scp
## User requires following policies enabled : ssh, ftp, write
ROUTEROS_USER=certbot
## RouterOs port for ssh/scp
ROUTEROS_SSH_PORT=22
## ssh identify file for $ROUTEROS_USER
SSH_IDENTITY_FILE="/etc/letsencrypt/renewal-hooks/certbot.id.rsa"

CERTIFICATE_DIRECTORY=$RENEWED_LINEAGE
CERT_FILE="${CERTIFICATE_DIRECTORY}/fullchain.pem"
KEY_FILE="${CERTIFICATE_DIRECTORY}/privkey.pem"

# A certificate may have many domains !
for DOMAIN in $RENEWED_DOMAINS; do
    case $DOMAIN in
        $ROUTEROS_DOMAIN)
            echo "#### [INFO] Importing \"$ROUTEROS_DOMAIN\" certificates & key to \"$ROUTEROS_IP\" router"

            # Checks
            if [ ! -f $SSH_IDENTITY_FILE ]; then
                echo "#### [ERROR] Identity file not found !"
                echo "#### [ERROR] Please use following command to generate it. Then upload public key to router and assign it to the right user"
                echo "#### [ERROR]     root@server> ssh-keygen -t rsa -b 2048 -C \"${ROUTEROS_USER}@$(hostname)\" -N \"\" -f ${SSH_IDENTITY_FILE}"
                echo "#### [ERROR] upload the public key to routerOs."
                echo "#### [ERROR] Then, on routerOs , create the group and the user"
                echo "#### [ERROR]     [admin@mikrotik]> /user group add name=certbot policy=ssh,ftp,write"
                echo "#### [ERROR]     [admin@mikrotik]> /user add name=certbot group=certbot address=__SOURCE_IP__"
                echo "#### [ERROR]     [admin@mikrotik]> /user ssh-keys import file=certbot.id.rsa user=certbot"
                exit 1;
            elif [ ! -f $CERT_FILE ]; then
                echo "#### [ERROR] certificate ${CERT_FILE} not found !"
                exit 2;
            elif [ ! -f $KEY_FILE ]; then
                echo "#### [ERROR] Key ${KEY_FILE} not found !"
                exit 3;
            fi

            /opt/letsencrypt-routeros/update-router-certificate.sh "$ROUTEROS_USER" "$ROUTEROS_IP" "$ROUTEROS_SSH_PORT" \
                "$ROUTEROS_DOMAIN" \
                "$CERT_FILE" "$KEY_FILE" \
                "$SSH_IDENTITY_FILE"

            echo "#### [INFO] new \"$ROUTEROS_DOMAIN\" certificates & key configured for \"$ROUTEROS_IP\" router"
            ;;
    esac
done
