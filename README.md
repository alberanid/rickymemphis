# Ricky Memphis toot

Toot a random image of the greatest actor of all time.


Build:
```
docker build -t rickymemphis .
```

After you have unzipped the *rm.zip* file, you can run:

```
export MASTODON_TOKEN="..."
export MASTODON_SERVER="..."
docker run --rm -e MASTODON_TOKEN -e MASTODON_SERVER -v `pwd`/rm:/rm rickymemphis
```

# License

Apache 2.0

# Credits

"toot.sh" script from:

* https://git.lattuga.net/bida/MastodonMegafono
* https://git.lattuga.net/encrypt/toot
