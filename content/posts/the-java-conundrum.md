----- 
permalink: the-java-conundrum
layout: post
filters_pre: markdown
title: The Java Conundrum
comments: 
- :author: Does a language complicate your thinking? &laquo; Wherever I go, there I am
  :date: 2008-01-06 07:00:24 -08:00
  :body: "[...] dangerous, I found myself reading the latest Yegge novella and nodding my head. Alex Vollmer says it much better than I ever could: when a language is by definition bloated and inconsistent, it becomes harder and harder to be [...]"
  :url: http://arunxjacob.wordpress.com/2008/01/06/does-a-language-complicate-your-thinking/
  :id: 
- :author: alex
  :date: 2008-01-11 23:06:38 -08:00
  :body: |-
    Hmmmm, a list of "timeless" tools eh? Boy, I'm pretty sure that it's a short list. I'd definitely put emacs on there. Not because I use emacs for everything, but that it is a very flexible tool that works for a number of tasks. I'm sure that vim can do everything I do with emacs, I just happen to know emacs better. 
    
    Out side of that? I dunno...the shell? A few handy Unix commands? I mean I use nearly <i>none</i> of the tools I considered essential a few years ago.
    
    My point is that we're evolving and that it's possible that Java is becoming a less compelling solution to a number of problems as time goes by. I'm in love with Ruby right now, but I'm not dumb enough to think that I will <i>always</i> be using it. I'm not so interested in arguing about "the best" as much as finding the "more better" tool.
  :url: http://livollmers.net
  :id: 
- :author: Pat
  :date: 2008-01-11 21:44:57 -08:00
  :body: Alex.  Linux is a <i>religion</i>, not a tool!  Shame on you.  I want a list of your "timeless" must have tools!  Yes.  Programming languages are evolving, and none are perfect.  Yes.  A developer has to be aware of shifts in technology.  Professionally, a developer who has an engineering hat on, though, must also be mindful of when one tool is "good enough" for a particular job.  Pure technologists can continue to contribute to the debate over who's winning the war and the adoption rate of the leader.
  :url: ""
  :id: 
- :author: Phil
  :date: 2007-12-31 00:23:43 -08:00
  :body: |-
    &gt; Who would assume that any one tool/language/operating system has really got it right?
    
    Outside of Lisp/Smalltalk, you mean? =) I'm still waiting for a language that beats state-of-the-1960s-art.
  :url: http://technomancy.us
  :id: 
excerpt: ""
date: 2007-12-30 20:41:22 -08:00
tags: ""
toc: true
-----
<p>[Steve Yegge’s latest blog post](http://steve-yegge.blogspot.com/2007/12/codes-worst-enemy.html Stevey's Blog Rants: Code's Worst Enemy) was one that really struck a chord with me personally. I think he hit most of the nail right on the head in describing a common frustration with the Java language. It seems like every attempt to refine the language ends up as some controversial, inelegant hack that often reduces the readability of the code. The same day I read that post I came across [Josh Bloch’s presentation on Java closures](http://www.javac.info/bloch-closures-controversy.ppt Josh's PowerPoint Presentation). This was my first introduction to closures in Java-land and my first reaction was one of horror. This is supposed to enhance the expressiveness of the language? Sheesh, not as far as I can tell&#8230;


<p>Steve talks about the size of your Java codebase and just touches on IDEs, but I&#8217;d like to explore that aspect a bit. I&#8217;ve been a dedicated Eclipse user for about five years. Before that I used NetBeans and before that Emacs. These days I think the three major IDEs (Eclipse, NetBeans and IntelliJ) are essentially equivalent. They all have great code completion, integrated refactoring tools and built-in unit-testing support. By the time I switched to Eclipse my Java projects were reaching a magnitude that _required_ these sorts of tools. Switching back to plain old Emacs would have been possible, but a very counter-productive move. In essence, our projects mandate a certain set of tools in order to achieve some minimal baseline of productivity. There is no going back.


<p>Maybe this isn&#8217;t a bad thing. I&#8217;ve certainly dismissed my fair share of kooks who live by the &#8220;desert-island&#8221; coding theory where any developer should be prepared to have to work on thirty-year old servers with no UI system and where only `edlin` is available. That&#8217;s nuts. We _have_ evolved. BUT&#8230;is Java _requiring_ additional evolution that we otherwise wouldn&#8217;t need? Like Steve&#8217;s point about dependency injection, are we creating new sacred cows whose existence is justified only by the requirements of working with Java?


<p>I&#8217;m a big fan of dependency injection, but when I started working more seriously in Ruby I realized that it was a concept that had much less worth simply because of how the language works. So while the concepts behind projects like Spring are admirable, the amount of knowledge required to use these tools (all in the name of finding a shortcut around a bunch of manual work), seems to exceed any benefit as far as I can see. It seems that the evolution of Java has required additional complexity to manage the previous rounds of complexity we were trying to get around in the first place. A conundrum indeed.


<p>Java seems to be suffering from a serious case of feature-envy and lacks a firm hand to guide its future. Java 5 brought a few helpful (and sometimes controversial) features, but since then I&#8217;ve started to tune Java out. The JCP process seems to have devolved into feature-addition-by-committee process where, if any sort of quorum can be achieved, any features can make it as a JSR. As other languages have gained popularity and offered developers alternatives in expression, many have tried to evolve Java to &#8220;keep up&#8221;. I would put forth that this is both a disservice to the language and its users.


<p>Right, wrong or indifferent, Java has a point of view of how the world should work. Everything in Java is an `Object` and every object is of some defined `Class`. There are almost no literal expressions in Java so just about everything you want to do in Java must be carries out as methods invoked on objects. Many of the new language extensions seem counter to this original design and show all the signs of a conceptual impedance mismatch. Extensions like closures are trying to act like anonymous functions where we don&#8217;t really care about the type. Oh, except that we do. Well, but we don&#8217;t want to. Yeah, but we have to. 


<p>As a result, Java has evolved from a relatively simple and consistent language (at least compared to C++) to one that requires programmers to understand Java's entire [Tale of Gilgamesh](http://eawc.evansville.edu/essays/brown.htm EAWC Essay: Storytelling, the Meaning of Life, and The Epic of 
Gilgamesh) before they can be trusted with the language. I can&#8217;t imagine how they teach how Java 6 works in introductory programming classes. Instructors must be faced with innumerable choices where they trade completeness for clarity. Given the tome-like size of the [Generics FAQ](http://www.angelikalanger.com/GenericsFAQ/JavaGenericsFAQ.html AngelikaLanger.com - Java Generics FAQs - Frequently Asked Questions - Angelika Langer Training/Consulting), I can&#8217;t see how anyone could feel comfortable sicking this subject on the young tender minds of new programming students.


