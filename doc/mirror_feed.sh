#!/bin/sh
#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Name: mirror_feed
# Desc: Mirror an RSS/Atom feed to the fediverse, piecemeal.
# Reqs: sfeed, sfeed_update, sfeed_mastodon
# Date: 2023-11-19
# Lisc: GPLv3
# Auth: @jadedctrl@jam.xwx.moe
#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

usage() {
	echo "usage: $(basename $0) [-h] DIRECTORY"
	echo "Updates an sfeed feed and posts new entries to the fediverse."
	echo ""
	echo "DIRECTORY must contain:"
	echo "  * The sfeed_update(1) config file, sfeedrc(5)."
	echo "  * 'sfeed/', a directory where posts are to be stored."
	echo ""
	echo "Optionally, DIRECTORY can contain 'sfeedenv', a script defining"
	echo "the variables \$FEDI_AUTH and \$FEDI_SERVER."
}


MIRROR_DIR="$1"

if test -z "$MIRROR_DIR" -o "$MIRROR_DIR" = "-h" -o "$MIRROR_DIR" = "--help"; then
	usage
	exit 2
fi


if test ! -d "$MIRROR_DIR"; then
	1>&2 echo "The given DIRECTORY '$MIRROR_DIR' doesn’t seem to be a directory at"
	1>&2 echo "all. Would you mind giving it another go?"
	1>&2 echo ""
	1>&2 usage
	exit 3
fi


if test -f "$MIRROR_DIR/sfeedenv"; then
	source "$MIRROR_DIR/sfeedenv" 2> /dev/null
fi
if test -z "$FEDI_AUTH" -o -z "$FEDI_SERVER"; then
	1>&2 echo "The environment variables \$FEDI_AUTH and \$FEDI_SERVER are undefined."
	1>&2 echo "Please set them before running $(basename "$0"), or define them in a"
	1>&2 echo "script at the path '$MIRROR_DIR/sfeedenv'."
	1>&2 echo ""
	1>&2 usage
	exit 4
fi


sfeed_update "$MIRROR_DIR/.sfeedrc"
cat "$MIRROR_DIR/sfeed/* | sfeed_mastodon "$FEDI_SERVER"
