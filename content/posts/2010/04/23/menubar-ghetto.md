--- 
permalink: menubar-ghetto
title: Menu Bar Ghetto
kind: article
tags: 
- mac
- UX
created_at: 2010-04-23 08:49:57.966616 -07:00
toc: true
---
The menu bar has become a dumping ground. With each new application I install
another grubby child is dropped off at the doorstep of the orphanage known
as the OS X menu bar. This has simply got to stop.

<img src="/images/2010/04/status-bar.png"/>

Just look at that. Do you think that fits on anything but a large display? I
can't even see most of these icons on my built-in MacBook display. Only
humble little Finder, with its spartan set of menus, yields enough real
estate to display all of these items.

Sadly, I had gotten into the habit of knowing which applications hid status
bar items from me and would automatically switch to Finder just to reveal
them. It was the classic mistake we all make of giving in to bad design
instead of addressing the problem.

So I waged a small holy-war this morning to kick out all but the essential
applications from my status bar. I feel a little better that I've reclaimed
my territory, but can't help but feel frustrated that I'll have to do it
again soon. Why? Because, somehow, application developers got it in their
heads that they *all* have to have menu bar items.

I want this to stop. Right now. Please. Do it for the children.

I can't help but think that this reflects a dangerous attitude underlying a
lot of applications. Stop for a moment and think of the reasons why an
application provides a menu bar item. Menu bar items exist for applications
running in the background. These come in two flavors: applications with no
other user interface (like a window or a preference pane), and ones that do.I
don't have much of a beef for the ones that can only provide a menu bar item
as their sole interaction mechanism. It's the applications that *do* have a
main UI that I want to give a stern talking-to.

In a windowing system users get to choose what they focus on (save for a few
cases with alerts and modal dialogs and such). Applications are supposed to do
the bidding of the user. When I switch away from application XYZ, it means I
have something more important I need to do. Having that application pop back
in my face drives me nuts. It drives everyone nuts. I think most folks would
agree that this is a Bad Experience. 

But some applications want to keep your attention. So they compromise by
creating a little persistent bit of goo and sticking it in the menu bar.
Because these apps are *so fabulous*, how could you not want them around all the
time?

The best menu bar items are ones that provide the essential capabilities of
the application *and* give you a quick way to expand to the full application.
I run iStat menus because it gives me a lot of information in the small
space it takes up. Why is my machine so slow? Ah, the CPUs are pegged. Why
are they pegged? Well, just click the menu item and see that application XYZ
is taking up 90% of my cycles. It's a great example progressive disclosure.

Some applications like [iShowU](http://www.shinywhitebox.com/home/home.html
"iShowU") or [Little Snapper](http://www.realmacsoftware.com/littlesnapper/
"Little Snapper") provide a menu bar item because they need to get out of your
way. You don't want to screen capture the screen capture tool itself, right?
For these kinds of apps that provide functionality that spans multiple
applications, I think this is okay.

What I can't stand are applications that provide a menu bar item, then keep it
there after I've quit the application. [Evernote](http://www.evernote.com
"Evernote") is a good example of this. You have to *really* go out of your way
to make Evernote not do this. Worse yet, its default behavior is to install
itself as a startup item so that it's sitting there in your menu bar until you
take time out of your busy day to turn it off. Boo. Hiss.

I like Evernote quite a bit, but I get the impression its creators think it's
so special that it deserves to be in your face, all the time. It's like that
annoying guy you got stuck talking to at the company party that you can't rid
yourself of. Go away.

The worst case of this is VMWare. I can't, for the life of me, figure out how
to disable VMWare's menu bar item. For folks that need to run a lot of non-Mac
apps I can see the advantage. The Unity stuff in VMWare is pretty freaking
cool. But if you're *not* one of those people, it's pretty rude to have this
whole other application-launcher sitting there, taking up space, that you only
occasionally use. Shame on you VMWare. I'm happy to pay for a license because
I think it's a great product, but that doesn't mean I want to see your
goddamned menu item in my status bar all the time.

So if you're building a Mac application and considering a menu bar item,
please consider the following advice. If you're building a background utility
with no other UI, think hard about how much the user needs to interact with
your application. Is it something they need to fiddle with more than once a
session? If not, try to make a Preference Pane and leave it at that. If it's
something the user is going to use a lot, or displays some kind of realtime
information (à la iStat menus) then adding to the menu bar is okay.

If you're building an application with a main UI component, think long and
hard about the necessity of menu bar item. If it can integrate with other
applications (like Little Snapper) there's a reasonable case to be made for
providing a menu bar item. Even then, you should consider providing a Services
menu item and/or a global keyboard shortcut. This is an especially good idea
if your application only provides one or two actions that users can take. It's
hard to justify a two-item menu bar item, so sometimes you see applications
put other non-essential items in there like Preferences or an About dialog.
Don't do this.

For these sorts of applications, the menu bar item should *always* be
optional. The app should still be able to do what it needs to without having
that menu bar item enabled. Also, leave it off by default and make it easy for
the user to turn it on. Make it an opt-in feature rather than an opt-out
feature. As much as I love Tweetie, the opt-out nature of its menu bar item is
the kind of stuff that drives me nuts. The option is enabled (or not
disabled?) and the language is confusing. Worse yet, it doesn't take effect
until you restart the application.

<img src="/images/2010/04/tweetie-prefs.png"/>

Finally, unless you have some kind of special papal dispensation, never, ever,
ever keep your menu bar item running when the application is gone. OK,
technically if there's a menu bar item the application is still running, but
that's a distinction that user's don't care about (nor should they have to).

There's been a long, ongoing debate about the necessity of optimizing the
performance of applications. As horsepower has increased, programmers have
been afforded some laziness in optimizing their applications. I only have a
problem with that in extreme cases because hardware power has increased at
such an impressive rate. However, our displays aren't growing at the same
rate. We need to treat that screen real estate as precious. The menu bar is a
great place to put global, cross-application functionality, but there's only
so much space for all of these applications. Think long and hard about the
necessity of taking up that space and always put the power in the users' hands
to choose.
