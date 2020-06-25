#!/bin/bash
# Fire a webhook when input (stdin) changes, passes input to webhook as request body

# exit when any command fails
set -e

if [[ $# -lt 2 ]] ; then
    echo 'Usage: cat input | ./on-input-change.sh <cache file path> <webhook to notify>'
    exit 1
fi

# configuration
cacheFile=$1
webhookURL=$2
# end configuration

function notify() {
    echo "$(curl --silent -X POST -H "Content-Type: application/json" -d "$result" $webhookURL)"
}

function compareAndNotify() {
    if [ "$result" != "$cachedResult" ]; then
        echo "New result, notifying..."
        notify
    else
        echo "No differences found"
    fi
}

# read stin
result=$(cat)

if [ -f "$cacheFile" ]; then
    read -r cachedResult<$cacheFile
    compareAndNotify
else
    echo "Creating cache file $cacheFile..."
fi

echo "$result" > $cacheFile
