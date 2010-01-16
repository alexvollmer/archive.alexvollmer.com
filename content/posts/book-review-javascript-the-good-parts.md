----- 
permalink: book-review-javascript-the-good-parts
layout: post
filters_pre: markdown
title: "Book Review: \"JavaScript: The Good Parts\""
comments: 
- :author: Phil
  :date: 2008-08-18 23:53:27 -07:00
  :body: |-
    &gt; Is the prototype approach really all that innovative?
    
    In the words of Brendan Eich: "What is good is not original; what is original is not good." That said, JS took the prototype-based OOP approach from the Self language, so it's not really very original. Whether it's worth learning an entirely new approach and discarding what you know about classical OOP is debatable, but it's certainly mind-expanding.
  :url: http://technomancy.us
  :id: 
- :author: alex
  :date: 2008-08-19 00:08:01 -07:00
  :body: Agreed. It's certainly worth considering simply to avoid getting into intellectual ruts and living off of truisms.
  :url: http://livollmers.net
  :id: 
- :author: James
  :date: 2008-09-19 06:48:07 -07:00
  :body: Hi, I found your blog on this new directory of WordPress Blogs at blackhatbootcamp.com/listofwordpressblogs.  I dont know how your blog came up, must have been a typo, i duno.  Anyways, I just clicked it and here I am.  Your blog looks good.  Have a nice day.  James.
  :url: ""
  :id: 
excerpt: ""
date: 2008-08-15 03:41:45 -07:00
tags: Book review
toc: true
-----
<p>![DSC_0204.NEF](http://livollmers.net/wp-content/uploads/2008/08/dsc-0204.jpg)

<p>It takes a brave author to give a book this title and keep it at 150 pages. The number of jokes about the proportionality of the "good parts" to the size of the book are endless. Be that as it may, when I saw this book at the [Powell's](http://www.powells.com/) stand at [RailsConf '08](http://en.oreilly.com/rails2008), I figured anything written by Crockford on the subject of JavaScript was probably worth taking a look at.
![](http://ecx.images-amazon.com/images/I/51Mb1xCr7CL._SL160_.jpg)
<p>Given the diminutive nature of the the book, I suspect the author was attempting to do for JavaScript what Kernighan and Richie did for C with their book. I found an abused first edition copy of that C book and it taught me more about C than any other book. It is a triumph of restrained, focused technical writing (for other examples check out any of Kent Beck's books). At times I felt that some chapters in "The Good Parts" were superfluous, but I imagine that they were included for completeness if nothing else. For example, the second-longest chapter in the book is about the grammar of the language. While important, it seems disproportionately large to rest of the contents.

<p>If you have any exposure to JavaScript a good part of this book will be a review for you. However, there are three chapters worth reading for any JavaScript programmer. Chapter 3, _Objects_, discusses the properties of objects in JavaScript and covers everything from enumeration, to prototypes to attributes. Do you know why property enumeration is usually worthless as a debug tool? That's because of the prototype mechanism. If you use `typeof` filters and the `hasOwnProperty` method, you can significantly cut down the properties you dump on an object. I never knew that before.

<p>Chapter 4, _Functions_, is the real money-maker of the book. This is the chapter that I put the most post-its in and will certainly be one I'll have to revisit. Here Crockford goes into the different ways functions can be invoked and what the consequences are of each invocation style. There is a _lot_ of good functional programming material here. He also discusses how Functions are intimately tied to Objects. Take heed, thar be dragons!

<p>Chapter 5, _Inheritance_, closes the loop on Functions and Objects. It explains the important differences between JavaScripts prototype-based inheritance model and the class-based model used in many other popular object-oriented languages. Like the previous chapter, this will be one that I'm sure I'll have to re-read in the future.

<p>It's taken a long time, but JavaScript seems to finally be growing up a bit. Given how truly awful it was to use it in the Early Days on more than one browser, it's a bit surprising that it has come to dominate the web landscape. Now it seems to be finally getting (begrudging) respect from the rest of the software community. Unfortunately to be effective, you really need to learn some of the deep voodoo that, to me, is a bit counterintuitive. Is the prototype approach really all that innovative? I'm not sure. Arguing that it's better than inheritance is like saying that something is better than poking yourself in the eyes with a sharp stick&#8212;faint praise indeed. But I do love passing around functions as objects with complete abandon. When I finally grokked this part of JavaScript, things really clicked for me.

<p>Is this book a must-read? No, probably not. If you're doing any serious JavaScript in the browser you're probably using one of the popular JavaScript frameworks out there that hide some of the yucky details of Function/Object interaction. But, lacking a decent language spec (and the ECMA spec sucks rocks), it's not a bad resource. It certainly won't take up much space in your bookshelf.

<p>2.5 stars out of 5.

