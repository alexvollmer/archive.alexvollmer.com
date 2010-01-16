----- 
permalink: ten-things-i-think-i-think
layout: post
filters_pre: markdown
title: Ten Things I Think I Think
comments: 
- :author: alex
  :date: 2007-10-18 04:05:05 -07:00
  :body: Hey Ted, thanks for the pointer! GANT certainly looks interesting. I haven't yet felt the need to learn Groovy, so that's kind of holding me back from getting too excited about this. However I am starting to play with <a href="http://buildr.rubyforge.org" rel="nofollow">buildr</a> which is an intriguing mix of Ruby and Java. It seems like a nice mix of the good parts of Maven2 and Rake. We shall see...
  :url: http://livollmers.net
  :id: 
- :author: Ted Naleid
  :date: 2007-10-18 00:57:59 -07:00
  :body: |-
    Regarding #10 (Maven), I've been pretty happy recently using <a href="http://groovy.codehaus.org/Gant" rel="nofollow">GANT (groovy + ant)</a>  which includes <a href="http://www.jaya.free.fr/ivy/" rel="nofollow">Ivy</a> support for managing dependencies.
    
    It lets you code Ant tasks in Groovy syntax, and lets you mix and match with existing Ant infrastructure without having to write code in XML.
  :url: ""
  :id: 
