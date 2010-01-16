----- 
permalink: ruby-port-of-programming-collective-intelligence
layout: post
filters_pre: markdown
title: Ruby Port of "Programming Collective Intelligence"
comments: 
- :author: retcheto
  :date: 2008-02-28 23:50:45 -08:00
  :body: very useful, thanks for doing this
  :url: ""
  :id: 
- :author: Greg Moreno
  :date: 2009-03-05 01:36:38 -08:00
  :body: |-
    Hi Alex,
    
    I just started reading the book and I can say it's a good investment. I'll poke around the github repo and hopefully can contribute to your work one day.
    
    Regards.
  :url: http://www.gregmoreno.ca
  :id: 
- :author: Conrad
  :date: 2008-08-27 03:13:59 -07:00
  :body: |-
    Hi Alex, how are you doing?  Anyway, I'm very interested in the progress of you port.  Thus, are there any updates?
    
    Thanks,
    
    -Conrad
  :url: ""
  :id: 
- :author: alex
  :date: 2008-08-27 16:33:09 -07:00
  :body: "The code has moved to <a href=\"http://github.com/alexvollmer/pci4r\" rel=\"nofollow\">GitHub</a>. I haven't worked on it in awhile, but hope to get back to it in a few months. Feel free to contribute if you like.\r\n\
    \r\n\
    \xE2\x80\x94Alex"
  :url: http://livollmers.net
  :id: 
excerpt: ""
date: 2007-12-01 23:49:08 -08:00
tags: ""
toc: true
-----
<p>Thanks to a quick comment from Toby Seagaran, the author of [“Programming Collective Intelligence”](http://www.oreilly.com/catalog/9780596529321/ O'Reilly Media | Programming Collective Intelligence), my motivation finally exceeded my laziness in getting the porting code available in a public place. So I&#8217;m proud to announce that you can take a look at the ongoing porting effort at [http://svn.livollmers.net/public/pci](http://svn.livollmers.net/public/pci Ruby port of Programming Collective Intelligence). I'm in the midst of Chapter 4 right now, so I still have a long way to go.


<p>There are number of things in the code that make me cringe (it always amazes me how a better solution to something occurs usually about five minutes after I commit), but if nothing else it&#8217;s a monument to the effort I&#8217;ve made thus far. Hopefully the thought of public shame will motivate me to get in there and clean some of that stuff up.


<p>Note that I&#8217;ve deviated somewhat from the book in the naming of things. By and large I&#8217;ve stuck to the same basic names, but I&#8217;ve followed Ruby&#8217;s underscore naming convention for methods and camel-case for module and class names. All of the code is under a single `PCI` module namespace (though spread around several files). I&#8217;ve also included underscore in the database table and column names that go in the [SQLite](http://www.sqlite.org/ SQLite Home Page) database that is created in Chapter 4 of Toby&#8217;s book.


<p>Pedagogically, organizing the code into chapters would probably be more useful to people, but I don&#8217;t currently have it setup this way. With a beer and little trolling through the SVN logs I could probably reorganize the repository to match this. If folks want this, lemme know.


<p>One final note, I&#8217;ve organized the code into a structure loosely based on a standard Ruby Gem layout. I&#8217;ve tried putting some [specs](http://rspec.rubyforge.org/ RSpec-1.0.8: Home) around the code that is there, but the overall coverage is pretty underwhelming. I wrote specs to prove that my porting worked, not necessarily to test the underlying code that Toby originally wrote. In short, anytime I ran a manual test more than two times I have (usually) written a spec for it.
