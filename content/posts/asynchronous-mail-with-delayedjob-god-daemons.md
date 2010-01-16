----- 
permalink: asynchronous-mail-with-delayedjob-god-daemons
layout: post
filters_pre: markdown
title: Asynchronous Mail with DelayedJob, God &#38; Daemons
comments: 
- :author: rany
  :date: 2008-11-11 08:15:06 -08:00
  :body: |-
    hey alex, 
    
    there's a much easier way of doing this with workling, which also runs over the database instead of using starling: http://playtype.net/past/2008/11/11/sending_mail_asynchronously_in_rails/
  :url: http://playtype.net
  :id: 
- :author: alex
  :date: 2008-11-11 16:43:58 -08:00
  :body: |-
    Rany,
    
    Thanks for the link. I wish I had found that when I first started on this journey. How does it affect your tests? As I wrote above I wasn't 100% happy with how things turned out in test-land.
    
    Cheers,
    
    Alex
  :url: http://livollmers.net
  :id: 
- :author: Josh Martin
  :date: 2009-04-15 02:20:29 -07:00
  :body: |-
    You or your readers may also be interested in ar_mailer. It is specifically made as a drop in replacement for ActionMailer which will create DB backed emails async and handle the queue with an external daemon or cron job.
    
    Original ar_mailer: http://github.com/seattlerb/ar_mailer/tree/master
    
    Maintained Fork: http://github.com/adzap/ar_mailer/tree/master
  :url: ""
  :id: 
excerpt: ""
date: 2008-11-06 05:14:42 -08:00
tags: Ruby
toc: true
-----
Slowly but surely I've been pecking away at a little Rails-based side-project for the last four or five months. I'm _this close_ to flipping the _on_ switch—but in the meantime I've still got some "i"s to dot and "t"s to cross. One of those was switching from in-request mail delivery to asynchronous mail delivery. The app I've been working on involves two parties marching a particular transaction through a variety of state transitions, each of which usually sends an email to either or both parties.

Like a good boy I started out with the simplest thing that could work which was to simply call mailers in my model. However, I wanted to limit the number of activities performed during a request to keep the app feeling responsive. So I decided that asynchronous mail delivery was a "pre-launch" feature that I had to have.

I looked at a variety of background processing tools, including Bj, Starling/Workling, Spawn and AP4R. Each had its strengths and weaknesses but none of them felt like the right fit. My research criteria included:
*  Job persistence via the database
*  Something that could get a Rails environment cheaply
*  Runs outside of the Rails processes
*  Minimum fuss to get it running

