#/bin/ash
confdir="${PWD}/config"
chown 1000 -R "$confdir"
find "$confdir" -type f -name "*.keystore" -exec chmod go-wrx {} \;
find "$confdir" -type f -name "*.yml" -exec chmod go-wrx {} \;

if [ -f "$confdir/elasticsearch/elasticsearch.keystore" ]; then
    printf "\nDelete elasticsearch keystore file\n"
    rm "$confdir/elasticsearch/elasticsearch.keystore"
fi
if [ -f "$confdir/es02/es02.keystore" ]; then
    printf "\nDelete es02 keystore file\n"
    rm "$confdir/es02/es02.keystore"
fi
if [ -f "$confdir/es03/es03.keystore" ]; then
    printf "\nDelete es03 keystore file\n"
    rm "$confdir/es03/es03.keystore"
fi

printf "\nYour 'elastic' user password is: $ELASTIC_PASSWORD\n"

PW=$(openssl rand -base64 16;)
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-$PW}"
export ELASTIC_PASSWORD
printf "\nYour 'elastic' user password is: $ELASTIC_PASSWORD\n"


# printf "es02!!\n"
# docker-compose -f es02.yml -f certificateSetup.yml up setup_es02
# printf "es03!!\n"
# docker-compose -f es03.yml -f certificateSetup.yml up setup_es03
printf "Elasticsearch　NOW!!\n"
docker-compose -f elkmultinodeFullEnvPassword.yml -f certificateSetup.yml up setup_elasticsearch
docker-compose -f elkmultinodeFullEnvPassword.yml -f certificateSetup.yml up  setup_es02 
docker-compose -f elkmultinodeFullEnvPassword.yml -f certificateSetup.yml up  setup_es03
printf "Kibana NOW!!\n"
# setup kibana and logstash (and system passwords)
docker-compose -f elkmultinodeFullEnvPassword.yml -f certificateSetup.yml up setup_kibana
printf "Logstash NOW!!\n"
docker-compose -f elkmultinodeFullEnvPassword.yml -f certificateSetup.yml up setup_logstash

printf "Setup completed successfully. To start the stack please run:\n\t docker-compose up -d\n"
printf "\nIf you wish to remove the setup containers please run:\n\tdocker-compose -f docker-compose.yml -f docker-compose.setup.yml down --remove-orphans\n"
printf "\nYou will have to re-start the stack after removing setup containers.\n"
printf "\nYour 'elastic' user password is: $ELASTIC_PASSWORD\n"
