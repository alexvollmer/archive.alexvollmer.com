----- 
kind: article
permalink: just-having-fun
created_at: 2008-12-16 06:04:28 -08:00
title: Just Having Fun
excerpt: ""
original_post_id: 190
tags: 
- ruby
- philosophy
toc: true
-----
After spending nearly all of my spare hours on [moochbot](http://moochbot.com moochbot — track what you lend and borrow), it was fun to take a lighter turn this week. Today I put up [http://isthatfreedomrock.com](http://isthatfreedomrock.com Freedom Rock!!). If you are lucky enough to have watched cable in the late 80's you might remember a TV ad in which two hippies sit in front of a VW bus doing their best Cheech &amp; Chong routine. One hippy says to another, "is that freedom rock? Then turn it up!" I don't know why, but that has _always_ been funny to me. It's just so&#8230;stupid. Can you imagine the ad execs sitting around the table thinking this one up?

Anyway, one day it occurred to me that it would be funny (to me at least) to have a very simple, [single-serving site](http://kottke.org/08/02/single-serving-sites) that told you whether a certain song or artist was, in fact, Freedom Rock. Note the capital letters. I'm not talking Toby Keith "freedom rock" with waving flags in the background and lots of shiny pickup trucks. I'm talking about the rather odd, rag-tag collection of songs that made it to this album. Try playing with the site a bit, then check out the [Urban Dictionary's entry on Freedom Rock](http://www.urbandictionary.com/define.php?term=Freedom+Rock Freedom Rock).

This leads to one of the pillars of my personal philosophy:

> Amuse yourself first, worry about your audience later.

I wrote this primarily because it make me laugh&#8230;a lot. I don't know why. It's dumb, it's juvenile and it's _totally_ worth the $10 I paid to register the domain-name.

But stupid-hippy jokes don't make up the whole picture. The other half of this fun little excursion was figuring out how to do this with as little code as possible. At first I wrote this as a flat [Merb](http://merbivore.com/ Merb) application. Unfortunately I wanted to host this on Dreamhost and they are still on Ancient Ruby (read, 1.8.5) and the newest Merb wants 1.8.6. That was a deal-breaker. So then I took a look at [Sinatra](http://sinatra.rubyforge.org/ Sinatra!), and just like the bobby-soxers of the 40's I fell in love. Sigh&#8230;

If you haven't had a chance to look at Sinatra, you should do yourself a favor and check it out. They call it a DSL for the web, _not_ a framework. It has the nice terse syntax of [Camping](http://camping.rubyforge.org/files/README.html Camping), but has source that gives me half a chance to comprehend. It's short and sweet and gives enough things that will make sense to Rails-veteran, but with little extra cruft. The source is up on [GitHub](http://github.com/alexvollmer/freedomrock/tree/master GitHub repo) (with a shocking number of commits for such a simple project).

