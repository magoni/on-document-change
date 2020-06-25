# on-input-change

Notify a webhook when input (stdin) changes

Depends on `curl` to execute webhook

Example use case: Add this script to a cron job and [use an IFTTT webhook to send a push notification](https://medium.com/better-programming/how-to-send-push-notifications-to-your-phone-from-any-script-6b70e34748f6) when [a new post is added somewhere](https://www.reddit.com/r/redditdev/comments/cemmmh/using_reddit_apijson_to_query/eu3s7my), using [jq](https://stedolan.github.io/jq/) as input
```
curl --silent 'https://www.reddit.com/r/videos/search.json?q=doge&restrict_sr=1&sort=new' \
    -H 'User-Agent: Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)' \
    | jq -c '.data.children[0].data \
        | {value1:"New doge video", value2: "Tap here to check it out: \(.title)", value3: .url}' \
    | ./on-input-change.sh 'doge-search.txt' 'https://maker.ifttt.com/trigger/document_changed/with/key/<your key here>'

```
