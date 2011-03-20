--- 
sha1: e2d321e7c4bc1eac2d456753405bdea6f7339950
kind: article
permalink: design-pressures-of-mock-objects
created_at: 2010-07-25 16:41:25 -07:00
title: Design Pressures of Mock Objects
tags: 
- TDD
--- 

[Last Thursday](http://seattlexcoders.org/2010/07/13/july-22-eastside-meeting---alex-vollmer-on-ocmock.html "Seattle Xcoders - July 22 Eastside Meeting - Alex Vollmer on OCMock") 
I gave a presentation to the Eastside Xcoders on the topic
of [OCMock](http://www.mulle-kybernetik.com/software/OCMock/ "Mulle kybernetiK -- OCMock")
and, more generally, the role of mock objects in test-driven development. One
of the great things about the process of teaching (or presenting) is getting
a chance to really solidify the topic which you're sharing with others.
The process of putting [this presentation](https://docs.google.com/fileview?id=0BzuECX7-PruNYjEwOWU4ZTUtODhhOC00ZTlmLWE1NzQtNGQzMjJkM2FiMzA1&amp;hl=en)
together really clarified some things that I intuitively understood, but 
couldn't necessarily articulate very well about testing and design.

One of the biggest "a-ha!" moments was triggered by creating my favorite slide
in the whole presentation, which came near the end after we'd covered all the
ins and outs of OCMock.

<img src="/images/2010/07/abstract.png" title="Where I'm willing to mock, I'm willing to abstract"/>

This phrase came to me as I thought about the "design pressures" that TDD
often brings to your code. To me, these pressures are one of most important
(yet subtle) forces that TDD brings to bear. TDD practitioners often refer
to TDD as a feedback mechanism. To me, this notion of where to draw the lines
of responsibility became really clear when I thought about the first place
I often do it&mdash;in my tests.

Let me explain what I mean by that phrase. First, I should say that I tend to
bring in mock objects in a limited set of circumstances. It's not the first
tool I reach for in my unit-tests. I don't like tests that simply re-assert
the implementation as I think it gives you a false sense of security. The
times when I *will* use mocks are:

  * When I'm replacing third-party collaborators that I don't control
  * When creating a stub would just obscure the test
  * Writing single use-case test stubs. I'll wait until I get three of them
    before I factor out a common stub.
  * When I need to test for side-effects (e.g. logging or caching)

The first reason is the primary motivation I'd have to consider a layer of
abstraction. First, because (obviously) the third-party is under someone
else's control, but also because I usually want to simplify a more
fully-featured and general API to something more specific to my domain. By
encapsulating the details of something like GameKit into a little façade
class, I've built a nice little box around it that doesn't leak into other
classes.

So maybe it's not an earth-shattering realization. Maybe it's just that I
finally have a clearer articulation of the idea in my head. Like I said,
it's amazing what you learn when you teach it to someone else.
