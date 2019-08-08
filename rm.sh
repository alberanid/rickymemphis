#!/bin/sh

if [ "$MASTODON_TOKEN" = "" ] ; then
	echo "missing MASTODON_TOKEN env"
	exit 1
fi
if [ "$MASTODON_SERVER" = "" ] ; then
	echo "missing MASTODON_SERVER env"
	exit 2
fi

rmimg="$(ls -1 /rm/* | sort -R | head -1)"
if [ "$rmimg" = "" ] ; then
	echo "missing Memphis"
	exit 3
fi

sh /toot.sh --image="$rmimg" --alt="un fantastico Ricky Memphis" '#rickymemphis'
