# sfeed_mastodon

Mirror Atom/RSS feeds to Mastodon (& friends) simply and UNIX-ly.  
Mastodon-based front-end for the sfeed feed-reader.

![A screenshot of a post to a Pleroma server. It is a post made by sfeed_mastodon, and contains an article title (“Kajtoj ne nur gajigas la ĉielon”), a URL (https://uea.facila.org/artikoloj/legaĵoj/kajtoj-ne-nur-gajigas-la-ĉielon-r394/), and a quoted excerpt from the URL (“Kajtoj estas ŝat-okupo kaj sporto en okcidentaj landoj, kaj ili estas eĉ pli gravaj en Azio. Tie ili estas tradiciaj, tre popularaj, kaj povas esti tre belaj artaĵoj. Cetere ili delonge utilas al sporto, veter-scienco, fotado kaj militad[…]”).](res/screenshot.png)



## Usage
sfeed_mastodon takes output from the lovely feed-aggregator
[sfeed](https://codemadness.org/sfeed-simple-feed-parser.html) and posts it to the fediverse.  
It could be considered a front-end for sfeed.

You can use it to post an entire RSS feed like so:
```
$ FEDI_AUTH="yourAuthTokenHere"
$ sfeed https://planet.gnu.org/rss20.xml | sfeed_mastodon https://yourServer.here
```

If you want to regularly update and mirror a feed — making it act like a normal RSS-repost bot — you
can run it like so (after some [configuration](#sfeed)):
```
$ FEDI_AUTH="yourAuthorizationTokenHere"
$ sfeed_update ~/.config/sfeedrc
$ cat ~/.config/sfeed/* | sfeed_mastodon https://yourServer.here
```

It’s that simple. It’s safe to run these commands several times in a row  — feed entries that have
already been posted won’t be reposted, if you use our `docs/sfeedrc.example` as your `sfeedrc`.

For proper automation, you can simply put these commands in a shell script and run it regularly.
Such a script has been provided, and is [described below](#mirror_feed) — `mirror_feed.sh`.


## Installation
First, make sure to install [sfeed](https://codemadness.org/sfeed-simple-feed-parser.html).

If Guix is your package manager:
```
$ guix install sfeed
```

Now, put ./sfeed_mastodon into your $PATH, somewhere. Assuming `~/.local/bin/`…
```
$ cp sfeed_mastodon ~/.local/bin/
```

You’ve done it!



## Configuration
### sfeed
If you want to regularly update an RSS/Atom feed and post only new entries, we need to do some
configuration for `sfeed_update`. For this, we’ve gotta create a config file and feed directory.
You should use the `docs/sfeedrc.example file` in this repo as a base for your own config file.
```
$ mkdir ~/.config/sfeed/
$ cp docs/sfeedrc.example ~/.config/sfeedrc
```

You need to edit the example sfeedrc to add in your own Atom/RSS feeds, or to change the feed path.
You can read up more on sfeed’s configuration in its man-page¸ sfeedrc(5).

Warning: If you *don’t* use the provided `sfeedrc.example` as a base for your configuration, you
will probably end up reposting old entries — our `sfeedrc.example` only keeps the newest ones in
the file to avoid this. So please, use `sfeedrc.example`.


### Mastodon
Now, we need to find our authorization token for use with `sfeed_mastodon`.

To find your authorization token, you can snoop through request headers in Firefox or Chromium by
navigating to `Developer Tools (F12) → Network → Headers`. Refresh your Mastodon page and examine a
request, looking for a header like so:

`Authorization: Bearer $FEDI_AUTH`

… where $FEDI_AUTH is your token. Copy it!

Whenever you use sfeed_mastodon, make sure that this token is stored in the environment variable
`$FEDI_AUTH`, or pass it with the `-a` parameter.


### mirror_feed
To automatically mirror an Atom/RSS feed, you can make a script that runs `sfeed_update` &
`sfeed_mastodon`, and then put it in your crontab. `docs/mirror_feed.sh` is a script which does exactly this.

To use `mirror_feed.sh` with the `~/.config/sfeedrc` from our [prior configuration](#sfeed):
```
$ mirror_feed.sh ~/.config/
```

`mirror_feed.sh` has an additional config file: `sfeedenv`. It is a simple shell script that
exports two variables: `$FEDI_SERVER` and `$FEDI_AUTH`. It will be sourced by `mirror_feed.sh`,
though you can optionally set these variables in the environment instead.

Barring that, `mirror_feed.sh` expects a directory containing `sfeedrc` and a subdirectory `sfeed/`
for posts — just like the configuration in `~/.config` [discussed earlier](#sfeed).


### Formatting
You might want to know about the template parameter (`-t`) — this lets you tweak the output for
sfeed_mastodon as you wish. With this, you can add specific hash-tags to your posts, for example.
Its argument should be HTML with some variables within {{double-cramps}} for post data. 

Here is an example, the default value:
```
<b>{{title}}</b><br>
{{url}}<br>
<br>
<blockquote>{{desc_short}}</blockquote>
```

Short and sweet, right?

Here are the variables you can use:
* `title`
* `url`
* `desc`
* `desc_short`



## Misc.
Author: [@jadedctrl:jam.xwx.moe](https://jam.xwx.moe/users/jadedctrl)  
Source: https://hak.xwx.moe/jadedctrl/sfeed_mastodon  
License: GPLv3
