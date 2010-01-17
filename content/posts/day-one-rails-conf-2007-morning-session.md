----- 
permalink: day-one-rails-conf-2007-morning-session
title: Day One, Rails Conf 2007 -- Morning Session
excerpt: ""
date: 2007-05-17 20:22:16 -07:00
tags: ""
toc: true
-----
Update: 2007-05-19 -- Jason posted a PDF of his presentation [here](http://media.joyent.com/JHoffmanRailsConf-May2007.pdf).

Jason Hoffman, CTO of Joyent, gave a (mostly) fascinating session on scalability of Ruby on Rails. Here's the news-flash: Rails is only a tiny part of a large scale deployment. He started off the talk with a couple of points I really take to heart: large-scale apps are not achieved in their first iteration. They are realized in the fifteenth to twentieth iterations. Put another way, he said that "...the road to a top site on the internet is not from one iteration". A premature decision to mold the architecture without a real pain point _and_ test data to back it up is as likely (if not more likely) to send you down the path to hell that solve any real problem.

One of the first eye-openers in Jason's talk was the consideration of power consumption. I'll admit that this is a topic that I never considered, but according to the presenter it can fundamentally shape your physical deployment. In essence the intersection of cost and legal limits to power consumption in a physical space can limit what you can put in a rack more than anything else. In some cases co-location facilities may actually waste space because they simply can't power any more machines than are occupying a fraction of their total space! In short, the goal is to cram as much computational power into as small a space using as little power as possible.

The middle section of the talk left my mind wandering as Jason rattled off performance metrics around the Solaris servers that they used. I got the sense that my mind wasn't the only one wandering at this point.

After the break, the talk hit high-gear and finished with a bang. Jason began to get into the nitty-gritty deployment strategies that they used at Joyent. Now we were all sitting up straight in our chairs and paying attention.

First, they do a _lot_ of Big IP work. Lots of layer 7 (application) routing rules to partition the work in all sorts of interesting ways--even load-balancing to mongrel that handle a _single controller_. Instead of putting mongrel instances behind Apache (which Jason claims maxes out to about 150 reqs/second with Apache and mod_proxy), they load-balance _thousands_ of mongrel instances directly behind Big IP.

They don't use plain old vanilla mongrel either. Instead they are using the new [event-driven, non-threaded mongrel](http://brainspl.at/articles/2007/05/12/event-driven-mongrel-and-swiftiply-proxy a fancy new mongrel). In addition, they are running this inside of four virtual machines on a single box. A typical hardware configuration is a 16 GB RAM machine with 4 AMD CPUs. They run four virtual machines with ten mongrel instances each for a total of forty mongrel instances on a single box.

Why virtualization? According to Jason, as you consolidate computing power into a single box, you may miss the "sweet spot" of smaller hardware that most software has been written for. You can recapture that with virtualization. It's a fascinating idea that I hadn't really considered. Of course you wouldn't dare do any of this without some real testing and numbers to back it up.

Speaking of testing, Jason had an interesting approach. Start with a single mongrel instance and test it with some benchmarking tool like [httperf](http://www.hpl.hp.com/research/linux/httperf/ httperf -- the benchmarking tool). Find out what a _single_ mongrel instance can do in terms of requests per second. Get an idea of how much CPU and memory that single instance uses. Now multiply it by some number such that the total resources consumed by your mongrel instances won't exceed your hardware. Now fire up that number of mongrel instances and benchmark each instance _separately but simultaneously_ and monitor what your hardware is doing.

You want to see that adding another mongrel instance provides a proportional level of capacity. Once you've hit the limits of that piece of hardware you know what a single box should do. As Jason stated several times during the session, you want things to "add up". That is, adding another 50 mongrel instances to the overall deployment should provide a commensurate level of capacity. 

Now that you know what a single node can do, you should be able to put any number of them behind a front-end load balancer and get a total throughput equal to the capacity of a single node times the number of nodes. If you are getting _significantly less_ total throughput than you would expect, you probably need to revisit or refine your front-end load-balancing solution.

This ties into another interesting point made during the presentation. Rails is just a small part of the overall application. Questions about whether the Rails stack will scale are somewhat silly since the Rails stack comprises only a small part of an overall application deployment.

Of course, some of those other parts are things like persistent storage. He brought up several examples of how Joyent has moved some responsibilities off of the shoulders of the RDBMS and pushed them to other technologies including LDAP, Memcache, message buses and even the file system. I'm firmly convinced that it's pretty easy to max out the capabilities of RDBMS systems. They have a very hard job to do and adding lots of complicated clustering and scaling only make that job harder. Using a heterogeneous approach where certain kinds of data are stored via different kinds of mechanisms struck me as a very pragmatic approach.

One final note was about DNS partitioning. If caching provides a way to avoid expensive operations over and over again, partitioning is way to spread operations across your hardware. Jason was a big fan of using DNS and Big IP routing to spread load across hardware.

After a morning spent hopped up on cold-medicine and two cups of coffee (how else do you think I keep my girlish figure) I hope I can keep my stamina up for the afternoon session and BOFs tonight. Somehow I think the combination of readily-available caffeinated beverages and major geek convergence going on at the Portland Convention Center will carry me through.

Next post: a review of the afternoon tutorial: "When V is for Vexing: Patterns to DRY Up Your Views"
