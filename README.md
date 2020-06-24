# on-document-change

Notify a webhook when part of a JSON document at a given URL changes

Depends on `curl` to fetch the document at the given URL, [`jq`](https://stedolan.github.io/jq/) to execute JSON query

Example use case: Add this script to a cron job and [use an IFTTT webhook to send a push notification](https://medium.com/better-programming/how-to-send-push-notifications-to-your-phone-from-any-script-6b70e34748f6) when [a new post is added somewhere](https://www.reddit.com/r/redditdev/comments/cemmmh/using_reddit_apijson_to_query/eu3s7my)
