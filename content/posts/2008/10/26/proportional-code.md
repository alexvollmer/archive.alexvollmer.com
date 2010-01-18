----- 
permalink: proportional-code
title: Proportional Code
date: 2008-10-26 23:53:14 -07:00
tags:
- software
- philosophy
excerpt: ""
original_post_id: 118
toc: true
-----
Few things are less sexy than command-line parsing. It is one of the most mundane tasks a programmer has to execute in their career. But, it surprises just how much code is required to do basic command-line parsing in a lot of languages, including Ruby. So I got to thinking, _why does this bug me so much?_ I think the answer is that requiring so much code for such a relatively trivial task violates my sense of _proportionality_ in the code. I hate having to say so much more about this teeny little task than I do about the "theme" of my code. I think it distorts the narrative of the code.

Let's say that the processing of writing your program is like launching spacecraft. Ideally you would like to get from launch to cruising around in space as quickly as possible. The Star Trek universe solves this quite elegantly with the transporter. We don't put you in a box and launch it, we break your atoms apart and transmit them to another location! That's pretty cool, but maybe we're just not quite that cool yet. Another solution is one proffered by the Star Wars universe. A ship like the Millenium Falcon can leave just about any planetary atmosphere any time it damn well pleases without the use of special equipment. It just flies away. Not bad.

![Atlantis (STS-125)](http://farm4.static.flickr.com/3173/2958037544_26e7973f17_m.jpg)
However, here on earth, our primitive space craft need a tremendous amount of disposable apparatus to reach escape-velocity. The proportion of useful vehicle (the shuttle) to the orbit-busting mechanism (the rocket boosters and fuel tanks) is a staggering 5.4:1 (based on liftoff weight).

Command-line parsing in code exhibits a similar disproportion. The interesting part of your app isn't the command-line parsing. Why should it take up such a disproportionate amount of space in your code? Those boosters quickly become "space-junk", once the launch vehicle has left Earth; expensive trash that is never to be used again.

Space-junk is dangerous for the next guy that wants to launch into space. It's also dangerous for the folks on the ground as it may decide to come crashing back down to earth. And those boosters have also been responsible for one of the worst disasters in NASA's history. If we could only get rid of those damn things the whole space program just might be a little better off. Unfortunately physics, and our current space-flight capabilities currently require them.

But our code is a different story. We don't have such physical barriers that handicap us. Any barriers we run into are usually of our own making. So why not try to reduce those as much as possible? Why say in more code, what you could say in less? Wouldn't that cut down on bugs? Wouldn't that ease the burden of maintenance? Wouldn't that reduce the amount of information overhead you have to maintain each time you revisit that code?

Command-line parsing is a stupid, menial task that should require very little attention. By extension, it should only be given a stupid, menial amount of code to make it work. We have big ideas! They shouldn't get bogged down by handling command-line options!

This is why I wrote [Clip](https://github.com/alexvollmer/clip/tree Clip on GitHub). Clip is an expression of the need to make the simple things simple, but no simpler. If you have modest command-line parsing needs, Clip rewards you with minimal investment. If you need something trickier, Clip allows you to say a little more to it and gain more benefits from it. You get to decide how much you want to engage&mdash;not the library.

This is one of the things I like about Ruby. The language is extremely flexible which gives me a lot of ways to "pack" ideas into code in a variety of ways. Having more than one way to do things isn't all that useful by itself. But it's _essential_ when you want to write _expressive_ code. Things like object literals, or one-line control-structure alternatives help me keep the lines of code proportional to the ideas they express.

This is also something I find challenging to do in Java. In languages like Java, even just creating a collection of objects requires quite a bit of code:

<% highlight :java do %>
import java.util.*;

public class Designer {
  public void makeItWork(List<Trash> trash) {
    // today's challenge: convert trash to wearable garments
    List<Garment> garments = new ArrayList<Garment>(trash.size());
    for (Trash t : trash) {
      Garment g = new Garment(t.getName());
      garments.add(g);
    }

    submitToJudges(garments);
  }
}
<% end %>

In Java we often solve this by pushing all of that code into a private method that is named something meaningful. This works pretty well, but does tend to result in an explosion of "helper methods". Sometimes folks take the "cheap" route and simply prefix these riffs with explanatory comments like "convert each Trash into a Garment". I'm not a real big fan of this. Generally I don't care about the object conversion in the first place because the rest of the code is presumably doing something interesting with the _Garments_ and I don't give a damn about the _Trash_.

So let's look at it in Ruby:

<% highlight :ruby do %>
class Designer
  def make_it_work(trash)
    submit_to_judges(trash.map { |t| Garment.new(t.name) })
  end
end
<% end %>

By my count there are five lines in the Java example (including the comment) just to convert trash to garments. In contrast I boiled that down to one line in Ruby. OK I could have done this in two lines if you think that's too much of a long-train. But I think there are couple of important points here:
*  The importance of the concept being expressed diminishes from left to right
*  The attention-span of the reader diminishes from top to bottom

The Ruby example beats Java on both counts. I don't waste a lot of the reader's attention span up-front on book-keeping details (in the vertical space) and I state the important thing I'm trying do (submit my top Foos) quickly (on the left). The details of _which _Garments I'm dealing with are merely a qualification of _what_ I'm trying to do.

How you handle these two dimensions is greatly affected by both the language you use and the APIs you deal with. This is one of the reasons that I do _not_ find the use of scripting languages for Java's Swing API all that compelling. Scripting languages like JRuby or Jython help me with the horizontal space, but don't do a damn thing for the vertical requirements. With an awful API like Swing I have to say a _lot_ of words to make it go, regardless of the language I do it with.

Getting back to my dumb example, being on such a small scale this may not seem like a large impact. But multiplied several times over to match the size of most projects, this kind savings can really pile up. The difference in the amount of code required by these two approaches is manifested in a savings in cognitive investment required to grok these projects. This is the very _essence_ of maintainability and sustainability. Anytime you can do more with less, you come out ahead.

At great peril to my own geek cred, I will say that this is why I find _The Lord of the Rings_ to be such an awful piece of writing. It is so full of peripheral and non-essential information that finding the real story or characters requires extraordinary patience and concentration on the part of the reader. If Tolkien had been more concerned with the story and less with "world-building" I'll bet he could have gotten that story boiled down to a single book.

Now I realize that a lot of folks _love_ the Tolkien books for the very reasons I criticize it. That's fine, _that_ is an argument about aesthetics, not facts. However I would strongly argue that "world-building" in your code is a _bad idea_. I think you're much more likely to build a decent piece of software if you pack your ideas tightly like a William Gibson novel than as a sprawling "trilogy" of epic code. Go ahead, prove me wrong. I double dog-dare ya.

OK, so by this point any credibility I may have had is gone. Look at the size of a post about saying more with less. In the hope that you might be lazy and like to skip to the end:
*Do as much as you can&hellip;with as little as possible.*
