--- 
sha1: ff54f6c9a0821662582cd28f78f8c086214022af
permalink: static-cling
title: Static Cling
kind: article
tags: 
- blog
created_at: 2010-02-22 17:40:40 -08:00
---
Lord knows why, but in the last couple of months I felt compelled to
move off of Wordpress and onto one of those new static content
generators for this site. Part of it was motivated by getting fed up
with constantly upgrading Wordpress. I suppose another part of it was
because all the [cool](http://userprimary.net)
[kids](http://davepeck.org/) were doing it. But, most importantly,
I wanted to give the site design a reboot&mdash;something I did _not_
want to do in PHP in the form of Wordpress themes. So with a little
help from [a friend](http://whole-studios.com/), this site got a
facelift and a new platform to boot.

I chose to use [Nanoc](http://nanoc.stoneship.org) as the
site-generator. Originally I was going to go with
[Jekyll](http://github.com/mojombo/jekyll). I really liked its
simplicity and the fact that it had prescribed locations for
everything. However, I still wanted to maintain some
backward-compatability with the old site. This meant a little bending
of Jekyll's rules and, frankly, Jekyll just isn't as configurable and
flexible as Nanoc. That's not a dig against Jekyll, nor is it an
endorsement of Nanoc. Nanoc is a general-purpose solution for
generating static sites, but it's not necessarily optimized for
blogging. But with Nanoc I can use HAML, SASS and other Rails-isms
with which I'm already familiar. If you want to see the gory details,
I've put the whole thing up on
[GitHub](http://github.com/alexvollmer/alexvollmer.com).

Sadly, this ended up taking much longer than I anticipated.
First, I had to import the old posts from Wordpress. The database
schema for Wordpress is pretty wacky looking when you're used to
working with Rails. Thankfully, Jekyll already gone down this path and
I used their Wordpress importer as inspiration for writing my
own. Along the way I discovered what great gem
[Sequel](http://rubygems.org/gems/sequel) is. A large part of the
importing process was converting from all of the jacked-up formats
I've amassed over the years to Markdown. It took a _lot_ of iterations
to catch every weird character-encoding and formatting issue.

Another large effort was creating the RSS feeds. Now Nanoc has _some_
support for Atom, but it didn't quite do what I wanted. I was trying
to match what Wordpress was generating for me so I basically
re-implemented feed-generation from scratch.

Moving old comments into [Disqus](http://disqus.com) took about
a week to get right. As a user, the Disqus service is pretty
cool. As a web API, it's a little&hellip;ahem&hellip; lacking. If
you're used to well-constructed REST APIs, you'd best drink something
stiff before settling in with the [API
docs](http://groups.google.com/group/disqus-dev/web/api-1-1). The
[disqus gem](http://github.com/norman/disqus) borders on useless. So,
I ended having to write my own importer with httparty. It took several
iterations to really get this nailed and the process was pretty
frustrating.

The sad part about this, is that originally I was on the fence about
adding comments at all. Initially I thought I'd try it out and see if
I liked it. But I'm a geek, right? I couldn't get it working right
away and it drove me nuts! I _had_ to figure it out. So eventually I
figured out the magic recipe, and now I'm wondering if I even really
wanted comments integrated at all. Oh well.

One trick that I found very helpful throughout this process was
creating some scripts that dropped me into an IRB session with the
Nanoc blog or Disqus API objects already initialized. This was
inspired by the Rails console which I find invaluable for tinkering with
things in real-time. For example, while I was dickering with the Nanoc
internals, I found this console script to be quite helpful:

<% highlight :ruby do %>
#!/usr/bin/env ruby

require "irb"
require "rubygems"
require "nanoc3"
load "lib/helpers.rb"

@site = Nanoc3::Site.new(".")
@site.load_data

IRB.start
<% end %>

Now, Wordpress and I differ on what constitutes a sensible URL
scheme. So that last bit I needed was to concoct some redirect rules
to port the old URL scheme to the new one. Currently, this site is
hosted on [http://dreamhost.com](Dreamhost) which, provides support
for `.htaccess` files. With a little Apache-fu I was able to get most
of the old WP URLs to redirect correctly:

<% highlight :sh do %>
RewriteEngine ON
RewriteRule ^index.php/feed/ /feeds/rss_2_0.xml [R]
RewriteRule ^index.php/feed/rss/ /feeds/rss_0_9_2.xml [R]
RewriteRule ^index.php/feed/atom/ /feeds/atom.xml [R]
RewriteRule ^index.php/(.*) /posts/$1 [R]

ErrorDocument 404 /missing.html
<% end %>

Well, that took longer than I thought. I can't say that it wasn't
educational. Now, what was I _supposed_ be doing?
