----- 
permalink: ruby-threads-suckjust-not-the-way-you-think-they-do
title: Ruby Threads Suck&#8230;Just Not The Way You Think They Do
date: 2009-01-26 01:47:24 -08:00
tags: ""
excerpt: ""
original_post_id: 219
toc: true
-----
At [work](http://www.evri.com Evri!!), we do a lot of scheduled tasks in which we process a "chunk" of data within a particular time-period. For example, we may tail log files, parse the lines and publish summary statistics "up-stream" on a fixed schedule of, say, ten minutes. Similarly, last week we were working on a Ruby wrapper script that launches [memcached](http://www.danga.com/memcached/ memcached) and maintains a registration lease within a home-grown registration service we run. The script needs to launch memcached, then periodically check it and renew its registration lease.

We have a RubyGem written to handle registration and renewal that hides the HTTP and XML message bodies away from the user. You simply create a client, setup your initial registration and tell it to keep you registered.

    require "rubygems"
    require "radar_love"
    client = Radar::Client.new("http://radar-dev")
    service = client.create('foobar', 'http://foobar:1234')
    service.keep_registered # fires up background thread

That last line is implemented with a Ruby thread that loops indefinitely, sleeping and then renewing the registration lease. But a funny thing happened while implementing this. When we just fired up `irb` and tried to run this part (without doing any other work), the re-registration thread _never_ executed. Man, I had heard that MRI threads were "broken", but this is completely non-functioning!

Then I remembered a [very handy page](http://spec.ruby-doc.org/wiki/Ruby_Threading Ruby Threading Spec) I ran across once about MRI Threading. This page is worth spending a little time with, but essentially because MRI threads are so-called "green threads" they aren't really giving you true concurrent processing. Instead they are merely a context-switching mechanism, and the circumstances under which those switches can happen are described in that spec page.

In the case of our little `irb` session, the re-registration thread only began executing when we did something in the main thread. We weren't executing anything in the main thread that triggered one of these context-switches (remember, we're merely sitting at an irb prompt waiting for the next line). So getting the runtime to execute a context-switch merely required us to do _something_ in the main thread:

    loop do
      puts "Howdy!"  
      sleep 5
    end

You may shake your head and mutter something derisive about this "hack". However, in reality, requiring your main thread to do something isn't terribly burdensome. If you didn't have any work to do in your main thread, you'd have to ask yourself why you created a separate thread in the first place!

You may also think that since MRI threads don't provide true concurrency, they're worthless. One major limitation of green threads in MRI is that no matter how many you start, they will only execute on one processor. If you have a large multi-core machine, MRI threads will _not_ be able to take advantage of them.

However, that doesn't mean threads don't have their place in MRI environments. In the first example I mentioned (tailing logs and publishing summaries) we use a separate thread for the publishing activity. We _could_ have done this entire action in a single loop, but the major downside is that we would essentially be relying on new lines in our log to appear to "crank" the mechanism forward. If we go a long time before we see another log line, our summary task will fail to execute.

    IO.popen("tail -F /var/log/some.log").each do |line|
      update_statistics(line)
      if Time.now >= next_report_time
        # we might not get here for a while unless the
        # log lines keep coming
        report_statistics
      end
    end

It would certainly be possible to read from the file with a timeout that is based on how much time is left before the next reporting period. However at that point the code starts to get a little cluttered, so we go with the threaded approach only to take advantage of its context-switching properties. In our case, this is a perfect solution for what we're trying to accomplish.

If you come from a Java or .NET background, you may find that MRI threads fail to measure up to threading in those environments. It's absolutely true that MRI does not provide the same robust threading mechanisms that those languages do ([JRuby](http://spec.ruby-doc.org/wiki/JRuby_Threading JRuby Threading), and perhaps IronRuby, being special cases). It doesn't mean that threads in MRI are worthless, you just need to [understand them](http://www.infoq.com/news/2007/05/ruby-threading-futures Ruby Threading) properly to know when to use them.


