----- 
permalink: s3-sync-update
title: S3 Sync Update
date: 2008-04-05 15:49:18 -07:00
tags: ""
excerpt: ""
original_post_id: 77
toc: true
-----
A while back [I wrote about my strategy for synchronizing between two machines](http://blog.livollmers.net/index.php/2008/01/21/poor-mans-mac/) using Amazon's S3 and the JungleDisk tool. I just wanted to post a quick update that refines that strategy a bit. First, let me describe what needed improvement. I sync the `~/Documents` directory between my home and work MacBooks. However, on my home machine I have some extra files that really don't belong on my work machine (like Quicken files), so I have a small text file (called `sync_files`) that enumerates which sub-directories and file in ~/Documents are to be synchronized between the two machines.This all worked pretty well until I noticed duplicates of files appearing in different places. I realized that what had happened was that I had moved the files on one of the disks and then sync'd with S3. With my current scripts this resulted in copying the file to the new location, but not removing the old one.So with a quick glance at the `rsync` man-page, I found the `--delete` option. I refined my scripts and ran them. It all looked good--until I got home. Oops, I just lost a whole bunch of files. Uh-oh. It turns out I forgot to use the `sync_files` file for both directions. This was an easy tweak but reminded me of the Golden Rule of Rsync:

<blockquote>
  

  Always run `rsync` with `--verbose` and `--dry-run` to make sure it's doing what you think it's doing

</blockquote>So I decided it was time to re-write the script to support this. While you can do command-line options with bash, it quickly gets kinda oogy, so I fell back on Ruby instead. I've also collapsed the synchronizing down into a single script--one that goes both ways. So without further ado, you can download the script [here](/wp-content/uploads/2008/04/sync_s3). This should work with a stock Ruby install, no special gems required.

*Update 4/8/2008:* Okay, I still don't know what the hell I'm doing. There is a bug with this script in that if you create a new file locally then try to sync from S3, your new file will get obliterated. Well guess what kids? Synchronization is hard. I've been noodling on a variety of hacks to get around this but none are terribly satisfying. Anyway, my Golden Rule (see above) still stands: make sure you test the thing out before you run it "live".
