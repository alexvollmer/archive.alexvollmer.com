----- 
sha1: ed04d4f3f6fd0ed21f21dd857bc36e7dbdd40af7
kind: article
permalink: you-put-merb-in-my-jetty
created_at: 2009-02-11 23:31:53 -08:00
title: You Put Merb In My Jetty!
excerpt: In the latest update of The Chronicles of Stuff Alex Figures out at Work, our intrepid hero figures out how to run Merb inside an embedded Jetty instance!
original_post_id: 287
tags: 
- java
- ruby
toc: true
-----
In the latest update of _The Chronicles of Stuff Alex Figures out at Work,_ our intrepid hero figures out how to run Merb inside an embedded Jetty instance!

Now you may ask yourself, "for the love of God, why would you want to do something like this?" Well, at [work](http://www.evri.com Evri!) we do a lot of internal web services. For my particular team, we've found a real sweet-spot by using an embedded Jetty server sitting right next to a BDB instance. There are no extra processes or packages to manage (e.g. apache or a RDBMS). However we were becoming dissatisfied with our current web layer which is a homegrown REST framework that sits on top of the Servlet API. So in a fit of rage, I decided to see if I could stuff Merb in the middle of this mess.

You may also be asking yourself, "why not use the [jruby-rack](http://blog.nicksieger.com/articles/2008/05/08/introducing-jruby-rack JRuby-Rack) gem directly?" The answer is that the jruby-rack gem makes a lot of assumptions about how you want to run your application. First it assumes that you're cool with packaging things up as a WAR (which I'm not) and, secondly, that your application is _primarily_ a Rails/Merb application. In my case, for better or worse, our app is really a BDB application with a Merb app glommed onto the side for web visibility.
# The Solution

I can't take complete credit for this solution. If I hadn't found [Jan Berkel's post on putting Rails in Jetty](http://www.trampolinesystems.com/blog/machines/2008/11/27/rails-22-jruby-jetty-win/ rails 2.2 + jruby + jetty = win) I would have _never_ figured out how to stuff Merb in there. To give yourself some context, take a look at that post first. Then take a look at the "Merb-ified" version of the same recipe below. Both solutions assume that you're configuring Jetty within JRuby.

<% highlight :ruby do %>
server = org.mortbay.jetty.Server.new
thread_pool = org.mortbay.thread.QueuedThreadPool.new
thread_pool.min_threads  = 5  # adjust as needed
thread_pool.max_threads  = 50
server.set_thread_pool(thread_pool)
context = Context.new(nil, "/", Context::NO_SESSIONS)
context.add_filter("org.jruby.rack.RackFilter", "/*", Handler::DEFAULT)
context.set_resource_base(Environment.resolve)
context.add_event_listener(MerbServletContextListener.new)
context.set_init_params(java.util.HashMap.new('merb.root'=>; Environment.resolve,
    'merb.environment' => 'production',
    'public.root' => Environment.resolve('public'),
    'gem.path' => Environment.resolve('gems'),
    'org.mortbay.jetty.servlet.Default.relativeResourceBase' => '/public',
    'jruby.max.runtimes' => '1'))
context.add_servlet(ServletHolder.new(DefaultServlet.new), "/")
server.set_handler(context)
server.start
<% end %>

# Tweaking

At first blush our performance seemed to be pretty lacking. This required two tweaks: putting Merb in "production" mode and dealing with poor I/O due to logging. In the previous snippet you will notice that we set the <tt>merb.environment</tt> to <tt>production</tt>. Yes we lose the quick dev turnaround, but since there is a lot of Java in this project we usually have to recompile anyway which requires a restart anyway (phooey).

As for the I/O issue, a [little digging](http://www.nabble.com/JRuby-vs-MRI---Petstore-shootout-td12211276.html JRuby vs MRI) revealed that shutting up Merb as much as possible would help reduce the amount of JRuby-level IO. In our <tt>config/init.rb</tt> we configure logging like so:

<% highlight :ruby do %>
Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :warn,
  c[:log_file]            = Merb.root / "logs" / "merb.log",
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_facet-store_session_id',
  c[:session_secret_key]  = '49411912879b879e13f89a9280c0f6aaa2e3ab58',
  c[:exception_details]   = true,
  c[:reload_classes]      = false,
  c[:reload_templates]    = false
}
<% end %>

Here we set the environment to "production" again (yes, you need to do both). Also we upped the log level to "warn" which significantly reduced the amount of logging merb does. With these tweaks in place we found that the Merb port of our service was operating within about 80% of the level of performance we were getting from our pure-Java solution.

Benchmarking was done by running [httperf](http://www.hpl.hp.com/research/linux/httperf/ httperf  it's so not JMeter!) tests against the resources we expose and comparing both the number of requests per second and the average response time. Given that the options for generating XML, HTML and JSON were all so much easier than what we were doing in the servlet version, we were willing to live with the performance hit.
