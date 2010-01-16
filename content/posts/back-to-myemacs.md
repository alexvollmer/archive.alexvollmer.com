----- 
permalink: back-to-myemacs
layout: post
filters_pre: markdown
title: Back To My...Emacs
comments: 
- :author: Phil
  :date: 2008-10-14 04:47:05 -07:00
  :body: |-
    I think in the end the only thing that matters in the editor wars is that you're extending Emacs in the exact same way that the original authors were when they were writing it.
    
    If you have to use some tacked-on "plugin mechanism" to customize it, then you're going to be limited by whatever the author of the plugin mechanism thought you would want to do with it. But if you're using the exact same tools as the original authors were using, you can bet they put all their effort into making that a seamless, powerful experience, and that you'll be able to access things on an entirely new level.
    
    Incidentally, this is the only reason anyone uses Firefox even when Webkit is an obviously superior engine. Even with all the wretched mistakes they made with the extension system, you're writing JS, which is what much of Firefox is written in.
  :url: http://technomancy.us
  :id: 
- :author: alex
  :date: 2008-10-08 15:13:42 -07:00
  :body: "Andreas, thanks for the pointer. Before I saw your comment I did some poking around at the various snippet packages for Emacs and came across yasnippet\xE2\x80\x94which is fantastic!\r\n\
    \r\n\
    I also found a script hanging off of the Google Code page for yasnippet to convert TextMate snippets to yasnippet. It's not 100%, but I can hand-tweak the rest.\r\n\
    \r\n\
    I love the design of it too: just write template files in a directory with a name matching the template you want to type. Very nice."
  :url: http://livollmers.net
  :id: 
- :author: Andreas
  :date: 2008-10-08 10:34:26 -07:00
  :body: |-
    Have you had a look at yasnippet? It's got a pretty handy set of snippets for more than just ruby/rails and seems pretty easy to expand with new ones. 
    
    As for using Emacs for Java, maybe when Ola Bini's Antlr-ELisp project is done...
  :url: http://andreasjacobsen.com
  :id: 
- :author: Haulyn Jason
  :date: 2008-10-07 06:34:32 -07:00
  :body: |-
    Ok, emacs works well for my C project, Python project, but I always can not understand how to use it for Java Project, especially I am a Java programmer. 
    
    Do you have any suggestions to use emacs  as Java develop tool? How to compile a class just with related classes , without compiling full project? What about web project? it's more complex than common jar project.
    
    Thanks!
  :url: http://www.openmotel.cn
  :id: 
- :author: alex
  :date: 2008-10-07 15:22:36 -07:00
  :body: |-
    Right, I guess that's kind of my point. Any non-trivial Java project requires a certain amount of "infrastructure" that exceeds what I'm willing to setup in Emacs. I'm sure it can be done, I'd just rather use other tools at that point.
    
    Apparently there is some pretty good Ant integration for Java projects in compile-mode so that might work for you if you're already an Ant-based project. I haven't used it (I despise Ant) so I can't speak for how well it works.
    
    Good luck,
    Alex
  :url: http://livollmers.net
  :id: 
- :author: Charles Magid
  :date: 2008-11-02 04:07:01 -08:00
  :body: I have used Eclipse/MyEclipseIDE for many years.  I have used Emacs for over 30.  I agree Eclipse* is a very good tool for Java.  Mainly because of the refactorings, the ease of importing or referencing existing projects and the ability to view over-ridden methods in class hierarchies.  However there are still some Java refactorings I need to use emacs to realize.   Of course Emacs requires a module like http://www.xref.sk/xrefactory-java/main.html to do meaningful Java refactorings.  But XRefactory works very well.  I only wish that as a new java programmer I stuck with XRefactory instead of going to Eclipse
  :url: ""
  :id: 
- :author: this is totally gonna work&#8230; &raquo; Blog Archive &raquo; Burning My Ships
  :date: 2008-12-21 03:41:29 -08:00
  :body: "[...] license for TextMate which has definitely been the editor-of-choice for lots of Rubyists. However, as I blogged about before, it&#8217;s now time to get off the TM-train and switch (back) to [...]"
  :url: http://livollmers.net/index.php/2008/12/20/burning-my-ships/
  :id: 
- :author: Daniel Fischer, your friendly Los Angeles geek - Got Fisch? &raquo; Aquamacs on OSX for Ruby on Rails Development? Yep, we&#8217;re going Emacs status.
  :date: 2008-12-16 12:59:29 -08:00
  :body: "[...] my point has been proven, and guess what the latest trend is? Every popular Rubyist in the world is starting to use Emacs, and even more apparent is the fact that most of them are on a Mac. I find it [...]"
  :url: http://www.danielfischer.com/2008/12/16/emacs-on-osx-for-ruby-on-rails-development/
  :id: 
