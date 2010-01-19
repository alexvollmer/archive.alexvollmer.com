----- 
kind: article
permalink: asynchronous-mail-with-delayedjob-god-daemons
created_at: 2008-11-06 05:14:42 -08:00
title: Asynchronous Mail with DelayedJob, God &#38; Daemons
excerpt: ""
original_post_id: 134
tags: 
- ruby
- rails
toc: true
-----
Slowly but surely I've been pecking away at a little Rails-based side-project for the last four or five months. I'm _this close_ to flipping the _on_ switch&mdash;but in the meantime I've still got some "i"s to dot and "t"s to cross. One of those was switching from in-request mail delivery to asynchronous mail delivery. The app I've been working on involves two parties marching a particular transaction through a variety of state transitions, each of which usually sends an email to either or both parties.

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

<% highlight :ruby do %>
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    unless user.current_state == :latent or user.is_a?(Admin)
      UserNotifier.deliver_signup_notification(user)
    end
  end

  def after_save(user)
    if user.current_state == :promoted
      UserNotifier.deliver_signup(user)
    else
      UserNotifier.deliver_activation(user) if user.recently_activated?
    end
  end
end
<% end %>

Then the UserObserver was refactored like this:

<% highlight :ruby do %>
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    unless user.current_state == :latent or user.is_a?(Admin)
      Delayed::Job.enqueue(Jobs::UserNotifierSignupNotificationJob.new(user.id))
    end
  end

  def after_save(user)
    if user.current_state == :promoted
      Delayed::Job.enqueue(Jobs::UserNotifierSignupNotificationJob.new(user.id))
    else
      Delayed::Job.enqueue(Jobs::UserNotifierActivationJob.new(user.id)) if user.recently_activated?
    end
  end
end
<% end %>

With the following workers (abridged):

<% highlight :ruby do %>
module Jobs
  class UserNotifierDisconnectJob < Struct.new(:user_id)
    def perform
      UserNotifier.deliver_disconnect(user_id)
    end
  end

  class UserNotifierResetPasswordJob < Struct.new(:user)
    def perform
      UserNotifier.deliver_reset_password(user)
    end
  end

  class UserNotifierSignupNotificationJob < Struct.new(:user)
    def perform
      UserNotifier.deliver_signup_notification(user)
    end
  end

  class UserNotifierStartDisconnectJob < Struct.new(:user_id)
    def perform
      UserNotifier.deliver_start_disconnect(user_id)
    end
  end
end
<% end %>

## Testing

