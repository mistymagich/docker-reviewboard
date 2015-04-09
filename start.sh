#!/bin/bash

DBUSER="${DBUSER:-reviewboard}"
DBPASSWORD="${DBPASSWORD:-reviewboard}"
DBNAME="${DBNAME:-reviewboard}"

if [ -n $MYSQL_PORT_3306_TCP_ADDR ]; then
    # For MySQL
    DBTYPE=mysql
    DBPORT=$MYSQL_PORT_3306_TCP_PORT
    DBHOST=$MYSQL_PORT_3306_TCP_ADDR
else
    # For PostgreSQL or Other
    DBTYPE="${DBTYPE:-postgresql}"
    DBPORT="${DBPORT:-$( echo "${PG_PORT_5432_TCP_PORT:-5432}" )}"
    DBHOST="${DBHOST:-$( echo "${PG_PORT_5432_TCP_ADDR:-127.0.0.1}" )}"
fi


# Get these variable either from MEMCACHED env var, or from
# linked "memcached" container.
MEMCACHED_LINKED_NOTCP="${MEMCACHED_PORT#tcp://}"
MEMCACHED="${MEMCACHED:-$( echo "${MEMCACHED_LINKED_NOTCP:-memcached}" )}"


DOMAIN="${DOMAIN:localhost}"
DEBUG="$DEBUG"

mkdir -p /var/www/

CONFFILE=/var/www/reviewboard/conf/settings_local.py

if [[ ! -d /var/www/reviewboard ]]; then
    rb-site install --noinput \
        --domain-name="$DOMAIN" \
        --site-root=/ --static-url=static/ --media-url=media/ \
        --db-type="$DBTYPE" \
        --db-name="$DBNAME" \
        --db-host="$DBHOST" \
        --db-user="$DBUSER" \
        --db-pass="$DBPASSWORD" \
        --cache-type=memcached --cache-info="$MEMCACHED" \
        --web-server-type=lighttpd --web-server-port=8000 \
        --admin-user=admin --admin-password=admin --admin-email=admin@example.com \
        /var/www/reviewboard/
fi
if [[ "$DEBUG" ]]; then
    sed -i 's/DEBUG *= *False/DEBUG=True/' "$CONFFILE"
fi

cat "$CONFFILE"

exec uwsgi --ini /uwsgi.ini