- :author: Dima
  :date: 2008-10-30 07:22:33 -07:00
  :body: alex, isn't C++ statically-typed? or C++ developers don't need all these refactorings? I never write any C++-code what's why I'm asking..
  :url: ""
  :id: 
- :author: alex
  :date: 2008-10-30 16:10:26 -07:00
  :body: |-
    I can't speak authoritatively on C++ since I ran away from it screaming when I was first exposed to it. I would guess that an approach like the one Eclipse takes would work for C++. In fact, I know that there's some C/C++ workbench for Eclipse.
    
    It may not have caught because it doesn't work well, or simply because of cultural inertia within the community. Most folks simply don't change their toolset that often; and certainly not something as crucial as their editor.
  :url: http://livollmers.net
  :id: 
- :author: Dima
  :date: 2008-10-29 11:27:31 -07:00
  :body: |-
    I've read a lot of blogs in which people say how emacs is great for coding C, C++, Ruby, etc.
    Why it is not so great for coding Java?
  :url: ""
  :id: 
- :author: alex
  :date: 2008-10-29 15:46:57 -07:00
  :body: |-
    @Dima, it's not that Emacs is necessarily bad at handling Java projects, just that I find the specialized IDEs for Java (e.g. Eclipse) so much more productive. Where a tool like Eclipse shines is the fact that it doesn't treat code like a text file, but instead as an always-parsed syntax tree. With a statically-typed language like Java this allows you to do some powerful manipulation of your code. The refactoring tool in Eclipse is enough for me to forgo doing Java in Emacs.
    
    This is largely a matter of taste though. I don't have a problem keeping the idiosyncrasies of various tools in my head so I don't need to be a one-tool-to-rule-them-all kind of guy.
    
    I've invested quite a bit of time and effort in Eclipse such that I am simply more productive with that tool than I would be in any other for Java. However I find it pretty lacking as a general-purpose editor. When I started doing Ruby I tried using Eclipse and gave up after a few weeks.
    
    As always, YMMV and one should always choose the right tool for the job.
  :url: http://livollmers.net
  :id: 
- :author: Seth Mason
  :date: 2008-10-12 05:07:57 -07:00
  :body: Give nXML mode a whirl if you are editing HTML.  Combined with yasnippet, it makes emacs a great HTML editor.
  :url: http://www.sethmason.com
  :id: 
- :author: xah lee
  :date: 2009-01-27 10:42:28 -08:00
  :body: |-
    hi,
    
    if you haven't seen already, you might checkout my elisp tutorial.
    http://xahlee.org/emacs/emacs.html
  :url: http://xahlee.org/
  :id: 
- :author: alex
  :date: 2009-01-27 16:26:57 -08:00
  :body: |-
    @xahlee, thanks for the link that looks like a great site. I just added it to my delicious bookmarks under "emacs".
    
    Cheers,
    
    Alex
  :url: http://livollmers.net
  :id: 
excerpt: ""
date: 2008-10-07 03:36:51 -07:00
tags: Programming
toc: true
-----
<p>Emacs. Love it or hate it, it is undeniably a monument of software engineering. At best it's an amazingly customizable work environment that can be shaped to your every whim. At worst it's a giant time-sink where productivity is skewered by endless "fiddling".

<p>Since switching to the Mac over a year and half ago, I've used [TextMate](http://macromates.com/ TextMate) as my non-Java editor. TextMate is _great_ text editor. It's relatively simple to extend, has a very active community and only takes a little investment before a user gets productive. But I'll admit that in the last month or so my eyes started wandering from TextMate&#8212;I felt like maybe I was ready to go back to Emacs.

<p>Perhaps it's worth a little history first. Back in the Dark Ages of Java Development (anyone remember Gnu Server Pages?), I was a pretty hard-core XEmacs guy for my Java dev. At the time Java IDEs were painful exercises in waiting and crash-recovery. JBuilder, early NetBeans, Visual Cafe were all valiant attempts but terrible failures. So I rode with XEmacs until the IDEs caught up.

<p>Then one day I met Eclipse. Unlike any other Java editing tool, Eclipse was much more than a text-editor. Rather than treating your code like text to be manipulated, Eclipse actually _understood your code_. This allows you to think in terms of manipulating Java syntax and symbols instead of simple text tokens and lines. For a static language like Java this is incredibly powerful since you can determine up-front all of the possible things you might want to write. This is why a full-on "intelli-sense" feature for dynamic languages is hard to do as well in static, compiled languages.

<p>I spent the next five years learning just about every nook and cranny of Eclipse and would put my raw Java-writing skills up against anyone. Even now, I still use Eclipse for Java and I can't imagine going back to a plain text-editor&#8212;even a souped-up hot-rod like Emacs. This says less about the deficiencies of any text editors as it does about the requirements for developing in Java. Writing Java without all of the code-completion and refactoring tools an IDE like Eclipse has would simply exceed my pain threshold. So while Eclipse has become quite bloated lately and, when coupled with tools like Maven, is an exercise machine-servitude, it will be a cold day in hell before I give it up for Java. (NB: I plan on giving up Java-dev first.)

