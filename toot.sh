#!/bin/bash
#
# stolen from https://git.lattuga.net/bida/MastodonMegafono/
#
# WTFPL!
#
#MASTODON_TOKEN=$MASTODON_TOKEN
#MASTODON_SERVER="mastodon.bida.im"

toot_help(){
    echo "toot [args..] your status update"
    echo "Arguments: "
    echo " -i=, --image=  select file image to post"
    echo " -a=, --alt=    the image description for disabilities"
    echo " -t=, --token=  your API access token"
    echo " -s=, --server= mastodon server"
    echo " -w,  --warn    the image is marked as sensitive"
    echo ""
    echo "Mastodon server can be set in ~/.tootrc otherwise it will be defaulted to $MASTODON_SERVER"
    echo "The token can be passed as, cli argument, var in ~/.tootrc, env var (in this priority order)"
}


if [ -f ~/.tootrc ]
then
    . ~/.tootrc
fi

toot_upload_image(){
    local image="$1"
    local description="$2"
    local desc_data="description=$description"
    local data="file=@$image"
    local id=$(curl --header "Authorization: Bearer $MASTODON_TOKEN" -sS -X POST https://$MASTODON_SERVER/api/v1/media -F "$desc_data" -F "$data" | jq -r .id)
    if [ $? -eq 0 ] && [ -n "$id" ]
    then
	   echo $id
	   return 0
    fi
    echo "Image upload: Something went wrong"
    exit 1
}

toot_post_with_image(){
    local status="$1"
    local image="$2"
    local sensitive="$3"
    local data="status=$status&media_ids[]=$image&sensitive=$sensitive"
    local error=$(curl --header "Authorization: Bearer $MASTODON_TOKEN" -sS -X POST https://$MASTODON_SERVER/api/v1/statuses -d "$data" | jq -r .error)
    if [ "$error" = "null" ]
    then
	   echo "[$(date)][INFO] Tooted: $status with image: $image, sensitive: $sensitive"
    else
	   echo $error
	   exit 1
    fi
}

toot_post(){
    local status="$1"
    local data="status=$status"
    local error=$(curl --header "Authorization: Bearer $MASTODON_TOKEN" -sS -X POST https://$MASTODON_SERVER/api/v1/statuses -d "$data" | jq -r .error)
    if [ "$error" = "null" ]
    then
       echo "[$(date)][INFO] Tooted: $status"
    else
       echo $error
       exit 1
    fi
}

image_to_toot=""
image_alt=""
sensitive="false"

if [ $# -eq 0 ]
then
    toot_help
    exit 1
fi

for arg in "$@"
do
    case $arg in
	-i=*|--image=*)
	    image_to_toot="${arg#*=}"
	    shift
	    ;;
	-t=*|--token=*)
	    MASTODON_TOKEN="${arg#*=}"
	    shift
	    ;;
	-s=*|--server=*)
	    MASTODON_SERVER="${arg#*=}"
	    shift
	    ;;
    -a=*|--alt=*)
        image_alt="${arg#*=}"
        shift
        ;;
    -w|--warn)
        sensitive="true"
        shift
        ;;
	*)
	    ;;
    esac
done

if [ $MASTODON_TOKEN = "" ]
then
    echo "no token set"
    exit 1
fi

if [ "$image_to_toot" != "" ] && [ -f $image_to_toot ]
then
    image_id=$(toot_upload_image "$image_to_toot" "$image_alt")
    toot_post_with_image "$*" "$image_id" "$sensitive"
else
    toot_post "$*" "$image_id" "$sensitive"
fi
