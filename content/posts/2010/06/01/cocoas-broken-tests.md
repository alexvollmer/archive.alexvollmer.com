--- 
permalink: cocoas-broken-tests
title: Cocoa's Broken Tests
kind: article
tags: 
- cocoa
- TDD
created_at: 2010-06-01 11:20:51.429127 -07:00
---

I'm a long-time TDD kinda guy. I've had the great fortune of learning TDD
first-hand from [one of its greatest practitioners](http://en.wikipedia.org/wiki/Kent_Beck "Kent Beck - Wikipedia,the free encyclopedia")
and consider it one of the core disciplines of the way I go about my
profession. So when I first started doing Cocoa programming in earnest I was
shocked at the state of automated testing. Compared to my experiences on other
platforms, the tools are archaic and backwards. Moreover, the philosophy of
testing just doesn't seem to be baked into the DNA of the Cocoa community.
Nobody seems to be talking about it much. So I've just suffered with
old-fashioned head-against-wall development without the comforting support of
TDD. But I don't know how much longer I can take it. Am I crazy for wanting
TDD in Cocoa, or are the two simply incompatible?

Given the current state of affairs, it's not hard to see why there's a 
[bias against unit-testing](http://www.wilshipley.com/blog/2005/09/unit-testing-is-teh-suck-urr.html "Call Me Fishmeal.: Unit testing is teh suck, Urr.") 
in the Cocoa community. <sup><a href="#note1">1</a></sup> Unit-testing tools,
support and idioms within Cocoa are nowhere close to where they are in, say,
the Java, .Net, Ruby or Python communities. Compared to those environments,
unit-testing in Cocoa is just flat out *difficult*. I can easily understand
why a developer would conclude that the cost and effort of TDD outweighs the
benefits.

# The Dismal Science #

[<img src="http://farm1.static.flickr.com/178/399875844_16660fd4bf_m.jpg" class="left" alt="It's all about the money">](http://www.flickr.com/photos/janbrasna/399875844/ "Currencies on Flickr - Photo Sharing!")

Think of every "best practice" you've ever been exposed to in software. They
all come down to cost-benefit tradeoffs in the end. Up-front requirements
gathering? It's an attempt to manage change and indemnify certain parties when
things go awry. Iterative development? It's merely a short-term review process
to evaluate the cost of future development against opportunities in the
future. Automated testing? Computers (generally) work more cheaply than
humans, so invest in automating repeated tasks so that, over the long-haul,
more work is accomplished by cheaper workers. Hell, even the oft-cited goals
of code-reuse in object-oriented programming are economic ones. The list goes
on and on and on.

But, even as a long-time practitioner of test-driven development, I don't view
it as axiomatic. In this big, bad world of ours there have to be cases where
the economics simply don't add up, and it simply isn't *cost effective* to
build stuff using TDD.<sup><a href="#note2">2</a></sup> Returning to
Cocoa, I can see how developers come to the conclusion that TDD in Cocoa
simply isn't worth the price of admission.

So what makes TDD in Cocoa so expensive? Would things look different if we
could change the balance sheet?

# Bear-Skins & Stone Knives #

[<img src="http://farm1.static.flickr.com/169/368093250_8fa93d209a_m.jpg" class="right"/>](http://www.flickr.com/photos/g_originals/368093250/ "working hand on Flickr - Photo Sharing!")

Back in the day, [OCUnit](http://www.sente.ch/software/ocunit/ "Sen:te - OCUnit") 
was *the* xUnit toolkit of choice for Cocoa programming. In 2006
Apple put OCUnit right into Xcode and TDD received its first official
blessing. Now I don't have a beef in particular with OCUnit&mdash;it's
essentially a faithful implementation of xUnit patterns for Objective-C. What
is surprising is how weakly it's integrated with Xcode.

To unit-test, you have to create an entirely new target to execute your
unit-tests within. However, you don't run it like a normal executable. It's
baked into the build process for that target so that testing errors show up
just like build errors. I'll admit that's kind of cute and at least makes an
attempt to integrate TDD into the development process. But keeping unit-tests
as a separate target means more drop-down flipping in Xcode to go between
unit-testing and running my application. Oh and the bloody drop-downs in
Xcode&hellip;don't even get me started&hellip;

The other issue is debugging. If your unit-tests are failing, god help you if
you want to find out why. It takes [a lot of environment-variable hijinks](http://chanson.livejournal.com/120740.html "Chris Hanson - Xcode: Debugging Cocoa application unit tests") 
to be able to actually debug your unit-tests &mdash;something that is
significantly easier on every other platform I've ever worked on. All of this
leaves me with the distinctly uneasy feeling that Apple and the Cocoa community
at-large are merely paying lip-service to TDD.

Compare this to how JUnit is integrated into your standard Java IDE or
awesome Ruby testing tools like
[autotest](http://www.zenspider.com/ZSS/Products/ZenTest/ "ZenTest: Automated test scaffolding for Ruby"). 
These tools are so much more immediate and easier to reach for. Xcode looks
like it came from the era of the horse and buggy. These kind of tools and this
kind of support needs to be a part of the development environment in a
more natural way. Right now it's just a primitive, bolted-on afterthought. 
It's a wonder anyone has the patience to use it.

# A New Mentality #

Another challenge in Cocoa is figuring out where TDD fits in such a
framework-driven environment. To Apple's credit, the frameworks that Cocoa
provides do a pretty good job of "making the simple easy and the difficult
possible". However because Cocoa is *so* prescriptive, it can be difficult for
developers to stand back and figure out what to test. It's just so easy to
just let the idioms fly off the fingers, that testing them seems like a silly
exercise.

I think a common conclusion for the the would-be TDD'er is that they often
find their tests essentially repeating the implementation. These are most
expensive tests to write and maintain. Not only do you end up duplicating the
code (thus adding coupling and brittleness), but they also take up a lot of
time to write and can be pretty error-prone.

There has been a lot of thought about similar problems in other communities,
so why not steal these ideas and apply them to Cocoa development? Surely
strategies like [inversion of control](http://martinfowler.com/bliki/InversionOfControl.html "MF Bliki: InversionOfControl")
and [mocks](http://www.mulle-kybernetik.com/software/OCMock/ "Mulle kybernetiK -- OCMock")
would help make TDD in Cocoa an economic possibility. <sup><a href="#note3">3</a></sup>

The Cocoa community simply hasn't evolved a good set of testing practices the
way others have. Given the benefits I've seen in other environments, it's hard
for me to believe that Cocoa and Objective-C are exceptional in this regard. I
think that there are ways to do it, we just haven't discovered them yet. I
recall from my Java and Ruby days that testing idioms and practices evolved *a
lot* before we got somewhere reasonable. Simply put, the Cocoa world's
collective testing skills and knowledge lag severely behind a lot of other
languages.

<img class="right" src="/images/2010/06/kim-jong-il.jpg" alt="Kim Jong Il">

Facing this requires the Cocoa community to face its own isolationist and
exceptionalist attitudes. There's nothing so special about Cocoa and
Objective-C that *conceptually* invalidates the effectiveness of TDD. <sup><a
href="#note4">4</a></sup> Cocoa folks need to look outside of their walled
garden to see what others have done. This is not something I've seen much,
if any of, in the Cocoa community. Frankly, the dominant attitude seems to be
one of snobbery and elitism. It's an unfortunate attitude that holds us all back.

# Footnotes #

<p>
<a name="note1"></a>
1. Normally it wouldn't be fair to link to a five-year old post and call
it "representative" of a community's attitude, but I think for an insular
group like Cocoa-nerds, this is totally reasonable.
</p>

<p>
<a name="note2"></a>
2. I'm not saying that I, personally, have encountered such a thing, but
I don't think it's unreasonable to assume that the possibility <em>exists</em>.
</p>

<p>
<a name="note3"></a>
3. There is, of course, a pathological extreme to this line of thinking. That
extreme is called <a href="http://www.springsource.org/" title="SpringSource.org |">Spring</a>.
</p>
<p>
  
<a name="note4"></a>
4. OK, I'll admit that iPhone development is a little different because of
having to deal with the device vs. the simulator. Getting tests running on the
device is a non-trivial exercise. But I'm not convinced that unit-tests have
to run on the device. Yes, there are differences between the real and
simulated environments, but those differences should be accounted for in
<em>integration tests</em>&mdash;a topic I'm not going to address here.
</p>