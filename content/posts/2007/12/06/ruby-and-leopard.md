----- 
kind: article
permalink: ruby-and-leopard
created_at: 2007-12-06 14:11:19 -08:00
title: Ruby and Leopard
excerpt: ""
original_post_id: 36
tags: 
- ruby
- mac
toc: true
-----
I've spent the bulk of this week trying to dig myself out of Ruby/Leopard hell. I'm surprised that things were as borked as they were. So much so, that I'm inclined to believe that there was something special happening on my machine. I got my shiny new Leopard install the day after it came out. I did an upgrade (not a clean install) with no hiccups and was happy with all of my [shiny happy new Leopard features](http://www.apple.com/macosx/features/300.html Apple - Mac OS X Leopard - Features - 300+ New Features). I knew that first-class Ruby support was coming so I figured I would abandon my MacPorts install and go with what Mr. Jobs deigned to give me.

At first things seemed to go well. But as I was spooling up again on my ["Programming Collective Intelligence"](http://svn.livollmers.net/public/pci/ /pci) project, [autotest](http://www.zenspider.com/ZSS/Products/ZenTest/ ZenTest: Automated test scaffolding for Ruby) with [rspec](http://rspec.rubyforge.org/ RSpec-1.0.8: Home) was just flat-out broken. When I ran `autotest` I would get an error like the following:

<% highlight :irb do %>
/Library/Ruby/Gems/1.8/gems/rspec-1.0.8/lib/autotest/rspec.rb:80:in spec_command': No spec command could be found! (RspecCommandError)
    from /Library/Ruby/Gems/1.8/gems/rspec-1.0.8/lib/autotest/rspec.rb:10:in initialize'
    from /Library/Ruby/Gems/1.8/gems/ZenTest-3.6.1/lib/autotest.rb:123:in new'
    from /Library/Ruby/Gems/1.8/gems/ZenTest-3.6.1/lib/autotest.rb:123:in run'
    from /Library/Ruby/Gems/1.8/gems/ZenTest-3.6.1/bin/autotest:48
    from /usr/bin/autotest:16:in `load'
    from /usr/bin/autotest:16
<% end %>

After _lots_ of digging, I figured out that `autotest` uses the built-in `Config` class which defines a `bindir` that rspec (with autotest) uses to derive possible locations for the `spec` command. On Leopard the default 'bindir' for Leopard was `/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin` which was _not_ where the `spec` command was installed. With a little help from [a blog post](http://www.rubybyraeli.org/blog/articles/2007/11/28/262-hacking-at-the-heads-of-a-hydra-ruby-install Hacking at the heads of a Hydra Ruby install) I simply symlinked `spec` into that impossibly long path and things seemed to work.

For now I'm sticking with the Leopard install. I've fiddled a little bit with the [Scripting Bridge](http://www.apple.com/applescript/features/scriptingbridge.html AppleScript: Scripting Bridge) stuff and it's pretty nifty so I'm hesitant to abandon the Apple install. I just hope that Ruby support doesn't rot the same way Java support has.
