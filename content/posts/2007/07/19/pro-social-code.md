----- 
kind: article
permalink: pro-social-code
created_at: 2007-07-19 03:48:29 -07:00
title: Pro-Social Code
excerpt: ""
original_post_id: 29
tags: 
- software
- philosophy
toc: true
-----
There is a growing trend of geeks getting hip to the principles of usability and user experience design. The idea is that when developers start taking a more user-centric approach to their development, their design of their applications will be influenced more by the user's needs and less by the internal mechanisms or frameworks upon which it is built. As a kind of agile, post-modern, less-is-more kinda guy I think this is a wonderful approach.

<img src="http://farm1.static.flickr.com/5/9798019_bc86ac5653_m.jpg" alt="Iceburg (courtesy of ae2005 via flickr.com)" class="right"/>

However I think this user-centric approach can be taken far beyond point-and-click interfaces. I've noticed that when developing a so-called "back-end" feature, an awful lot of developers tend to work inside-out. The approach often starts with _how_ something will be done and, based on that process/function/algorithm, the rest of the design accretes until enough connective tissue is in place to connect the feature to the rest of the application. One danger in this thinking is that the implementation can drive the design in such a way that precludes other implementations. But an even more insidious problem is that the inside-out approach can leave the end-user with a pretty lousy interface. I'll borrow Joel Spolsky's [Iceberg Analogy](http://www.joelonsoftware.com/articles/fog0000000356.html The Iceberg Secret, Revealed - Joel on Software) here and say that your clever little algorithm is far below the water-line. Please&hellip;I beg of you&hellip;please spend some time on your interface.

The inside-out approach often manifests itself as a lack of refinement on the visible edges of a feature. For software with an obvious visual interface this is relatively cut and dried. However for other features this is less clear, but just as important. Let's take the simple example of a command-line utility that does some internal housekeeping. An inside-out approach typically yields a core bit of code that has just enough command-line option parsing to connect a terminal to the core bit. But having a few command-line switches for configurability isn't enough. Here are few things to consider to make that visible 10% of your feature rock:
*  Implement a standard "help" option like `--help` and provide terse but descriptive prose. The output should be able to answer "what does this thing do?"
*  Useful documentation of command-line parameters. What is this parameter for? Is it required? Is their a default value?
*  Provide sensible defaults. If the typical use-case is run against developers own machines, _even if it's run differently in production_, for Pete's-sake make localhost the default. Don't make the thing you do the most often, the most painful.
*  Provide a "pretend" or "dry-run" mode. Show what _would_ happen without committing the user to the final consequences.
*  Handle termination gracefully. Don't just let your app barf all over itself when someone kills it with CTRL+C
*  Provide _useful_ output for long-running jobs. Consider the interplay between this suggestion and the previous one.

Even though your "customers" are perhaps internal team-members, that's no reason to short-change them with some lousy tool that only works under the narrowest of circumstances. This is just plain rude to the rest of your team. Do you pee in their coffee cups in the morning? No? Then don't stick them with bad tools. So then let me enumerate a few things that will guarantee you a fast-track onto my rake-whacking-list:
*  Failures without explanation or entrails left behind to debug.
*  Cryptic messages (success or failure).
*  Not playing nicely with standard input and output streams so that your utility can work nicely in a shell.
*  Printing a bunch of debug output that I can't turn off.
*  Lack of sensible defaults. Please don't make me type the same option over..and over&hellip;and over&hellip;

Since this horse ain't quite dead yet, let me flog it just a wee bit more. If you're with me this far, then perhaps you've bought off on the idea that the 10% of your non-visual apps deserves first-class treatment. Hold on&hellip;I've got one more for you. In addition to spending the time to polish the user-visible features you also need to _test_ them. I don't mean the regular WOMB (works on my box) manual testing. I mean automated, unit-tested features. Yes&hellip;even for things like command-line parsing. If you want to call yourself a craftsperson, don't slack on this. Do it right. If you think unit-testing takes too long then you need to get better at it, not ignore it altogether. In my book you can't possibly be so brilliant that you can design beautiful algorithms or object models but can't test-drive something as simple as configuration parameters. Sorry&hellip;you just can't.