Prior to switching to asynchronous processing, mail delivery was triggered within my models, either via Observers or as Procs attached to state transitions (I'm using the `acts_as_state_machine` plugin). Therefore my tests had loads of assertions that various state changes in the model resulted in direct email delivery. In the asynchronous model of course, that changes slightly. While the state change ultimately ends in mail delivery, it only happens indirectly.

So here I had a big pile of tests that asserted that poking the model in certain ways resulted in a mail delivery. In my unit-tests I really just wanted to test the interaction between the models and `DelayedJob`. After all, if something went hay-wire during mail delivery the culprit would likely be my new worker classes, _not_ my model.

However, for my integration tests I still wanted to keep the assertions about actual mail delivery since that was an important part of the stories. I could easily do this by monkey-patching the `DelayedJob::enqueue` method to call the worker's `perform` method directly. In my unit-tests I monkey-patched the `DelayedJob::enqueue` method to work more like a mock object which added some inquiry methods to check that it had been invoked correctly.

In isolation this worked great, but running all the tests together resulted in a number of random failures. I've run into this enough times to recognize that some tests were somehow poisoning the run-time environment for the others. It turns out that my two approaches were incompatible with each other unless I was very diligent about cleaning everything up properly. I will admit with red-faced shame that I punted. I did the lamest thing one could possibly do and redefined `DelayedJob::enqueue` for _all_ of my tests and kept all of my original assertions. I'm not proud of it, but it does work.
## Running in Production

The next trick was getting this all running in a production environment and I needed to figure out how one or more workers would be started and kept running. While it's great to have this decoupled from the Rails environment, it means that it's a separate process that needs to be managed.

My solution was to use the `daemons` gem to create a couple of scripts. Then I used Tom Preston-Warner's `god`, to monitor my process. The scripts look like this:

<% highlight :ruby do %>
#!/usr/bin/env ruby

unless ARGV.size == 1
  $stderr.puts "USAGE: #{0} [environment]"
  exit 1
end

RAILS_ENV = ARGV.first
require File.dirname(__FILE__) + '/../config/environment'

Delayed::Worker.new.start

e "control" script looks like this:

#!/usr/bin/env ruby

require "rubygems"
require "daemons"

def running?(pid)
  # Check if process is in existence
  # The simplest way to do this is to send signal '0'
  # (which is a single system call) that doesn't actually
  # send a signal
  begin
    Process.kill(0, pid)
    return true
  rescue Errno::ESRCH
    return false
  rescue ::Exception   # for example on EPERM (process exists but does not belong to us)
    return true
  end
end

if ARGV.size == 1 and ARGV.first == "status"
  pidfile = "/var/run/delayed_job_worker.pid"
  if File.exists?(pidfile)
    pid = open(pidfile).readlines.first.strip.to_i
    if running?(pid)
      puts "delayed_job_worker is running (#{pid})"
    else
      puts "delayed_job_worker is NOT running (#{pid})"
    end
  else
    puts "delayed_job_worker is NOT running (none)"
  end
else
  Daemons.run(File.dirname(__FILE__) + '/delayed_job_worker',
              :backtrace => true,
              :log_output => true,
              :dir => File.dirname(__FILE__) + "/../tmp/pids",
              :dir_mode => :normal,
              :multiple => false)
end
<% end %>

The first script is merely the smallest amount of chrome required to start a worker. Note that I'm using [John Barnette's version of delayed_job](http://github.com/jbarnette/delayed_job/tree jbarnette's GitHub Repo) which gives us that nice little worker riff. The second script is essentially the `daemons` wrapper around my worker. For a little extra goodness I added my own "status" command which can be handy for debugging.

Getting those to work properly took a little bit of testing by hand. Fortunately, the entire solution is really a series of layers applied on top of each other. Once you convince yourself that an inner-layer is working correctly you can move on to build the outer layers.

The next step was to create a proper god configuration. I have more than one thing to monitor on my setup so I have a master god configuration that includes sub-configurations. My "main" configuration is a simple one-liner:
`God.load "/etc/god/*.god"`
My application-specific configuration looks like this (with a few edits for public consumption):

<% highlight :ruby do %>
RAILS_ROOT = "/var/www/moochbot/current"

God::Contacts::Email.message_settings = {
  # your config goes here
}

God::Contacts::Email.server_settings = {
  # your config goes here
}

God.contact(:email) do |c|
  # your config goes here
end
<% end %>

After setting up some default notification details, we get into the meat of defining our "watch":

<% highlight :ruby do %>
God.watch do |w|
  w.name = "delayed_job_worker"
  w.interval = 10.seconds
  w.start = "#{RAILS_ROOT}/script/delayed_job_worker_control start -- production"
  w.stop = "#{RAILS_ROOT}/script/delayed_job_worker_control stop"
  w.restart = "#{RAILS_ROOT}/script/delayed_job_worker_control restart"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{RAILS_ROOT}/tmp/pids/delayed_job_worker.pid"

  w.uid = "deploy"
  w.gid = "root"
  w.behavior(:clean_pid_file)
<% end %>

Next we need to define our transitions. My first attempt at this failed because I was missing these and my watched process was stuck in the "unmonitored" state. It's worth spending some time reading the docs on the [homepage](http://god.rubyforge.org/) since at first glance the configuration wasn't obvious to me.

<% highlight :ruby do %>
  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_exits)
  end
<% end %>

Finally I specify some resource-consumption boundaries to make sure that my little worker daemon doesn't take over my box:

<% highlight :ruby do %>
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = [3, 5]
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
<% end %>
