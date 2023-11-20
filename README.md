# sfeed_mastodon

Mastodon-based front-end for the sfeed feed-reader. Mirror Atom/RSS feeds to Mastodon (& friends) simply and UNIX-ly.

![A screenshot of a post to a Pleroma server. It is a post made by sfeed_mastodon, and contains an article title (“Kajtoj ne nur gajigas la ĉielon”), a URL (https://uea.facila.org/artikoloj/legaĵoj/kajtoj-ne-nur-gajigas-la-ĉielon-r394/), and a quoted excerpt from the URL (“Kajtoj estas ŝat-okupo kaj sporto en okcidentaj landoj, kaj ili estas eĉ pli gravaj en Azio. Tie ili estas tradiciaj, tre popularaj, kaj povas esti tre belaj artaĵoj. Cetere ili delonge utilas al sporto, veter-scienco, fotado kaj militad[…]”).](res/screenshot.png)

sfeed_mastodon takes output from the lovely feed-aggregator [sfeed](https://codemadness.org/sfeed-simple-feed-parser.html) and posts it to the fediverse.



## Usage
```
$ FEDI_AUTH="yourAuthorizationTokenHere"
$ sfeed_update ~/.config/sfeedrc
$ cat ~/.config/sfeed/* | sfeed_mastodon https://yourServer.here
```

It’s that simple. It’s safe to run these commands several times in a row  — feed entries that have
already been posted won’t be reposted, if you use our example sfeedrc.

To automatically mirror an Atom/RSS feed, you can put these commands into a script and put it in your crontab.



## Installation
First, make sure to install [sfeed](https://codemadness.org/sfeed-simple-feed-parser.html).
If Guix is your package manager:
`$ guix install sfeed`

Now, put ./sfeed_mastodon into your $PATH, somewhere. Something like /usr/local/bin, or ~/.local/bin.
`$ cp sfeed_mastodon ~/.local/bin/`

You’ve done it!



## Configuration
### sfeed
We need to create a config file and feed directory for sfeed_update.
You can use the sfeedrc.example file in this repo as a base for your own config file.
```
$ mkdir ~/.config/sfeed/
$ cp sfeedrc.example ~/.config/sfeedrc
```

You need to edit the example sfeedrc to add in your own Atom/RSS feeds, or to change the feed path.
You can read up more on sfeed’s configuration in its man-page¸ sfeedrc(5).


### Mastodon
Now, we need to find our authorization token for use with `sfeed_mastodon`.

To find your authorization token, you can snoop through request headers in Firefox or Chromium by
navigating to `Developer Tools (F12) → Network → Headers`. Refresh your Mastodon page and examine a
request, looking for a header like so:

`Authorization: Bearer $FEDI_AUTH`

… where $FEDI_AUTH is your token. Copy it!

Whenever you use sfeed_mastodon, make sure that this token is stored in the environment variable
`$FEDI_AUTH`, or pass it with the `-a` parameter.


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
Author: ([@jadedctrl:jam.xwx.moe](https://jam.xwx.moe/users/jadedctrl))  
Source: https://notabug.org/jadedctrl/sfeed_mastodon  
License: GPLv3
