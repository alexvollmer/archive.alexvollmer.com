----- 
sha1: 45827e6c90aca7939451c0a847ac0030b89034db
kind: article
permalink: the-ache-of-swing-programming
created_at: 2007-09-07 15:45:42 -07:00
title: The Ache of Swing Programming
excerpt: ""
original_post_id: 30
tags: 
- java
toc: true
-----
As I type this post, I have to fight every urge to grab my hands in agony and cry out like a hurt child. This hand-ache is not unfamiliar. I realize that my hands have _always_ felt like this anytime I've had to do some [Swing](http://java.sun.com/products/jfc/tsc/index.html Java SE Desktop Articles) programming.

Why does it have to be like this? Because Swing requires just so much damn typing. My lord my fingers are buzzing with a solid week of keyboard contact. Swing is a tremendously verbose API&mdash;it simply requires a lot of letters to make it go. I consider myself a pretty advanced Eclipse user who takes advantage of most of its features to let it write my code for me, but my hands still hurt. I shudder at the thought of having to code Swing like I did "back in the day" with good old [Emacs](http://www.gnu.org/software/emacs/ "GNU Emacs - GNU Project - Free Software Foundation").

I find it interesting that demonstrations of Java code being called from a scripting language ([JRuby](http://jruby.codehaus.org/ JRuby - Home), [Jython](http://www.jython.org/), [Groovy](http://groovy.codehaus.org/ Groovy - Home), etc.) always include an example of rapid GUI prototyping with the Swing API. I say this because I think that while these scripting languages really beat Java in terseness, they don't really help much when dealing with Swing. In other words, a scripting language may reduce the length of a line I might otherwise write in Java, but the sheer number _lines_ I have to write is about the same. I don't think this is an indictment of scripting-wrapped-around-Java so much as what it says about the Swing API itself.

The other reason Swing wears your hands out is that it is not a well-designed, intuitive API. You spend a lot of time experimenting to figure out the magic recipe that will make your app work. Despite the verbosity of the [API docs](http://java.sun.com/javase/6/docs/technotes/guides/swing JDK 6 Swing (Java Foundation Classes (JFC))-related APIs & Developer Guides -- from Sun Microsystems) and various [Swing Tutorials](http://java.sun.com/docs/books/tutorial/uiswing/ Trail: Creating a GUI with JFC/Swing (The Java™ Tutorials)), I find that I still have to play (nee fight) with the API to figure out how to get it to work.

Take, for example the juggernaut that is the `JTable`. I wanted to have a `JTable` instance update with new rows when the underlying model changed. I wanted to set a custom renderer for one of the cells to display a URI as a hyperlink and allow the user to click it and view the URI in their browser (via `Desktop.browse(URI)`). OK, let's see here, let's go to our IDE and put the cursor next to our `JTable` instance variable and trigger the autocomplete drop-down. Hmmm, what can we use here? Oh here, we go, `setDefaultCellRenderer`, hey that looks good. OK, let's see, takes a `Class` and `TableCellRenderer`, yeah that looks good. Alright, let's fire it up&hellip;wait for the VM to get warmed up&hellip;load our data model&hellip;click the table and&hellip;aw hell, a `NullPointerException` during table painting. OK, let's go through the stack trace and look for one of my classes in there. I must be passing some null reference around. Hmmm, no&hellip;actually these are all Swing and internal classes. Great, now what?

Eventually I worked out that the problem is that despite the plethora of options for cell rendering, only one combination worked in my particular case. Only by trying every square in the Swing-API-matrix was I able to stumble upon a combination that worked correctly. Now I will admit that my Swing skills are a bit rusty and that I have to blame myself to a certain extent. However my big beef with Swing API is that it gives you so many ways to hurt yourself in spectacular and unintended ways. Looking at the API and its base-classes with 200+ methods, it's pretty clear that the API was developed from the implementation on up. Any design with regard to usability seems to be an afterthought.

I feel like whenever I've had to work on a Swing project, I have to change my whole approach. It's much more difficult for me to cull decent unit-tests out of the code. In part this is because it's so easy to embed testable code inside of un-testable code (think of event handlers), but also because UI testing is difficult. Even the various UI-oriented unit-testing tools don't really enable easier unit-testing so much as make it barely possible.

Despite all of this and the persistent ache in my digits, I can't say I didn't have any fun with this. I've always said that programming Swing is a bit like riding a mo-ped, it's fun for a bit but you would never want your friends to catch you doing it.
