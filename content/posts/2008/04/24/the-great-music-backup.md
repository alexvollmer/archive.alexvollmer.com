----- 
permalink: the-great-music-backup
title: The Great Music Backup
date: 2008-04-24 03:58:41 -07:00
tags:
- geekery
excerpt: ""
original_post_id: 79
toc: true
-----
My to-do list is a mile-long and never ends. That thought can be quite depressing at times, but sometimes you finally get to tick something off of the list that has sat there so long that you can briefly enjoy a fleeting moment of smug self-satisfaction. I had just such a moment this week when my Great Big Music Backup to S3 finally completed.

Why S3? Well, something as important as backing up my music (which hasn't come from a CD in about three years) means I need multiple copies. I certainly plan on getting a local backup happening soon, but having one out "in the cloud" provides a little extra comfort if things go totally haywire. Of course none of this would be possible if S3 weren't so darn cheap. By my estimates my 50GB music collection will cost me about $6/mo to backup. That's pretty cheap peace of mind if you ask me.

I did the backup using excellent [S3Sync](http://s3sync.net/wiki) utility. Every S3 tool has its own way of mapping a filesystem to S3's bucket system. I thought about using JungleDisk in headless mode, but that turned out to be more complicated than I was willing to deal with. The nice thing about S3sync is that it maps files to your buckets in a way that is compatible with the [S3Fox](https://addons.mozilla.org/en-US/firefox/addon/3247) extension for Firefox. Most excellent.

Running over SSL with my crippled Comcast connection it took about a full week to push all of that data out to S3. Thank goodness for Gnu's [screen](http://www.gnu.org/software/screen/) utility which hosted the entire sync process. That's right kids, I did this all with a single invocation of s3sync.rb that ran for a solid week. Boo yah. Total upload cost was $3.58. Not too freakin' bad.

