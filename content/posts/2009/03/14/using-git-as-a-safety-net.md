----- 
permalink: using-git-as-a-safety-net
title: Using Git as a Safety Net
date: 2009-03-14 18:11:32 -07:00
tags:
- git
excerpt: ""
original_post_id: 313
toc: true
-----
I spent the last week on a top-secret iPhone application at work. It has been a blast, in part, because it's been so fun to learn so much new information so quickly. That has meant trying out lots of ideas and, more often than not, rolling them back and trying again. The problem is that doing this kind of experimentation can be an absolute productivity-killer in terms of managing your changes&mdash;unless you have a good tool to manage large chunks of changes, you can spend a lot of time trying to do it manually (and probably screwing it up in the process).

While doing Java development, I've often used Eclipse's file history feature to roll things back. The downside is that it's file-by-file and not easy to tag the current state of your entire project in one go. It appears that Xcode has this feature, but since I'm using Git for my SCM, I figured why not use that instead? 

So my new flow has been to stage changes to the index whenever I make _any_ progress and the app is still in a working state. This is different from a commit, which I still like to think of as a succinct, whole change around a particular feature. The incremental staging is more like dribbling micro-changes to the next stage prior to committing. It can take several attempts to get to a real, first-class commit.

I like using [magit](http://zagadka.vm.bytemark.co.uk/magit/), so I keep Emacs running in the background. When I get to a good checkpoint, I stage hunks or entire files to the index. When I get enough to make a full commit, I commit them. If you're running git exclusively on the command-line, this would be the equivalent of using `git add -i`.

When I first started using Git, I couldn't see the value in Git's stage-commit-push workflow. Now I get it. Like most Git tricks, this one is probably obvious to a lot of folks, but for me it's been a real life-saver on this project. I've been able to be much more cavalier with experimentation because I can easily revert changes with a single keystroke. Nifty!
