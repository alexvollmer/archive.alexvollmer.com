----- 
kind: article
permalink: opening-the-gatesof-hell
created_at: 2009-01-27 06:01:11 -08:00
title: Opening The Gates&#8230;of Hell!!
excerpt: ""
original_post_id: 238
tags: 
- ruby
toc: true
-----
&hellip;umm, no, actually not so much.

![hellboy.jpg](/images/2009/01/hellboy.jpg)Instead, this is just a humble little notice about a [humble little gem](http://github.com/alexvollmer/daemon-spawn/tree/master daemon-spawn) I put together today. It's called *daemon-spawn* and despite its simply terrifying name, it's really here to help all mankind. You see, I've been working like mad to stuff Merb smack-dab in the middle of an embedded Jetty project I've been working on. One of the last things I needed was a decent daemon-launcher/management gem-thingie to make it happen.

I cast about for an existing solution and found each a little lacking. The [daemons](http://daemons.rubyforge.org/ Ruby Daemons) gem had the executable name hard-wired to the output log name and didn't give me a clean way to specify additional arguments to JRuby (unless I wrote _another_ wrapper script, to which I say "boo, hiss"). Then I looked at [simple-daemon](http://simple-daemon.rubyforge.org/ simple-daemon) which seemed really promising. It was really really close to what I wanted but didn't extend very well as it required more and more class-methods. Yuck. I looked at [daemon_generator](http://kylemaxwell.typepad.com/everystudent/2006/08/after_writing_r.html daemon_generator), but it was very Rails-y and wanted to generate a bunch of code for me, which I didn't need. So I did what any honest, hard-working Ruby-dork does, and _made my own!_

It's simple&mdash;dead simple. Wanna see how simple? Here's a real-live echo server with daemon support:

<% highlight :ruby do %>
#!/usr/bin/env ruby

require 'daemon-spawn'
require 'socket'

class EchoServer << DaemonSpawn::Base

  attr_accessor :server_socket

  def start(args)
    port = args.empty? ? 0 : args.first.to_i
    self.server_socket = TCPServer.new('127.0.0.1', port)
    port = self.server_socket.addr[1]
    puts "EchoServer started on port #{port}"
    loop do
      begin
        client = self.server_socket.accept
        while str = client.gets
          client.write(str)
        end
      rescue Errno::ECONNRESET => e
        STDERR.puts "Client reset connection"
      end
    end
  end

  def stop
    puts "Stopping EchoServer..."
    self.server_socket.close if self.server_socket
  end
end

EchoServer.spawn!(:working_dir => File.join(File.dirname(__FILE__), '..'),
                  :log_file => '/tmp/echo_server.log',
                  :pid_file => '/tmp/echo_server.pid',
                  :sync_log => true,
                  :singleton => true)
<% end %>

But what if you have non-Ruby code you want to daemonize? Well my friends, that's what `Kernel#exec` is for and it works like a champ. See the README for the full details. And of course to view the README, you have to install the gem which means you have *daemon-spawn* in the bowels of your machine! Mwaaa haa haa haa! Oops&hellip;I've said too much&hellip;

In all seriousness though, I would like to thank the powers-that-be at [work](http://www.evri.com Evri!!) who were very gracious to let me open-source this. You should start seeing more of this kind of stuff from Evri soon. As always, your feedback, comments, critiques and patches are welcome.