In the end the one that hit the sweet-spot best was [delayed_job.](http://github.com/tobi/delayed_job GitHub Repo) It had the DB persistence I was looking for, but didn't source the Rails environment for each worker and it was extremely simple to plumb it into my app.
## Refactoring
The first step was creating the `DelayedJob` worker classes; one for each mail action. At first this turned into a big pile of five-line classes, so to keep things organized I put these all in `app/models/jobs` and put each class in the Jobs module namespace. This was better, but not good enough so the final step was putting _all_ of the worker classes in a single file, `app/models/jobs.rb`.

The second step was to find every place in the model where I called my mailer classes directly and replace them with calls to enqueue the appropriate worker job.

Here is what things looked like at first:
    1 <span class="meta meta_class meta_class_ruby"><span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class UserObserver<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; ActiveRecord::Observer</span></span>
    2   <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def after_create(user)</span>
    3     unless user.current_state == <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:latent</span> or user.is_a?(Admin)
    4       UserNotifier.deliver_signup_notification(user)
    5     end
    6   end
    7
    8   <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def after_save(user)</span>
    9     if user.current_state == <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:promoted</span>
   10       UserNotifier.deliver_signup(user)
   11     else
   12       UserNotifier.deliver_activation(user) if user.recently_activated?
   13     end
   14   end
   15 end
</span>   16</span></pre>
Then the UserObserver was refactored like this:
    1 <span class="meta meta_class meta_class_ruby"><span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class UserObserver<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; ActiveRecord::Observer</span></span>
    2   <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def after_create(user)</span>
    3     unless user.current_state == <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:latent</span> or user.is_a?(Admin)
    4       Delayed::Job.enqueue(Jobs::UserNotifierSignupNotificationJob.new(user.id))
    5     end
    6   end
    7
    8   <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def after_save(user)</span>
    9     if user.current_state == <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:promoted</span>
   10       Delayed::Job.enqueue(Jobs::UserNotifierSignupNotificationJob.new(user.id))
   11     else
   12       Delayed::Job.enqueue(Jobs::UserNotifierActivationJob.new(user.id)) if user.recently_activated?
   13     end
   14   end
   15 end
</span>   16</span></pre>
With the following workers (abridged):
    1 <span class="meta meta_module meta_module_ruby"><span class="keyword keyword_control keyword_control_module keyword_control_module_ruby">module Jobs</span>
    2   <span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class UserNotifierDisconnectJob<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; Struct.new</span></span>(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:user_id</span>)
    3     <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def perform</span>
    4       UserNotifier.deliver_disconnect(user_id)
    5     end
    6   end
    7
    8   <span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class UserNotifierResetPasswordJob<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; Struct.new</span></span>(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:user</span>)
    9     <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def perform</span>
   10       UserNotifier.deliver_reset_password(user)
   11     end
   12   end
   13
   14   <span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class UserNotifierSignupNotificationJob<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; Struct.new</span></span>(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:user</span>)
   15     <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def perform</span>
   16       UserNotifier.deliver_signup_notification(user)
   17     end
   18   end
   19
   20   <span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class UserNotifierStartDisconnectJob<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt;&lt; Struct.new</span></span>(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:user_id</span>)
   21     <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def perform</span>
   22       UserNotifier.deliver_start_disconnect(user_id)
   23     end
   24   end
   25 end
</span>   26</span></span></span></span></pre>
## Testing
Prior to switching to asynchronous processing, mail delivery was triggered within my models, either via Observers or as Procs attached to state transitions (I'm using the `acts_as_state_machine` plugin). Therefore my tests had loads of assertions that various state changes in the model resulted in direct email delivery. In the asynchronous model of course, that changes slightly. While the state change ultimately ends in mail delivery, it only happens indirectly.

So here I had a big pile of tests that asserted that poking the model in certain ways resulted in a mail delivery. In my unit-tests I really just wanted to test the interaction between the models and `DelayedJob`. After all, if something went hay-wire during mail delivery the culprit would likely be my new worker classes, _not_ my model.

However, for my integration tests I still wanted to keep the assertions about actual mail delivery since that was an important part of the stories. I could easily do this by monkey-patching the `DelayedJob::enqueue` method to call the worker's `perform` method directly. In my unit-tests I monkey-patched the `DelayedJob::enqueue` method to work more like a mock object which added some inquiry methods to check that it had been invoked correctly.

In isolation this worked great, but running all the tests together resulted in a number of random failures. I've run into this enough times to recognize that some tests were somehow poisoning the run-time environment for the others. It turns out that my two approaches were incompatible with each other unless I was very diligent about cleaning everything up properly. I will admit with red-faced shame that I punted. I did the lamest thing one could possibly do and redefined `DelayedJob::enqueue` for _all_ of my tests and kept all of my original assertions. I'm not proud of it, but it does work.
## Running in Production
The next trick was getting this all running in a production environment and I needed to figure out how one or more workers would be started and kept running. While it's great to have this decoupled from the Rails environment, it means that it's a separate process that needs to be managed.

My solution was to use the `daemons` gem to create a couple of scripts. Then I used Tom Preston-Warner's `god`, to monitor my process. The scripts look like this:
    1 <span class="comment comment_line comment_line_number-sign comment_line_number-sign_ruby"><span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby">#!/usr/bin/env ruby
</span>    2
    3 unless ARGV.size == 1
    4   <span class="punctuation punctuation_definition punctuation_definition_variable punctuation_definition_variable_ruby">$stderr</span>.puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"USAGE: <span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{0}</span> [environment]"</span>
    5   exit 1
    6 end
    7
    8 RAILS_ENV = ARGV.first
    9 <span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require File.dirname(__FILE__) + <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'/../config/environment'</span></span>
   10
   11 Delayed::Worker.new.start
</span>   12</pre>
And the "control" script looks like this:
    1 <span class="comment comment_line comment_line_number-sign comment_line_number-sign_ruby"><span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby">#!/usr/bin/env ruby
</span>    2
    3 <span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"rubygems"</span></span>
    4 <span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"daemons"</span></span>
    5
    6 <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def running?(pid)</span>
    7   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># Check if process is in existence
</span>    8   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># The simplest way to do this is to send signal '0'
</span>    9   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># (which is a single system call) that doesn't actually
</span>   10   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># send a signal
</span>   11   begin
   12     Process.kill(0, pid)
   13     return true
   14   rescue Errno::ESRCH
   15     return false
   16   rescue ::Exception   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># for example on EPERM (process exists but does not belong to us)
</span>   17     return true
   18   end
   19 end
   20
   21 if ARGV.size == 1 and ARGV.first == <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"status"</span>
   22   pidfile = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"/var/run/delayed_job_worker.pid"</span>
   23   if File.exists?(pidfile)
   24     pid = open(pidfile).readlines.first.strip.to_i
   25     if running?(pid)
   26       puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"delayed_job_worker is running (<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{pid}</span>)"</span>
   27     else
   28       puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"delayed_job_worker is NOT running (<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{pid}</span>)"</span>
   29     end
   30   else
   31     puts <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"delayed_job_worker is NOT running (none)"</span>
   32   end
   33 else
   34   Daemons.run(File.dirname(__FILE__) + <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'/delayed_job_worker'</span>,
   35               <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:backtrace</span> =&gt; true,
   36               <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:log_output</span> =&gt; true,
   37               <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:dir</span> =&gt; File.dirname(__FILE__) + <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"/../tmp/pids"</span>,
   38               <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:dir_mode</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:normal</span>,
   39               <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:multiple</span> =&gt; false)
   40 end
</span>   41</pre>
The first script is merely the smallest amount of chrome required to start a worker. Note that I'm using [John Barnette's version of delayed_job](http://github.com/jbarnette/delayed_job/tree jbarnette's GitHub Repo) which gives us that nice little worker riff. The second script is essentially the `daemons` wrapper around my worker. For a little extra goodness I added my own "status" command which can be handy for debugging.

Getting those to work properly took a little bit of testing by hand. Fortunately, the entire solution is really a series of layers applied on top of each other. Once you convince yourself that an inner-layer is working correctly you can move on to build the outer layers.

The next step was to create a proper god configuration. I have more than one thing to monitor on my setup so I have a master god configuration that includes sub-configurations. My "main" configuration is a simple one-liner:
`God.load "/etc/god/*.god"`</pre>
My application-specific configuration looks like this (with a few edits for public consumption):
    1 <span class="variable variable_other variable_other_constant variable_other_constant_ruby">RAILS_ROOT = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"/var/www/moochbot/current"</span>
    2
    3 God::Contacts::Email.message_settings = {<span class="meta meta_syntax meta_syntax_ruby meta_syntax_ruby_start-block">
</span>    4   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># your config goes here
</span>    5 }
    6
    7 God::Contacts::Email.server_settings = {<span class="meta meta_syntax meta_syntax_ruby meta_syntax_ruby_start-block">
</span>    8   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># your config goes here
</span>    9 }
   10
   11 God.contact(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:email</span>) do |c|
   12   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># your config goes here
</span>   13 end</span></pre>
After setting up some default notification details, we get into the meat of defining our "watch":
   14
   15 God.watch do |w|
   16   w.name = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"delayed_job_worker"</span>
   17   w.interval = 10.seconds
   18   w.start = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{RAILS_ROOT}</span>/script/delayed_job_worker_control start -- production"</span>
   19   w.stop = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{RAILS_ROOT}</span>/script/delayed_job_worker_control stop"</span>
   20   w.restart = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{RAILS_ROOT}</span>/script/delayed_job_worker_control restart"</span>
   21   w.start_grace = 10.seconds
   22   w.restart_grace = 10.seconds
   23   w.pid_file = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{RAILS_ROOT}</span>/tmp/pids/delayed_job_worker.pid"</span>
   24
   25   w.uid = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"deploy"</span>
   26   w.gid = <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"root"</span>
   27   w.behavior(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:clean_pid_file</span>)</pre>
Next we need to define our transitions. My first attempt at this failed because I was missing these and my watched process was stuck in the "unmonitored" state. It's worth spending some time reading the docs on the [homepage](http://god.rubyforge.org/) since at first glance the configuration wasn't obvious to me.
   28
   29   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># determine the state on startup
</span>   30   w.transition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:init</span>, { true =&gt; <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:up</span>, false =&gt; <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:start</span> }) do |on|
   31     on.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:process_running</span>) do |c|
   32       c.running = true
   33     end
   34   end
   35
   36   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># determine when process has finished starting
