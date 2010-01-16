----- 
permalink: meet-magit
layout: post
filters_pre: markdown
title: Meet Magit!
comments: 
- :author: Don
  :date: 2009-01-23 04:11:04 -08:00
  :body: |-
    That screencast was top notch.  Not too fast, not too slow.
    
    I use Vi and I still hung around just to get a look at how the other half lives.
  :url: ""
  :id: 
- :author: Daniel Colascione
  :date: 2010-01-01 18:35:10 -08:00
  :body: Nifty. I think you've finally convinced me to wrap myself around git.
  :url: ""
  :id: 
- :author: shyam
  :date: 2010-01-01 18:30:47 -08:00
  :body: |-
    Great screencast..
    What tool did you use to display the keychords?
    
    thanks
    Shyam
  :url: ""
  :id: 
- :author: alex
  :date: 2010-01-02 23:34:47 -08:00
  :body: I used iShowU for the screen captures. It has the option to capture keystrokes too.
  :url: http://livollmers.net
  :id: 
- :author: Marius
  :date: 2009-01-29 05:01:11 -08:00
  :body: |-
    Wow, excellent screencast!  Love it!  Thanks a lot for doing this.
    
    I noticed you had a bit of trouble with starting the rewrite, but it's actually quite simple (I hope): the idea is that you move point to a commit in the "Unpushed commits" section, and 'r s' will then use that commit as the default.  No need to use C-w.
    
    In the screencast, it's "master~4", and you could just have hit RET instead of pasting the SHA1.
    
    And, hmm, there seems to be a bug somewhere that makes the "Pending changes" section show nil instead of filenames.  Have to look at that...
  :url: http://zagadka.vm.bytemark.co.uk
  :id: 
- :author: alex
  :date: 2009-01-29 16:50:18 -08:00
  :body: "@Marius, glad you liked the screencast. Yeah I think after I finished the screencast I discovered just how smart magit is at figuring out where to start the rewrite. Oh well, the footage was in the can and I was ready to push it out the door.\r\n\
    \r\n\
    I'm curious why magit didn't simply embed the built-in \"git rebase -i\" workflow. Was it deemed to clunky and error-prone? For certain fixes I like the magit way of doing stuff, but sometimes I still fall back to my old CLI ways.\r\n\
    \r\n\
    Anyway, good to hear from another Vollmer (no relation\xE2\x80\xA6I think). If I can muster enough ELisp I might even send a patch or two. :-)\r\n\
    \r\n\
    Cheers, Alex"
  :url: http://livollmers.net
  :id: 
- :author: Marius
  :date: 2009-01-29 20:18:08 -08:00
  :body: |-
    alex, nice that you figured it out! :-)
    
    To be honest, I've never used git rebase -i myself.  It just didn't seem to be the right thing for a interactive git frontend to do.  If there is something that you miss from rebase -i, please tell me!
    
    John Wiegley added rebase -i to magit recently.  It's on 'E'.  So people really seem to want to use it... hmm.
    
    And, yeah, nice last name you have there! :-)  I think the name "Vollmer" comes from the river Volme which is pretty near where I was born:
    
    http://maps.google.com/maps?q=51.3925,7.440833
    
    http://en.wikipedia.org/wiki/Volme
  :url: http://zagadka.vm.bytemark.co.uk
  :id: 
- :author: alex
  :date: 2009-01-29 21:51:26 -08:00
  :body: "@Marius, thanks for the pointer to John's \"E\" patch. I've just pulled that latest bits and I'll give it a spin!"
  :url: http://livollmers.net
  :id: 
- :author: Gavin-John Noonan
  :date: 2009-01-30 11:33:03 -08:00
  :body: Great screencast, thanks I learned a lot :)
  :url: ""
  :id: 
- :author: Phil
  :date: 2009-01-19 01:50:19 -08:00
  :body: |-
    That was awesome. Love the reflog stuff; that was totally new to me. Dig the intro/outro riffs too.
    
    Just as a heads up: the "Meet Magit" link goes to vimeo.com, not to the screencast. Also: any chance you could link to the downloadable version? Having to register for a vimeo account just to grab it is kind of a bummer.
  :url: http://technomancy.us
  :id: 
- :author: alex
  :date: 2009-01-19 04:46:15 -08:00
  :body: "Thanks for catching the URL. I've updated it to point directly to the video. I'm surprised that you need an account to view the video\xE2\x80\x94I'll have to investigate more or cross-post the vid somewhere else. It's pretty big in its original form (~61MB).\r\n\
    \r\n\
    Glad you liked the tunes. I wanted to break the electronica-uber-alles sound of most screencasts. I'm not good enough to write real tunes so instead I write \"screencast music\". :-P\r\n\
    \r\n\
    \xE2\x80\x94Alex"
  :url: http://livollmers.net
  :id: 
- :author: Shane
  :date: 2009-07-02 09:50:27 -07:00
  :body: Wow, I just wanted to compliment you on your organization and presentation of the magit.  I followed along with some test repositories, and you have completely sold me on using magit.  I just have to figure out which key to bind it to.  Thank you for providing such a valuable screencast.
  :url: ""
  :id: 
excerpt: ""
date: 2009-01-18 20:58:06 -08:00
tags: Emacs
toc: true
-----
In the spirit of Geoffrey Grossenbach's [Meet Emacs Peepcode Screencast](http://peepcode.com/products/meet-emacs Meet Emacs), I put together my own humble little screencast this weekend on [magit](http://zagadka.vm.bytemark.co.uk/magit/magit.html Magit), a fantastic [git](http://git-scm.com Git) mode for Emacs.

<object width="400" height="300" data="http://vimeo.com/moogaloop.swf?clip_id=2871241&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" type="application/x-shockwave-flash"></object>
[Meet Magit](http://vimeo.com/2871241) from [Alex Vollmer](http://vimeo.com/alexvollmer) on [Vimeo](http://vimeo.com).

It's not meant to be an exhaustive survey of magit (check the [docs](http://zagadka.vm.bytemark.co.uk/magit/magit.html Magit User Manual) for all the details), but to show off some of the cool features this mode has. I found that spending just a little time with docs and learning this mode has already paid off in terms of increasing my productivity. Enjoy!
