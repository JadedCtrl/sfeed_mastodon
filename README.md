# sfeed_mastodon

Mirror Atom/RSS feeds to Mastodon (& friends) simply and UNIX-ly.

sfeed_mastodon takes output from the lovely feed-aggregator [sfeed](https://codemadness.org/sfeed-simple-feed-parser.html) and posts it to the fediverse.



## Installation
First, make sure to install [sfeed](https://codemadness.org/sfeed-simple-feed-parser.html).
If Guix is your package manager:
`$ guix install sfeed`

Now, put ./sfeed_mastodon into your $PATH, somewhere. Something like /usr/local/bin, or ~/.local/bin.
`$ cp sfeed_mastodon ~/.local/bin/`

You’ve done it!



## Configuration
### sfeed
We need to create a config file and feed directory for sfeed — they can be anywhere, your choice.
```
$ mkdir ~/.config/sfeed/
$ cat > ~/.config/sfeed/config <<EOF
sfeedpath="$HOME/.config/sfeed/"

feeds() {
	feed "Planet GNU" "https://planet.gnu.org/rss20.xml" "https://planet.gnu.org" "UTF-8"
	feed "Tiriftjo" "https://tirifto.xwx.moe/en/news.atom" "https://tirifto.xwx.moe" "UTF-8"
}
EOF
```

You can read up more on sfeed’s configuration in its documentation¸ sfeedrc(5).


### Mastodon
Now, we need to find our authorization token for use with `sfeed_mastodon`.

To find your authorization token, you can snoop through request headers in Firefox or Chromium by
navigating to `Developer Tools (F12) → Network → Headers`. Refresh your Mastodon page and examine a
request, looking for a header like so:

`Authorization: Bearer $FEDI_AUTH`

… where $FEDI_AUTH is your token. Copy it!

Whenever you use sfeed_mastodon, make sure that this token is stored in the environment variable
`$FEDI_AUTH`, or pass it with the `-a` parameter.



## Usage
```
$ FEDI_AUTH="yourAuthorizationTokenHere"
$ sfeed_update ~/.config/sfeed/config | sfeed_mastodon https://yourServer.here
```

It’s that simple. It’s safe to run this command several times in a row  — feed entries that have
already been posted won’t be reposted. You can even add this to your crontab to mirror an Atom/RSS
feed automatically.


### Templates
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
Author: ([@jadedctrl:jam.xwx.moe](https://jam.xwx.moe/users/jadedctrl))  
Source: https://notabug.org/jadedctrl/sfeed_mastodon  
License: GPLv3