excerpt: ""
date: 2007-10-17 04:24:41 -07:00
tags: ""
toc: true
-----
In the spirit of Peter King’s [Monday Morning Quarterback](http://sportsillustrated.cnn.com/writers/peter_king/archive/index.html SI.com), here are ten things that I think I think:

*10. Maven 2 Moves The Ball Down The Field (well, sortof):* All Java build systems suck. They all suck in different ways and the selection of one over the other is largely dictated by what types of pain you are willing to tolerate. I’ve used Maven since it’s inception. It solved some things Ant didn’t but also came with its own problems. Maven 2 attempts to solve some of the problems with Maven Mark I (namely scripting in XML, _yecch_), but lacks coherent documentation and a clear roadmap for learning the tool.

That being said, it makes tasks like creating a WAR file and deploying to a web server relatively trivial when compared with the amount of Ant XML you would have to write to do the same thing. There’s still too much XML for my liking and god help you if you want to do something outside of the box.

*9: Maybe Static Imports Ain’t So Bad:* When Java 5 first rolled around, I identified static imports as one of those features I would _never_ use. Well, heh heh, never say never I guess. I have started to use static imports in a few places where I need something like the equivalent of a Ruby mixin. Interestingly enough the the only places I’ve felt comfortable with their use have been in unit-testing when I want to use [EasyMock’s](http://www.easymock.org/ EasyMock : Home) methods or [JUnit 4](http://www.junit.org/ Welcome to The New JUnit.org! | JUnit.org) methods.

*8: Java Annotations Are Curious Creatures:* I can’t tell yet whether or not Java annotations are really all that great or not. If you’re a hard-core-no-good-thing-has-come-in-the-damn-JDK-since-the-collections-API kinda guy, you can make the argument that annotations are simply syntactic sugar for problems that could just as easily be solved with a proper object model or external configuration. In the old days (like the first version of EJBs) we wrote our configuration as actual code or, perhaps, as properties files. Then XML and Java went out on a hot date during the first dot-com bubble and spawned all sorts of illegitimate XML configuration children. I can’t tell you how many XML configuration systems I’ve seen that essentially reinvented properties files in XML (same configuration, twice the typing!)

Configuration via a pure object model can be, at times, extremely clunky (anyone remember writing EJB 1.0 deployment descriptors?) I think the evils of external file configuration have been experienced by just about any moderately experienced Java developer (Struts config anyone?) So it seems to me that annotations are simply a way to get some configuration closer to your code in something approaching a DSL (which most configuration files are _attempting_ to be) without external files. I haven’t played enough with them to be totally sold, but the idea is intriguing…

*7: I Couldn’t Code Java Without Eclipse:* I say this not because Eclipse is just the greatest Java IDE of all time, but because I’ve invested so much time learning so many of its tricks. Really any modern Java IDE probably has equivalent functionality, so the issue is not so much that I can’t imagine coding Java without Eclipse, but rather that I can’t imagine coding Java with a plain ol’ text-editor. I don’t think this says as much about me as it does about the language itself. Does anyone doing Java professionally on a daily basis still use Vim or Emacs?

*6: I Code Java, I Code Ruby. When Will I Use JRuby?:* It’s funny that for as much Java and Ruby as I’ve done in the last eighteen months that I still have done no more than dabble in JRuby. The day can’t be far off, but I’m a little surprised that it hasn’t yet arrived.

*5: I’m Tired of Algorithms:* Well, that’s not exactly right. I’m tired of algorithms as the measure of one’s knowledge of software development. It’s important, but it’s not the _most important_. Apparently most of the software world doesn’t agree with me so it’s up to me to decide whether or not I want to continue swimming upstream or simply relax and go with the flow. Some little voice in my head tells that the latter is not a good idea…

*4: I Think About Scaling All The Time:* Aside from sustainable development, scalability is probably the most important thing I think about at my current position. I’ve worried about it before, but the scope of previous projects that I’ve worked on don’t approach the ambitions of this one. I’ve spent a _lot_ of time in the last year reading up on all sorts of technologies around scalability. I’ve been pretty interested lately in things like the [Spread Toolkit](http://www.spread.org/ The Spread Toolkit) and [Wackamole](http://www.backhand.org/wackamole/ Wackamole: use your resources). I haven’t used them yet, but I’m keen to try them out. I’ve been using [Jini](http://www.jini.org/ Main Page - Jini.org) lately…the jury’s still out on that one.

*3: RDBMS Is Dead! Long Live RDBMS!* Part of the result of all this scalability reading and thinking is coming to the realization that a relational database doesn’t work everywhere as the be-all, end-all of persistence. To that end I’ve been immersing myself in a number of different technologies. Inverted indices provided by the likes of [Lucene](http://lucene.apache.org/java/docs/ Apache Lucene - Overview) or [Ferret](http://ferret.davebalmain.com/trac/ Ferret - Trac) are fascinating alternatives to the traditional RDBMS approach. If you twist your brain the right way you can satisfy most requirements you would have of an RDBMS with inverted indices.

Similarly various key/value databases such as [CouchDB](http://couchdb.org/CouchDB/CouchDBWeb.nsf/Home?OpenForm CouchDb Project Website) and even [Sleepycat](http://www.oracle.com/database/berkeley-db.html berkeley-db.html) make very sensible replacements for a general-purpose RDBMS. I find these interesting not so much because of their performance characteristics viz-a-viz RDBMS solutions—though that is certainly compelling—but rather because of their simplicity. For a lot of problems I really only care about storing and retrieving heterogeneous data via simple keys. Why make it any harder than that with a traditional relational column/row structure?

*2: I’m Going To Ask Erlang Out On A Date:* [Erlang](http://www.erlang.org/ Erlang) has gotten a lot of hype (and criticism) lately. Normally the simple churn of the blogosphere isn’t enough to get me interested in some johnny-come-lately, but Erlang strikes me as something with a little more staying power than the normal flavor-of-the-month technology. Perhaps it’s the track record as being “carrier-grade”. Perhaps it’s the move by some towards functional programming for solving particular problems. This, in particular, fascinates me. I’ve been an object-oriented guy for a long time, but there have been occasions when the OO approach seemed a little obtuse, but I didn’t really have a good alternative. I’m hoping that the process of learning Erlang will  be a great foil to “get” functional programming.

*1: I Think The OLPC Project Is Brilliant:* I can’t think of a project that embodies more of the things I value than the [One Laptop Per Child Project](http://laptop.org/ One Laptop per Child (OLPC), a $100 laptop for the world's children's education). It’s about putting the right amount of technology in the hands of kids. It’s about giving them a sturdy playground where they are encouraged to learn through experimentation. It’s about building sensible collaboration so that students can learn how to achieve more together as a group than they could as individuals. It’s about choosing and using a tool that gets things done. It’s _not_ about learning a particular platform and it’s _not_ about market-share.

I signed up for the [Give 1 Get 1 program](http://www.xogiving.org/ One Laptop Per Child -- XO Giving), but I can’t really justify having my own OLPC laptop. However I may get one just to play with it for a few days and then find a worthy home for it. I can’t imagine a better way to empower a kid than to put a tool like this in their hands.
