#!/usr/bin/env sh
NODE="$1"
MASTER=master

wget http://$MASTER:9000/jenkins/jnlpJars/agent.jar
java -jar agent.jar -jnlpUrl http://$MASTER:9000/jenkins/computer/$NODE/slave-agent.jnlp
