----- 
permalink: back-to-myemacs
title: Back To My...Emacs
date: 2008-10-07 03:36:51 -07:00
tags:
- emacs
- geekery
excerpt: ""
original_post_id: 117
toc: true
-----
Emacs. Love it or hate it, it is undeniably a monument of software engineering. At best it's an amazingly customizable work environment that can be shaped to your every whim. At worst it's a giant time-sink where productivity is skewered by endless "fiddling".

Since switching to the Mac over a year and half ago, I've used [TextMate](http://macromates.com/ TextMate) as my non-Java editor. TextMate is _great_ text editor. It's relatively simple to extend, has a very active community and only takes a little investment before a user gets productive. But I'll admit that in the last month or so my eyes started wandering from TextMate&#8212;I felt like maybe I was ready to go back to Emacs.

Perhaps it's worth a little history first. Back in the Dark Ages of Java Development (anyone remember Gnu Server Pages?), I was a pretty hard-core XEmacs guy for my Java dev. At the time Java IDEs were painful exercises in waiting and crash-recovery. JBuilder, early NetBeans, Visual Cafe were all valiant attempts but terrible failures. So I rode with XEmacs until the IDEs caught up.

Then one day I met Eclipse. Unlike any other Java editing tool, Eclipse was much more than a text-editor. Rather than treating your code like text to be manipulated, Eclipse actually _understood your code_. This allows you to think in terms of manipulating Java syntax and symbols instead of simple text tokens and lines. For a static language like Java this is incredibly powerful since you can determine up-front all of the possible things you might want to write. This is why a full-on "intelli-sense" feature for dynamic languages is hard to do as well in static, compiled languages.

I spent the next five years learning just about every nook and cranny of Eclipse and would put my raw Java-writing skills up against anyone. Even now, I still use Eclipse for Java and I can't imagine going back to a plain text-editor&#8212;even a souped-up hot-rod like Emacs. This says less about the deficiencies of any text editors as it does about the requirements for developing in Java. Writing Java without all of the code-completion and refactoring tools an IDE like Eclipse has would simply exceed my pain threshold. So while Eclipse has become quite bloated lately and, when coupled with tools like Maven, is an exercise machine-servitude, it will be a cold day in hell before I give it up for Java. (NB: I plan on giving up Java-dev first.)

Now I'm writing a lot more non-Java than I did a year ago. That's what brought me to TextMate. The integration for Ruby, HTML, CSS, JavaScript and shell was outstanding. I bought the [TextMate book](http://www.amazon.com/TextMate-Power-Editing-Pragmatic-Programmers/dp/097873923X%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D097873923X) and was on my way to editor ass-kicking.

Unlike my Java days, now I identify myself less with a single language. Back in the day I was a Java Programmer&#8482; dad-gummit. It was The One Language To Rule Them All and it served me well. Do you remember those days? Yeah, that was also the time when certified Oracle dudes were writing their own checks. But as time went on, I noticed that those Oracle guys pretty much knew how to do one thing and if and when the Day of Database Reckoning ever came, these guys were gonna be left standing in the cold wondering what the hell happened. I think that day has come and those dudes are becoming the equivalent of COBOL programmers&#8212;relegated to propping up legacy systems and talking wistfully about "the good ol' days".

So it got me to thinking about what I needed to do to survive in this business. Clearly I was going to have to evolve. So I started looking around for some inspiration and came across Ruby. Right now it's my favorite language, but it's not the only game in town. Ruby borrows a lot of features from other languages and a lot of other Ruby-ists are also spending time with other languages like Haskell, Erlang, io, and Lisp just to get exposure to other ideas. Moving away from a single-language focus to broader interests has been an important part of moving from rookie to journeyman. Evolve or die, right?

So how does this relate to Emacs? Well, like a lot of folks, I've been interested in learning more about functional programming. The problem is, I simply haven't had the time to crack open the [Erlang book](http://www.amazon.com/Programming-Erlang-Software-Concurrent-World/dp/193435600X%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D193435600X) and bend my brain in new ways. Don't get me wrong, it's on the list, but it's going to be a while before I get to it. So I was eager to dip my toe in FP without a major commitment. Enter ELisp.

Before I dropped out of college, my brief career in academic computer science was spent with Scheme. My time in school didn't end well and so I've associated Scheme (and by extension, Lisp) with that particularly unpleasant time in my life. I've only recently overcome the shakes when I see `car` or `cdr`. But a little time and some professional success has healed old wounds. In my first go-round with Emacs, I was really just using it as a power-editor. The internals of Emacs pretty much escaped me and in my mind there was a pretty major barrier between an ELisp user and an ELisp _writer._

This time I've made a concentrated effort to learn more about how Emacs works. I've been racing through the [O'Reilly Emacs book](http://www.amazon.com/Learning-Elliot-Raymond-Rosenblatt-Cameron/dp/B001E3G45M%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB001E3G45M) and this time _it makes sense_. I don't know what the hang-up was before, but this time it all seems so logical! The entire editor is simply a collection of ELisp functions and variables built on top of other functions and variables. It's all self-documented and incredibly dynamic. Wanna try something out? Just put a little Lisp in your `*scratch*` buffer and evaluate that sucker. Hell, in Eclipse I'd have to download the freakin' source and compile it or swim in XML writing an extension. That's _incredibly_ powerful&#8212;the barrier to "trying stuff out" is mind-bogglingly low.

So while I've definitely take a short-term hit by trading in TextMate for Emacs, but I'm reaching productivity-parity pretty quickly. A couple of modes/libraries I've found that I've really liked are:
*  [Steve Yegge's JS2 mode](http://code.google.com/p/js2-mode/ js2 Mode)
*  [Rinari,](http://rinari.rubyforge.org/ Rinari Is Not a Rails IDE) for Rails
*  [Org-mode](http://orgmode.org/ Org-mode)
*  [Magit](http://zagadka.vm.bytemark.co.uk/magit/magit.html Magit) for Git integration

I plan on spending some quality time with some of the various snippets libraries too to port over some of the templates that TextMate uses. For something like Rails development, which is about the most idiomatic programming I can imagine, having short-hand snippets is a major productivity boost.

So why go through this? After all, switching editors can be like converting from Catholicism to Judaism for some. Well, I think I'm doing this because:
*  I've already overcome the initial steep-learning curve of basic editing in Emacs
*  I get a nice, no-commitment introduction to functional programming
*  I get a great environment to learn new stuff in
*  With a little effort and a willingness to learn, I can make this sucker to _anything_
*  Emacs has quite a track-record. It's close association with Unix is no accident.
*  Emacs customization is _easy_ to write and a snap to track in SCM

I can't say that I'll use Emacs for _everything_. I'm getting into Cocoa development too and it looks like doing that outside of XCode is a fool's errand. But that's okay. I don't need a single tool to do everything for me, just a handful of tools that help me get a variety of things done. That said, I'm pretty sure I'll be solving a lot more problems in Emacs than I ever did in any other single tool.