</span>   37   w.transition([<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:start</span>, <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:restart</span>], <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:up</span>) do |on|
   38     on.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:process_running</span>) do |c|
   39       c.running = true
   40     end
   41
   42     <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># failsafe
</span>   43     on.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:tries</span>) do |c|
   44       c.times = 5
   45       c.transition = <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:start</span>
   46     end
   47   end
   48
   49   <span class="punctuation punctuation_definition punctuation_definition_comment punctuation_definition_comment_ruby"># start if process is not running
</span>   50   w.transition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:up</span>, <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:start</span>) do |on|
   51     on.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:process_exits</span>)
   52   end
   53</pre>
Finally I specify some resource-consumption boundaries to make sure that my little worker daemon doesn't take over my box:
   54   w.restart_if do |restart|
   55     restart.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:memory_usage</span>) do |c|
   56       c.above = 100.megabytes
   57       c.times = [3, 5]
   58     end
   59
   60     restart.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:cpu_usage</span>) do |c|
   61       c.above = 50.percent
   62       c.times = 5
   63     end
   64   end
   65
   66   w.lifecycle do |on|
   67     on.condition(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:flapping</span>) do |c|
   68       c.to_state = [<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:start</span>, <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:restart</span>]
   69       c.times = 5
   70       c.within = 5.minute
   71       c.transition = <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:unmonitored</span>
   72       c.retry_in = 10.minutes
   73       c.retry_times = 5
   74       c.retry_within = 2.hours
   75     end
   76   end
   77 end
   78</pre>