<p>It just seems to me that whatever stewards there are for the Java language have been fairly hands-off in setting or restricting the direction of the language. Perhaps Java would be better off accepting the fact that it will, at best, play the role of an equal among a number of peers and that it would best sustain itself by adhering to its core design principles and allow other languages to evolve their features to meet needs that Java can&#8217;t adequately satisfy.


<p>To paraphrase [Chico Escuela](http://www.baseball-reference.com/bullpen/Chico_Escuela Chico Escuela - BR Bullpen), &#8220;Java has been bery bery good to me.&#8221; Java has sustained a nearly decade-long career in a profession I love. For me though, I&#8217;m pretty sure that my current gig will be my last Java gig. My attention to and love for the language has waned. I&#8217;ve found alternatives that work better for the majority of problems I have to deal with. In short, the thrill is gone.


<p>There are few tools in my toolbox that are timeless must-haves. I am a self-described &#8220;tool whore&#8221;. If I can find a tool that gives me a significant amount of productivity gain (one that exceeds the investment effort), I&#8217;ll gladly switch to them. I was a long-time dedicated Linux user, but switched to Mac when I found that the effort to maintain a Linux laptop exceeded the energy I was willing to put into it. I haven&#8217;t rejected Linux, I&#8217;ve simply put it in a place in my technical life where I can best take advantage of it.


<p>I feel the same way about languages. While I have called myself a &#8220;Java developer&#8221; for a number of years, I&#8217;ve come to learn that I&#8217;m really a software engineer whose tool of late has been Java. Given the constant change within this field, it is simply self-destructive to assume that I can sustain a long-term career with the same set of tools and skills. I firmly believe that a good developer has to be aware of what else is going on in the world and must constantly evaluate and adapt new technologies and approaches. In short, we must evolve or face irrelevancy and, ultimately, professional extinction.


<p>Today I&#8217;m doing more Ruby and I hope to be doing more Ruby professionally for a number of years. But I expect that in a few years some new language will emerge that will address the future shortcomings of Ruby. Who would assume that any one tool/language/operating system has really got it right? It&#8217;s _never_ happened in the history of technology. At best, we&#8217;ve had systems that did better than their competitors. I&#8217;ll even go so far as to say that I don&#8217;t dismiss the possibility that Microsoft may come up with an operating system or development environment that beats the alternatives. It would require quite a lot to overcome my personal biases, but I won&#8217;t say it couldn&#8217;t happen.
