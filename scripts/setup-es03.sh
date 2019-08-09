#!/bin/bash

if [ -f /config/es03/es03.keystore ]; then
    echo "Keystore already exists, exiting. If you want to re-run please delete config/elasticsearch/elasticsearch.keystore"
    exit 0
fi

# Determine if x-pack is enabled
echo "Determining if x-pack is installed..."
if [[ -d /usr/share/elasticsearch/bin/x-pack ]]; then
    if [[ -n "$ELASTIC_PASSWORD" ]]; then

        echo "=== CREATE Keystore ==="
        echo "Elastic password is: $ELASTIC_PASSWORD"
        if [ -f /config/es03/es03.keystore ]; then
            echo "Remove old elasticsearch.keystore"
            rm /config/es03/es03.keystore
        fi
        [[ -f /usr/share/elasticsearch/config/elasticsearch.keystore ]] || (/usr/share/elasticsearch/bin/elasticsearch-keystore create)
        echo "Setting bootstrap.password..."
        (echo "$ELASTIC_PASSWORD" | /usr/share/elasticsearch/bin/elasticsearch-keystore add -x 'bootstrap.password')
        mv /usr/share/elasticsearch/config/elasticsearch.keystore /config/es03/es03.keystore

        
        echo "Move es03 certs to es03 config dir..."
        mv /config/ssl/docker-cluster/es03/* /config/es03/
    fi
fi