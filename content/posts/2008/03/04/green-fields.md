----- 
kind: article
permalink: green-fields
created_at: 2008-03-04 15:44:07 -08:00
title: Green Fields
excerpt: ""
original_post_id: 66
tags: 
- geekery
toc: true
-----
Ahhh...a fresh new server install. It's like getting the first squeeze of toothpaste or the first scoop of peanut butter. It feels especially good because it's all yours. It brims with potential and has no marks of anyone else's will upon it. Setting a server for yourself is liberating because there are no constraints, no corporate policies to adhere to. Right or wrong, you get to call all the shots and take all the responsibility. You finally get to do what you always dremed of when that sneering, omnipotent system administrator show down all your ideas. Petty bureacracy will not stand in your way!

I'm waxing poetically because I just acquired my first [Slicehost](http://www.slicehost.com Slicehost) account for a side-project I'm working on. I've dozens upon dozens of Linux installs over the years, why should this be special? Perhaps it's worth a trip down memory-lane first...

If you discount those early years writing BASIC for the Apple II and TRS-80, I've been living Unix/Linux longer than I've been programming. In that time I've gotten rather particular about my distros and how I like to configure them. I first cut my teeth on HP-UX working at a wireless telco. Some co-workers there introduced me to Linux which like having an equivalent HP-UX-like interface on a 486 under my desk at home.

Like many, my first distro was the tower of floppies known as [Slackware](http://www.slackware.com/ Slackware). Ah, the good old days. When setting up X might have entailed destroying your monitor if you didn't get the parameters right. When I started doing actual development I moved over to [Red Hat](http://www.redhat.com/ Red Hat) because it was the most polished distro at the time. After that I had a brief flirtation with [SuSE](http://www.novell.com/linux/ SuSE), but found the configuration frustrating although I did have a major success getting dial-up internet working via number of arcane Hayes modem commands and some network scripts I found on the web.

Then I discovered [Mandrake](http://www.mandriva.com/ Now Mandriva), which I stuck with for a number of years. It was Red Hat-based, but had a much better installer and better package manager. In the end though, even the package management improvements could not overcome the inherent flaws of RPM. On countless occasions I would upgrade and the entire sweater of package dependencies would unravel and suddenly I need to upgrade to a new version of glibc just to get a decent RSS reader working in KDE. Ugh.

It was then that my most Linux-geeky friend turned me on to [Gentoo](http://www.gentoo.org/ Gentoo). You will learn more about linux kernels and configuration running Gentoo than you ever imagined. Mind you, I didn't get into Gentoo because I wanted to hyper-optimize my install of emacs. I switched because Gentoo's package management and configuration beat the snot out of Mandrake and I found the ebuild system rather elegant.

Unfortunately Gentoo took a tool on my patience with Linux on the desktop. Gentoo required far more care and feeding that I could give it. I spent far more time building and re-building my system than actually doing anything with it. I will point out though, that doing a bare-metal Gentoo install all the way to a full-blown desktop manager like KDE or Gnome has to be about the best hardware burn-in test there is.

So then I hopped on the [Ubuntu](http://www.ubuntu.com/ Ubuntu) band-wagon. While there are far too many ways to install packages (apt-get? dpkg? adept? wirble?), the Debian package management is a nice compromise between pre-built package systems like RPM and configurability (a la Gentoo). So that's what I've put on my new Slicehost host. It's well-documented, has tremendous community support behind and is much more up to date than it's older, conservative sibling, Debian.

So back to Slicehost. So far the experience has been tremendous. I would say that less than a minute elapsed between the time I decided to give them a credit card number and when I got a console login. They have several pre-built server images you can use to provision your slice. And now it's mine...all mine. I get to set it up just the way I like.

So what's in the soup, you may ask?

*Web Server:* [nginx](http://nginx.net/ nginx)

I've done a lot of Apache over the years and it's hard to overestimate the impact that it has had on the web. However, it's configuration has become nightmarish. In this case my needs are pretty narrow, so I'll go with something easier to work with. Plus it has a rad name.

*App Server:* [Rails!](http://www.rubyonrails.org/ Ruby on Rails)

I hope I never have to do Java-based web development again. As far as dynamic language go, I've thrown my hat in with Ruby rather than Python, although I hear great things about Django and I'd like to play with it. There are certainly other viable Ruby web frameworks (Merb, Camping, ...) but for this project I'm more interested in getting things done than learning a new web-stack.

*Database Server:* [MySQL](http://www.mysql.com/ MySQL)

I really really really wanted to do this with [Postgres](http://www.postgresql.org/ PostgreSQL) since it has just about the best command-line tool I've seen for any RDBMS. I also find the permission model in MySQL to be byzantine and difficult to debug. But alas, scaling out to multiple nodes with read/write master/slave and replication is much more do-able in MySQL than Postgres. There's a ton of existing literature out there on it and I've had [experience doing it](http://www.wetpaint.com WetPaint).

*Mail:* [Postfix](http://www.postfix.org/ Postfix)

Eventually this app will need to support incoming mail so simple MTA's like exim or esmtp weren't going to cut it. Since I'm deathly afraid of Sendmail, I figured I'd go with Postfix. This is probably the tool I know the least about right now, but it should be interesting to learn.

*Monitoring:* [monit](http://www.tildeslash.com/monit/ monit) or [god](http://god.rubyforge.com/ god)

I've used other commercial and open-source monitoring tools and they've all felt really heavy-weight and invasive. I don't so much mean "heavy-weight" in a CPU-sense, but in a process and procedure sense. Looking at the sample configurations for both god and monit put a smile on my face. god looks particularly interesting because it's in Ruby.

*Text Search:* [solr](http://lucene.apache.org/solr/ Solr), [ferret](http://ferret.davebalmain.com/trac Ferret), [sphinx](http://www.sphinxsearch.com/ Sphinx)

I've spent a little time looking at all of these solutions to supported inverted-index, full-text search support. I'm not 100% sure where (or if) this app will need full-text search so this area is a little bit hazy. I'm not committed to a particular implementation technology here (i.e. running Solr which is in Java is totally viable).

*Message Queue:* .....

I'm more sure that we'll eventually need to have asynchronous, queue-based work processing to handle things like image resizing and storage or document generation. Like the text search, running something like a Java-based message queue (like [ActiveMQ](http://activemq.apache.org/ Active MQ)) is entirely possible. A major piece of the selection criteria will be based on ease of integration.

So we'll see how this goes. I run my own Linux box at home to host this blog, a Subversion repo and couple of other things. It's nice to have a virtual equivalent sitting on much fatter pipes. I'm excited to see where this goes.

