#!/usr/bin/env sh
set -e
ID="$1"
MASTER=master

apt update
apt install -y wget dnsutils

IP=$(hostname -i)

# get the service name you specified in the docker-compose.yml
# by a reverse DNS lookup on the IP
SERVICE=$(dig -x $IP +short | cut -d'_' -f2)

# the number of replicas is equal to the A records
# associated with the service name
# NOT WORKING
COUNT=$(dig $SERVICE +short | wc -l)

# extract the replica number from the same PTR entry
INDEX=$(dig -x $IP +short | cut -f2 -d.)


NODE="${ID}_$INDEX"

wget http://$MASTER:9000/jenkins/jnlpJars/agent.jar
java -jar agent.jar -jnlpUrl "http://$MASTER:9000/jenkins/computer/$NODE/slave-agent.jnlp"

