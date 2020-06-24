#!/bin/bash
# Fire a webhook when some JSON at a URL changes
# Depends on 'jq' command to parse and query JSON

# exit when any command fails
set -e

if [[ $# -lt 4 ]] ; then
    echo 'Usage: ./on-document-change.sh <cache file path> <url to JSON document> <jq query> <webhook to notify>'
    exit 1
fi

# configuration
cacheFile=$1
url=$2
query=$3
webhookURL=$4
# end configuration

function notify() {
    echo "$(curl --silent -X POST -H "Content-Type: application/json" -d '{"value1":"notif title","value2":"notif message","value3":"link url"}' $webhookURL)"
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
