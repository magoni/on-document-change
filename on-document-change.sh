#!/bin/bash
# Fire a webhook when some JSON at a URL changes
# Depends on 'jq' command to parse and query JSON

# exit when any command fails
set -e

if [[ $# -lt 7 ]] ; then
    echo 'Usage: ./on-document-change.sh <cache file path> <url to JSON document> <jq query> <webhook to notify> <notification title> <notification message> <notification url>'
    exit 1
fi

# configuration
cacheFile=$1
url=$2
query=$3
webhookURL=$4
notifTitle=$5
notifMsg=$6
notifUrl=$7
# end configuration

function notify() {
    requestBody="{\"value1\":\"$notifTitle\",\"value2\":\"$notifMsg\",\"value3\":\"$notifUrl\"}"
    echo "$(curl --silent -X POST -H "Content-Type: application/json" -d "$requestBody" $webhookURL)"
}

function compareAndNotify() {
    if [ "$result" != "$cachedResult" ]; then
        echo "New result, notifying..."
        notify
    else
        echo "No differences found"
    fi
}

result=$(curl "$url" --silent | jq "$query")

if [ -f "$cacheFile" ]; then
    read -r cachedResult<$cacheFile
    compareAndNotify
else
    echo "Creating cache file $cacheFile..."
fi

echo "$result" > $cacheFile
