----- 
kind: article
permalink: poor-mans-mac
created_at: 2008-01-21 20:47:32 -08:00
title: Poor Man's .mac
excerpt: ""
original_post_id: 41
tags: 
- mac
- apple
toc: true
-----
The discontent with Apple's .mac service seems to be [growing](http://www.43folders.com/2008/01/18/mac-future-sleeping-giant .Mac: Future of a sleeping giant? | 43 Folders) and [growing](http://www.43folders.com/2006/09/28/dot-mac-lameness LifeClever: Dot Mac needs more than a paint job | 43 Folders). I've looked at .mac a couple of times but couldn't really find a good reason to get on board. Oh sure it has some nice features like syncing contacts, but honestly most of the features .mac offers I don't or can get in other ways. In short it's hard to imagine ponying up $99 for this service when it can be beaten with other tools.

Let's start by looking at what features .mac offers. According to the [.mac website](http://www.apple.com/dotmac/ Apple - .Mac) the features are:

*  Web Gallery
*  Website Hosting
*  IMAP Mail
*  Back To My Mac
*  Sync
*  iDisk
*  Groups
*  10GB Storage

OK, the first two I can handle easily with my little Linux box. IMAP isn't a compelling feature as I've had a GMail address since its inception and really don't need another email to watch. Back To My Mac is kind of interesting, but honestly I really haven't had a need to do this.

Now the Sync feature is very interesting. Right now my contacts sync (some of the time) between my work and home machines via my iPhone plugging into iTunes. I didn't intend for this to be a solution to syncing calendars and contacts so I'm not too bummed when it does odd things. Regardless, .mac wouldn't help me with calendars where the ultimate source of authority for my schedule is Google's Calendar system. More on this in a bit&hellip;

Groups. Uh, unless I don't get this correctly, isn't this what Yahoo! and Google offer _for free_? No thanks Apple, not interested.

iDisk is completely uninteresting to me. I use Amazon's S3 along with the brilliant [JungleDisk tool](http://jungledisk.com/ JungleDisk - Reliable online storage powered by Amazon S3 ™ - Jungle Disk) and, even with a license for JungleDisk, is seriously cheaper (and much bigger) than .mac's storage options. 10MB is a paltry amount. So let's start with how I solved this problem&hellip;

## File Storage

So since I only need a fraction of .mac's features, I've found cheaper ways to get the same functionality. The first is scoring a JungleDisk license ($20). When you fire it up it simply creates a file-like volume on the desktop (and in `/Volumes`) that adheres to regular file-system semantics. Acting like a real file-system means I can use the `rsync` utility (which is you can installed via [MacPorts](http://www.macports.org/ The MacPorts Project -- Home)) to easily update either my local machine or my S3 account.

I have two scripts to sync files: one to sync from my machine to S3 and one to sync the other way. Both my work and home machines have these scripts on them. So a common usage scenario is using my work machine all day then executing the `sync_to_s3` script before I go home. When I get home I can simply run `sync_from_s3` and get the latest changes on to my home machine. If I make changes to those files on my home machine, I can run `sync_to_s3` once more at home and the next morning run `sync_from_s3` on my work machine.

Currently the only files I sync through S3 are all in my `~/Documents` directory, though it would be easy to sync other files. However the `~/Documents` directories on my two machines have some differences between them. For example my Quicken data is on my home machine which is something I don't need to sync back and forth between my two machines. So to lock down exactly which files I want sync, I create a little file named `sync_files` that enumerates which files I want to sync. Additionally the `sync_files` is also synchronized so that I only have to update it one place.

So here are the scripts. The first is `sync_to_s3`:

<% highlight :sh do %>
#!/bin/sh
rsync --recursive --size-only \
  --files-from ~/Documents/sync_files \
  ~/Documents/ /Volumes/JungleDisk/documents/
<% end %>

The `sync_files` file is simply a list of matching files and directories to sync. Mine looks like this:

<% highlight :sh do %>
books
cheatsheets
markdown
OmniFocus.ofocus
presentations
resume
screencasts
specifications
whitepapers
work
sync_files
<% end %>

Next is the `sync_from_s3` which goes the other way.

<% highlight :sh do %>
#!/bin/sh
rsync  --recursive --size-only \
  /Volumes/JungleDisk/documents/ ~/Documents/
<% end %>

Note that in the second script I don't refer to the `sync_files` file. That's because the only way files end up on S3 is via the `sync_to_s3` script which already limits what files get uploaded. I could use the `sync_files` file to sync _from_ S3, but if the `sync_files` were updated on S3 I wouldn't get the changes until my second sync.

One thing to be aware of is a new feature in JungleDisk that, if enabled, will wreak havoc on this setup. Under the 'Jungle Disk Plus' settings, be sure to disable the checkbox marked 'Only upload changed portions of large files'. This absolutely wrecked the sync-ing process for my [OmniFocus](http://www.omnigroup.com/applications/omnifocus/ The Omni Group - OmniFocus) document. Given how cheap S3 is, this is an utter non-concern for me.

## Calendars

Since I'm unwilling to give up my Google Calendar setup and there is no built-in support for sync-ing with them, I needed some kind of tool that can play in both worlds. Fortunately the [Spanning Sync](http://spanningsync.com/ Spanning Sync - Sync iCal and Google Calendar) tool does exactly this. It's not exactly cheap at $60, but does a good job and, up until recently, it was the only game in town. Another tool has emerged in this space called [BusySync](http://blog.busymac.com/blog/2008/01/busymac-announc.html BusyBlog: BusyMac announces BusySync 2.0: Sync iCal with Google Calendar) which claims to do the same thing. Since I have a Spanning Sync license, I haven't tried this tool out. But it's about half the cost of Spanning Sync and probably worth a look.

