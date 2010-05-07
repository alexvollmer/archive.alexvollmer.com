--- 
permalink: visual-affordance-in-a-touch-enabled-world
title: Visual Affordance in a Touch-Enabled World
kind: article
tags: 
- UX
- ipad
- iphone
created_at: 2010-05-07 10:46:39.422890 -07:00
---
*Ooooh*, you must be thinking, *what a posh title this is!* Okay, I'll admit
to copping a bit of a grandiose attitude when I came up with this, but hear
me out on this one.

<img src="/images/2010/05/mad-as-hell.jpg" class="left" alt="I was mad as hell
about a mouse and keyboard until I got an iPad!"/> The iPad has generated a
lot of criticism, scrutiny and analysis in recent months. The debate about the
ills and assets of the platform have, and will continue to be, debated
endlessly. I think one thing is pretty clear though&mdash; whether you like
Apple or not, whether you have an iPad or not, whether you think it's the most
awesome-est thing ever or not, it *is* revolutionary device. I don't mean in
terms of technical execution (yes the A6 chip is a marvel, the
power-consumption is amazing, blah blah blah). What I mean is that somebody
with Apple's clout finally stood up and threw away the last three decades of
user-interface paradigm *and they're laughing all the way to the bank doing
it*.

So, if you jettison The Way We've Always Done Things &trade;, what do you replace
it with? More importantly, which things from The Old Way are no longer
applicable to The New Way? This is a big topic that will take some time to
settle itself. We've had this CPU/mouse/keyboard setup for nearly thirty years
and we're *still* learning how to make it work for humans. I don't expect us
to settle the micro-debates of touch-interface design for quite a while, but
I do want drill down to something pretty specific.

Take a moment and ponder what the mouse *really is* in a graphic user
interface. It's a proxy. It's a loosely-connected device where movement and
gestures in one space are translated to movement and gestures in another
virtual space. To operate a mouse well, you have to perform constant mental
transform operations from the physical world to the world you are trying to
manipulate on the screen. The mouse is, effectively, a rather thick layer
between you and what you're trying to do.

# Exploiting the Gap

As we got better and better with the mouse <sup><a href="#note1">1</a></sup>
software started to exploit this gap between you and your machine. The first
place this showed up was in context menus. Once we already had to make a
mental stop on the train ride from our brain to the machine, why not make the
station more useful to folks? *Hell, let's put in some vending machines,
and perhaps some couches. We could even install* Wi-Fi *and people could
get* even more *productive.* Pile it on, pile it on.

Taken to an extreme, the mouse becomes the primary means by which we
interact with our machines. If you don't believe me, take a look at any
professional CAD workstation or that god-awful OpenOffice mouse.

<img src="/images/2010/05/context_menu.png" class="right" alt="The ubiquitous,
right-click-able, context menu"/> However these are extremes. There isn't
necessarily anything wrong with things like extra mice buttons or context
menus. But, in a world of touch, where the mental and physical distance
between our intentions and execution is much smaller, that thick
layer/opportunity is gone. *Context menus?* How the hell do I "right-touch"
the screen? *Mouse-overs?* Current touch interfaces don't have any proximity
sensors <sup><a href="#note2">2</a></sup>&mdash;either you touch something or
you don't. Yet these two very simple interaction models have become a crucial
part of the UI vocabulary we have all acquired over the years.

Think about a mouse-over. What is it there for? Mouse-overs offer two things:
a preview mechanism allowing you to learn more about something without having
to commit to it, and as a backup when a pictorial icon's meaning isn't clear
enough. We don't have these on the iPad <sup><a href="#note3">3</a></sup>. So
as an application designer and builder, how do we give people some notion of
what this thing can do? What kind of *affordance* can we offer?

# Spelunking

As you start using and learning an application, you generally have two 
questions:

  * What can this thing do?
  * How can I get this to do ______?


These are asked from two opposing angles, but both are about discovering the
capabilities of the software. When a user doesn't know what your application
can do, how can you build it in a way that they can discover it? An equally
important question is how can they explore your application without having to
commit to any action, particularly a destructive one?

<img src="/images/2010/05/nnw-ipad.png" class="left" alt="The 'next unread'
button in NNW"/> Let's look at one of my favorite iPad apps in particular,
[Net News Wire](http://netnewswireapp.com/ipad/ "NetNewsWire for iPad &laquo; NetNewsWire"). 
A nice feature of the application is the ability to progress through all of your unread items
with a single tap. When I first got the app, I *knew* that there had to be a
way to do this, but I couldn't find it. There *was* a mysterious-looking button
in the corner of the screen, but I wasn't sure what it was for. I mean, it
might do *anything*. How was I to know what would happen? It wasn't until I saw a 
[presentation by Brent Simmons and Brad Ellis on the design of NNW](http://seattlexcoders.org/2010/04/20/april-22-meeting---brent-simmons-and-brad-ellis.html
"Seattle Xcoders - April 22 Meeting - Brent Simmons and Brad Ellis") that I
actually found out where that button was. You can't really figure out what it
does unless you poke it. If you poke that button, there isn't a corresponding
"undo" button for that action.

That's not a dig against Brent and Brad, I think they did a wonderful job
with NNW. But it does highlight how difficult it can be to convey such a
feature to the user. I think it may be one of the biggest challenges on the
platform. How do we let the user know what our application can do?

Let's be honest here, if you're relying on documentation to teach the user
the basics, you've already lost the battle. Documentation is fine for really
deep, detailed information (see OmniGraffle on the iPad for an example). But
requiring a user to read the Owner's Manual before they can even use your
software went out about the same time as floppy disks. On the iPad an 
up-front documentation requirement is just laughable.

# Little Gets Big

One final thought is that although the iPhone and iPad obviously share the
same DNA, the difference in size makes this acutely problematic on the iPad.
On the iPhone you simply can't cram that much stuff into an application. Read
the iPhone Human Interface Guidelines and you'll quickly get the message that
on the iPhone, *less is more*. By and large, the best iPhone apps simply don't
have that many features integrated into them. This gives application designers
more freedom to make clear the intent of the features that are implemented.

On the iPad, it's a different story. There's so much more real-estate. Running
an iPhone application on the iPad is so laughably awkward that it starkly
highlights just how different the platforms really are. So now, as iPad
application builders, we have more space than ever. While we're freed from the
space constraints of the iPhone, we now have a challenge (and responsibility)
to use it effectively. It's not hard to imagine some developers embracing
these new green fields to produce some truly awful interfaces. Please, don't
be one of them.

## Tangents

<p> <a name="note1"></a>1. Make no mistake here, we've had to <em>train</em>
ourselves to use the mouse. Just watch your grandparents struggle with a 
mouse and you'll realize how un-intuitive the device really is.</p> 

<p><a name="note2"></a>2. I'm not even sure if they did that it would be such a good
idea. Requiring that level of fine-finger dexterity immediately makes such a
device exclusive to the young and facile.</p>

<p><a name="note3"></a>3. OK, there <em>is</em> a common trick
of touching and holding a hyperlink long enough to get a menu of
options.</p>
