----- 
permalink: building-a-knowledge-base
title: Building a Knowledge Base
date: 2009-12-11 16:39:09 -08:00
tags:
- philosophy
- GTD
excerpt: ""
original_post_id: 416
toc: true
-----
Many years ago, I had the fortune of working for a family friend who was a financial planner. Not only did I get to learn a lot about personal finances at an early age, but I also picked up some great professional habits too. One of the things she did was maintain a gigantic set of folders of things she found interesting or useful. She had a four-drawer filing cabinet filled with various tidbits of information she had collected. She had a pretty good index in her head of where these things were and was amazingly proficient in recalling where she had filed things.

I always wanted a personal knowledge base like this, but I couldn't do it the way she had. First, I have never had the space to collect that much paper. I cannot have, and do not want, a giant filing cabinet of folders. Second, I don't have the kind of recall she did to find that stuff. I could certainly remember that I once filed something, but wouldn't have a clue _where_ I filed it. Which brings me to the third issue, which is suffering with the restriction of filing information under a single hierarchy.

When I first started using GMail I had a major epiphany about the differences between organizing information in folders versus tagging. These days that seems about as earth-shattering as realizing our galaxy is helio-centric, but it seemed like a pretty radical idea at the time. I flat-out love this style of organization. I may not remember _where_ I filed something, but I'm pretty consistent when it comes to labeling things. With systems like GMail and Delicious, I just slap as many tags as I think are reasonable for a message or bookmark and I have a really good chance of finding it again when I need to.

But email and bookmarks aren't a knowledge base. For me, they are a reference, but usually aren't in a succinct enough format to be a good reference. I want to boil down newly-acquired knowledge into some quick, efficient prose. What I needed was a system that:
*  Works across multiple machines (e.g. work and personal)
*  Is fast to add and edit content
*  Is (relatively) searchable
*  Has some structure
*  &hellip;but not so much that I fight with it


So over the last few years I've started building a personal knowledge-base in earnest. It's not overly complicated or too involved. I simply keep a set of text files (specifically, files compatible with [org-mode](http://orgmode.org/)) in a special [Dropbox](https://www.dropbox.com/) folder. Dropbox makes synchronizing stupid-easy. I just treat these files just like local files and they appear on both my work and personal machines.

For a while I used [VoodooPad](http://flyingmeat.com/voodoopad/), which is a very cool program. But I like having a _little_ structure in my notes and imparting that structure in VoodooPad took more effort than I wanted. Later, I discovered Emacs' org-mode, which turned out to be a perfect fit for me&mdash;it's a relatively lightweight structure on top of simple text-files. The only thing org-mode doesn't do well is handling non-text media. I've considered moving to something like OmniOutliner, but I've found that org-mode works surprisingly well.

The technology isn't particularly interesting, nor is it what makes this work for me. Rather, it's the _discipline_ of writing down little notes on various topics of interest. For example, I can never remember how to enable zombies for Cocoa debugging. I looked it up once, then added a section to my `xcode.org` file on `NSZombieEnabled`. I get two benefits out of this: first I've got it somewhere handy that I can easily look up again (via spotlight, `grep/ack`, whatever). Secondly, the very act of formulating a paragraph or two on the concept somehow reinforces it into my brain. In fact, it's very likely that I won't ever have to look up how to track zombies again.