<p>Now I'm writing a lot more non-Java than I did a year ago. That's what brought me to TextMate. The integration for Ruby, HTML, CSS, JavaScript and shell was outstanding. I bought the [TextMate book](http://www.amazon.com/TextMate-Power-Editing-Pragmatic-Programmers/dp/097873923X%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D097873923X) and was on my way to editor ass-kicking.

<p>Unlike my Java days, now I identify myself less with a single language. Back in the day I was a Java Programmer&#8482; dad-gummit. It was The One Language To Rule Them All and it served me well. Do you remember those days? Yeah, that was also the time when certified Oracle dudes were writing their own checks. But as time went on, I noticed that those Oracle guys pretty much knew how to do one thing and if and when the Day of Database Reckoning ever came, these guys were gonna be left standing in the cold wondering what the hell happened. I think that day has come and those dudes are becoming the equivalent of COBOL programmers&#8212;relegated to propping up legacy systems and talking wistfully about "the good ol' days".

<p>So it got me to thinking about what I needed to do to survive in this business. Clearly I was going to have to evolve. So I started looking around for some inspiration and came across Ruby. Right now it's my favorite language, but it's not the only game in town. Ruby borrows a lot of features from other languages and a lot of other Ruby-ists are also spending time with other languages like Haskell, Erlang, io, and Lisp just to get exposure to other ideas. Moving away from a single-language focus to broader interests has been an important part of moving from rookie to journeyman. Evolve or die, right?

<p>So how does this relate to Emacs? Well, like a lot of folks, I've been interested in learning more about functional programming. The problem is, I simply haven't had the time to crack open the [Erlang book](http://www.amazon.com/Programming-Erlang-Software-Concurrent-World/dp/193435600X%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D193435600X) and bend my brain in new ways. Don't get me wrong, it's on the list, but it's going to be a while before I get to it. So I was eager to dip my toe in FP without a major commitment. Enter ELisp.

<p>Before I dropped out of college, my brief career in academic computer science was spent with Scheme. My time in school didn't end well and so I've associated Scheme (and by extension, Lisp) with that particularly unpleasant time in my life. I've only recently overcome the shakes when I see `car` or `cdr`. But a little time and some professional success has healed old wounds. In my first go-round with Emacs, I was really just using it as a power-editor. The internals of Emacs pretty much escaped me and in my mind there was a pretty major barrier between an ELisp user and an ELisp _writer._

<p>This time I've made a concentrated effort to learn more about how Emacs works. I've been racing through the [O'Reilly Emacs book](http://www.amazon.com/Learning-Elliot-Raymond-Rosenblatt-Cameron/dp/B001E3G45M%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB001E3G45M) and this time _it makes sense_. I don't know what the hang-up was before, but this time it all seems so logical! The entire editor is simply a collection of ELisp functions and variables built on top of other functions and variables. It's all self-documented and incredibly dynamic. Wanna try something out? Just put a little Lisp in your `*scratch*` buffer and evaluate that sucker. Hell, in Eclipse I'd have to download the freakin' source and compile it or swim in XML writing an extension. That's _incredibly_ powerful&#8212;the barrier to "trying stuff out" is mind-bogglingly low.

<p>So while I've definitely take a short-term hit by trading in TextMate for Emacs, but I'm reaching productivity-parity pretty quickly. A couple of modes/libraries I've found that I've really liked are:
*  [Steve Yegge's JS2 mode](http://code.google.com/p/js2-mode/ js2 Mode)
*  [Rinari,](http://rinari.rubyforge.org/ Rinari Is Not a Rails IDE) for Rails
*  [Org-mode](http://orgmode.org/ Org-mode)
*  [Magit](http://zagadka.vm.bytemark.co.uk/magit/magit.html Magit) for Git integration

<p>I plan on spending some quality time with some of the various snippets libraries too to port over some of the templates that TextMate uses. For something like Rails development, which is about the most idiomatic programming I can imagine, having short-hand snippets is a major productivity boost.

<p>So why go through this? After all, switching editors can be like converting from Catholicism to Judaism for some. Well, I think I'm doing this because:
*  I've already overcome the initial steep-learning curve of basic editing in Emacs
*  I get a nice, no-commitment introduction to functional programming
*  I get a great environment to learn new stuff in
*  With a little effort and a willingness to learn, I can make this sucker to _anything_
*  Emacs has quite a track-record. It's close association with Unix is no accident.
*  Emacs customization is _easy_ to write and a snap to track in SCM

<p>I can't say that I'll use Emacs for _everything_. I'm getting into Cocoa development too and it looks like doing that outside of XCode is a fool's errand. But that's okay. I don't need a single tool to do everything for me, just a handful of tools that help me get a variety of things done. That said, I'm pretty sure I'll be solving a lot more problems in Emacs than I ever did in any other single tool.


