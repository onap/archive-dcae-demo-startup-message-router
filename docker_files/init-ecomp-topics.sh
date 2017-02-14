#!/bin/bash

# lji: this is the script to run to initialize a MR from its 0 day state to eCOMP topics loaded

HOSTPORT="127.0.0.1:3904"
ANON_TOPICS="APPC-CL PDPD-CONFIGURATION POLICY-CL-MGT DCAE-CL-EVENT"
API_TOPICS_SDC="SDC-DISTR-NOTIF-TOPIC-SDC-OPENSOURCE-ENV1 SDC-DISTR-STATUS-TOPIC-SDC-OPENSOURCE-ENV1"
API_KEYFILE="./uebapikey-sdc"

echo "blah" > /tmp/sample.txt

# list topics
curl http://${HOSTPORT}/topics

declare -A TOPICS

echo "adding anonymous topics"
for ANON_TOPIC in $ANON_TOPICS ; do
  echo "curl  -H "Content-Type:text/plain" -X POST -d @/tmp/sample.txt http://${HOSTPORT}/events/${ANON_TOPIC}"
  curl  -H "Content-Type:text/plain" -X POST -d @/tmp/sample.txt http://${HOSTPORT}/events/${ANON_TOPIC}
  echo "done creating anonymous topic $ANON_TOPIC"
  echo
done

echo "generating API key"
echo '{"email":"no email","description":"API key for SDC"}' > /tmp/input.txt
curl -s -o ${API_KEYFILE} -H "Content-Type:application/json" -X POST -d @/tmp/input.txt http://${HOSTPORT}/apiKeys/create 
cat ${API_KEYFILE}
echo

echo "adding API key topics"
UEBAPIKEYSECRET=`cat ${API_KEYFILE} |jq -r ".secret"`
UEBAPIKEYKEY=`cat ${API_KEYFILE} |jq -r ".key"`
for API_TOPIC in $API_TOPICS_SDC; do
  echo '{"topicName":"'${API_TOPIC}'","topicDescription":"SDC API Key secure topic for ","partitionCount":"1","replicationCount":"1","transactionEnabled":"true"}' > /tmp/topicname.txt
  time=`date --iso-8601=seconds`
  signature=$(echo -n "$time" | openssl sha1 -hmac $UEBAPIKEYSECRET -binary | openssl base64)
  xAuth=$UEBAPIKEYKEY:$signature
  xDate="$time"
  echo "curl -i -H "Content-Type: application/json"  -H "X-CambriaAuth:$xAuth"  -H "X-CambriaDate:$xDate" -X POST -d @/tmp/topicname.txt http://${HOSTPORT}/topics/create"
  curl -i -H "Content-Type: application/json"  -H "X-CambriaAuth:$xAuth"  -H "X-CambriaDate:$xDate" -X POST -d @/tmp/topicname.txt http://${HOSTPORT}/topics/create
  echo "done creating api key topic $API_TOPIC"
  echo
done


echo 
echo "============ post loading state of topics ================="
for TOPIC in "$API_TOPICS_SDC $ANON_TOPIC"; do
  curl http://${HOSTPORT}/topics/${TOPIC}
done 
