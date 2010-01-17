----- 
permalink: pci4r-update
title: PCI4R Update
date: 2008-03-23 18:13:24 -07:00
tags: ""
excerpt: ""
original_post_id: 76
toc: true
-----
We finally made some progress this week on the languishing [pci4r](http://github.com/alexvollmer/pci4r/tree/master pci4r on GitHub) project. First, congrats to [Sandro Paganotti](http://www.railsonwave.com/) for the first commit to pci4r--the prize is in the mail. This morning, after a bit of git-fiddling, I managed to get the second commit for the project in. It's code for document classification, which is the topic of Chapter 6 of Toby Segaran's ["Programming Collective Intelligence"](http://www.oreilly.com/catalog/9780596529321/). I deviated quite a bit from Toby's original code. In some cases this was simply a side-effect of porting from Python to idiomatic Ruby. In other cases though changes were made for simple aesthetic reasons.

In short, here's what you can do:

<% highlight :ruby do %>
c = Filtering::NaiveBayes.new

c.train("Nobody owns the water", :good)
c.train("the quick rabbit jumps fences", :good)
c.train("buy pharmaceuticals now", :bad)
c.train("make quick money at the online casino", :bad)
c.train("the quick brown fox jumps", :good)

c.prob("quick rabbit", :good)  #=> ~ 0.156
c.prob("quick rabbit", :bad)   #=> ~ 0.050`
<% end %>

Here we create a new `NaiveBayes` classifier, train it with some text and then query it with other text. Nifty eh? There is another classifier included in the package called `Fisher`, which has a slightly more clever classification algorithm.

Both of these default to in-memory storage of classification data. You can override it by using the built-in ActiveRecord persistence adapter like so:

<% highlight :ruby do %>
ar_config = Filtering::Persistence::ActiveRecordAdapter(
  :adapter => "sqlite3",
  :database => "mydb.sqlite3"
  :timeout => 5000
)
c = Filtering::NaiveBayes(ar_config)`
<% end %>

Finally, there's an executable in the 'bin' directory where you can interactively classify RSS feeds using either of the classifiers or persistence mechanisms provided. This relies on the
[feed_tools](http://feedtools.rubyforge.org/ RDoc for feedtools) gem.

So there it is. The rest of the pci4r team should be spooling up soon and hopefully we'll make some more progress. Stay tuned...
