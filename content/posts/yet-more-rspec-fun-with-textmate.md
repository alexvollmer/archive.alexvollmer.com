----- 
permalink: yet-more-rspec-fun-with-textmate
title: Yet More RSpec Fun With TextMate!
excerpt: ""
date: 2007-12-16 03:08:38 -08:00
tags: ""
toc: true
-----
Why is it that I just can&#8217;t leave well enough alone? Here, after several weeks for forehead-impact conditioning, I _finally_ get a working setup with Ruby on Leopard with RSpec and TextMate. Life is good, I have my pretty spec runner window back, I&#8217;m a BDD&#8217;ing fool. But oh no, I have to keep fiddling with stuff.


So I&#8217;m finally putting some foundation work into a nifty little webapp that a (childhood) buddy of mine and I are working on. &#8220;Hey&#8221;, I think to myself, &#8220;why not make it a Rails 2.0 app? Better yet, why not get yer RSpec on too?&#8221; Brilliant. Why not? What could possibly go wrong? Well after installing the trunk versions of the RSpec plugin for Rails (of course) my beloved RSpec bundle stopped working. :-(


After a little digging around (including the OS X equivalent of `printf` debugging, [Growl](http://growl.info/ Welcome to Growl!)) I realized that I&#8217;m probably facing incompatibility issues with the TM bundle and the version of RSpec. Now keep in mind that I&#8217;ve got two different RSpec-based projects that I&#8217;m using the bundle with. One is a straight-up lib-and-spec directory app (the [Programming Collective Intelligence port](http://svn.livollmers.net/public/pci/ /pci)), and the other is this new Rails app. The former was using version 1.0.8 of the gem, while the latter is using the plugin code that I installed.


So I go back to the [RSpec bundle that the RSpec folks put out](http://rspec.rubyforge.org/tools/extensions/editors/textmate.html TextMate) and lo and behold it works like a champ for my Rails app&#8230;but not so much for the standalone project. Oh dear. Now what? Like [Doug Flutie vs. Miami](http://www.youtube.com/watch?v=r-qkpsygNYo YouTube - Flutie Hail Mary) I chuck a Hail Mary and run `sudo gem update rspec`&#8230;


`Updating installed gems...
Attempting remote update of rspec
Successfully installed rspec-1.1.0
1 gem installed
Installing ri documentation for rspec-1.1.0...
Installing RDoc documentation for rspec-1.1.0...
Gems: [rspec] updated
`</pre>

Yayyy! A new version! Now the RSpec bundle for TextMate works in both projects. So, the final recipe goes a little something like this:


<ol>
*  Install the latest bleeding-edge RSpec plugin for Rails
*  Install the RSpec version of the TextMate bundle
*  Make sure the latest gem (1.1.0) is installed.
</ol>

OK, now has anyone seen my productivity around here? I&#8217;d swear I saw it just before Halloween&#8230;
