----- 
permalink: opening-the-gatesof-hell
layout: post
filters_pre: markdown
title: Opening The Gates&#8230;of Hell!!
comments: []

excerpt: ""
date: 2009-01-27 06:01:11 -08:00
tags: Ruby
toc: true
-----
…umm, no, actually not so much.

![hellboy.jpg](/uploads/2009/01/hellboy.jpg)Instead, this is just a humble little notice about a [humble little gem](http://github.com/alexvollmer/daemon-spawn/tree/master daemon-spawn) I put together today. It's called *daemon-spawn* and despite its simply terrifying name, it's really here to help all mankind. You see, I've been working like mad to stuff Merb smack-dab in the middle of an embedded Jetty project I've been working on. One of the last things I needed was a decent daemon-launcher/management gem-thingie to make it happen.

I cast about for an existing solution and found each a little lacking. The [daemons](http://daemons.rubyforge.org/ Ruby Daemons) gem had the executable name hard-wired to the output log name and didn't give me a clean way to specify additional arguments to JRuby (unless I wrote _another_ wrapper script, to which I say "boo, hiss"). Then I looked at [simple-daemon](http://simple-daemon.rubyforge.org/ simple-daemon) which seemed really promising. It was really really close to what I wanted but didn't extend very well as it required more and more class-methods. Yuck. I looked at [daemon_generator](http://kylemaxwell.typepad.com/everystudent/2006/08/after_writing_r.html daemon_generator), but it was very Rails-y and wanted to generate a bunch of code for me, which I didn't need. So I did what any honest, hard-working Ruby-dork does, and _made my own!_

It's simple—dead simple. Wanna see how simple? Here's a real-live echo server with daemon support:
    1 <span class="comment comment_line comment_line_number-sign comment_line_number-sign_ruby"><span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby">#!/usr/bin/env ruby
</span>    2
    3 <span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'daemon-spawn'</span></span>
    4 <span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'socket'</span></span>
    5
    6 <span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class EchoServer<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; DaemonSpawn::Base</span></span>
    7
    8   attr_accessor <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:server_socket</span>
    9
   10   <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def start(args)</span>
   11     port = args.empty? ? 0 : args.first.to_i
   12     self.server_socket = TCPServer.new(<span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'127.0.0.1'</span>, port)
   13     port = self.server_socket.addr[1]
   14     puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"EchoServer started on port <span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{port}</span>"</span>
   15     loop <span class="keyword keyword_control keyword_control_start-block keyword_control_start-block_ruby">do
</span>   16       begin
   17         client = self.server_socket.accept
   18         while str = client.gets
   19           client.write(str)
   20         end
   21       rescue Errno::ECONNRESET =&gt; e
   22         STDERR.puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"Client reset connection"</span>
   23       end
   24     end
   25   end
   26
   27   <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def stop</span>
   28     puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"Stopping EchoServer..."</span>
   29     self.server_socket.close if self.server_socket
   30   end
   31 end
   32
   33 EchoServer.spawn!(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:working_dir</span> =&gt; File.join(File.dirname(__FILE__), <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'..'</span>),
   34                   <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:log_file</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'/tmp/echo_server.log'</span>,
   35                   <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:pid_file</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'/tmp/echo_server.pid'</span>,
   36                   <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:sync_log</span> =&gt; true,
   37                   <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:singleton</span> =&gt; true)</span></span></pre>
But what if you have non-Ruby code you want to daemonize? Well my friends, that's what `Kernel#exec` is for and it works like a champ. See the README for the full details. And of course to view the README, you have to install the gem which means you have *daemon-spawn* in the bowels of your machine! Mwaaa haa haa haa! Oops…I've said too much…

In all seriousness though, I would like to thank the powers-that-be at [work](http://www.evri.com Evri!!) who were very gracious to let me open-source this. You should start seeing more of this kind of stuff from Evri soon. As always, your feedback, comments, critiques and patches are welcome.
