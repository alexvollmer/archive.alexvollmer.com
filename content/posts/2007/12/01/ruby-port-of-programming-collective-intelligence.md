----- 
permalink: ruby-port-of-programming-collective-intelligence
title: Ruby Port of "Programming Collective Intelligence"
date: 2007-12-01 23:49:08 -08:00
tags: ""
excerpt: ""
original_post_id: 35
toc: true
-----
Thanks to a quick comment from Toby Seagaran, the author of ["Programming Collective Intelligence"](http://www.oreilly.com/catalog/9780596529321/ O'Reilly Media | Programming Collective Intelligence), my motivation finally exceeded my laziness in getting the porting code available in a public place. So I&#8217;m proud to announce that you can take a look at the ongoing porting effort at [my Ruby port of Programming Collective Intelligence](http://github.com/alexvollmer/pci4r). I'm in the midst of Chapter 4 right now, so I still have a long way to go.


There are number of things in the code that make me cringe (it always amazes me how a better solution to something occurs usually about five minutes after I commit), but if nothing else it&#8217;s a monument to the effort I&#8217;ve made thus far. Hopefully the thought of public shame will motivate me to get in there and clean some of that stuff up.


Note that I&#8217;ve deviated somewhat from the book in the naming of things. By and large I&#8217;ve stuck to the same basic names, but I&#8217;ve followed Ruby&#8217;s underscore naming convention for methods and camel-case for module and class names. All of the code is under a single `PCI` module namespace (though spread around several files). I&#8217;ve also included underscore in the database table and column names that go in the [SQLite](http://www.sqlite.org/ SQLite Home Page) database that is created in Chapter 4 of Toby&#8217;s book.


Pedagogically, organizing the code into chapters would probably be more useful to people, but I don&#8217;t currently have it setup this way. With a beer and little trolling through the SVN logs I could probably reorganize the repository to match this. If folks want this, lemme know.


One final note, I&#8217;ve organized the code into a structure loosely based on a standard Ruby Gem layout. I&#8217;ve tried putting some [specs](http://rspec.rubyforge.org/ RSpec-1.0.8: Home) around the code that is there, but the overall coverage is pretty underwhelming. I wrote specs to prove that my porting worked, not necessarily to test the underlying code that Toby originally wrote. In short, anytime I ran a manual test more than two times I have (usually) written a spec for it.
