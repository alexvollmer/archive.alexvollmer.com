----- 
permalink: a-philosophy-of-testing
layout: post
filters_pre: markdown
title: A Philosophy of Testing
comments: 
- :author: alex
  :date: 2008-10-03 03:30:16 -07:00
  :body: |-
    Here are a couple of posts that got me thinking:
    
    <a href="http://steve-yegge.blogspot.com/2006/09/good-agile-bad-agile_27.html" rel="nofollow">Steve Yegge's "Good Agile, Bad Agile"</a> and <a href="http://railspikes.com/2008/7/11/testing-is-overrated" rel="nofollow">Luke Francl's "Testing is Overrated"</a>. Obviously these posts aren't exactly new, but I think the backlash has been rolling for a couple of years now. A quick Google search for "agile backlash" returns an awful of results.
    
    To be fair though, I don't have a particular number or curve to point to. It's more a "sense" I get, especially in conversations I have with people. Given the high profile "Agile" has had over the last few years, it was inevitable that we'd get some sort of counter-reaction.
  :url: http://livollmers.net
  :id: 
- :author: User Primary &raquo; Blog Archive &raquo; Friday Links
  :date: 2008-10-03 16:06:45 -07:00
  :body: "[...] I enjoyed reading Alex&#8217;s brant (a blog post in the key of rant) A Philosophy of Testing. [...]"
  :url: http://userprimary.net/user/2008/10/03/friday-links/
  :id: 
- :author: Phil
  :date: 2008-10-03 16:28:04 -07:00
  :body: |-
    &gt; The second-generation acolytes turned a very pragmatic set of principles and practices into an esoteric scripture that could never meet the needs of reality.
    
    I think I first realized this when I blogged about how my freelancing team was handling communication with the client, and I got comments like, "Oh, that's 'Add a Customer to the Team' and 'Release Regularly' according to the Extreme Programming Pocket Reference." Uh... who cares what the terms are--I just call it useful common sense. And why oh why is there a pocket reference for something like that?
    
    http://technomancy.us/77
    
    http://oreilly.com/catalog/9780596004859/
  :url: http://technomancy.us
  :id: 
- :author: greebs
  :date: 2008-10-03 17:15:34 -07:00
  :body: |-
    Alex,
    
    To sound English, this is 'brill.' Really well done. I'm going to repost some of it and link back to this from my blog, and I may even share it at work if you don't mind.
    
    Keep on keeping on, my man. Coming down to the Bay anytime soon?
    
    MG
  :url: http://reignoferror.blogspot.com
  :id: 
- :author: alex
  :date: 2008-10-03 17:26:00 -07:00
  :body: "@greebs, feel free to re-post as much or as little as you like. Everyone once in a while I get all fired-up on the holy spirit and feel like I gotta say something. More to come.\r\n\
    \r\n\
    Next Bay Area trip? Damn, that's a good question\xE2\x80\xA6"
  :url: http://livollmers.net
  :id: 
- :author: Michael Bishop
  :date: 2008-10-03 19:07:43 -07:00
  :body: Excellent post! The main argument against unit tests that I have personally encountered is that they don't cover everything. That kind of all-or-nothing approach overshadows the tangible benefits you talk about very clearly. Thanks for providing a concrete counter-argument that I can go back to for reference.
  :url: ""
  :id: 
- :author: alex
  :date: 2008-10-04 16:10:50 -07:00
  :body: "@Phil, yeah I remember when I saw that XP Pocket Guide. I got a one-way ticket to cringe-city. Yikes!"
  :url: http://livollmers.net
  :id: 
- :author: Michael Easter
  :date: 2008-10-02 22:27:33 -07:00
  :body: You mention the "agile backlash" -- can you provide examples?  I haven't seen a backlash against agile and am curious about it.
  :url: http://codetojoy.blogspot.com
  :id: 
excerpt: ""
date: 2008-10-02 16:44:27 -07:00
tags: ""
toc: true
-----
<p>Did you hear that? Did you feel it? I did. Agile just took another punch to the gut. The Agile Backlash is picking up a full head of steam. Rather than becoming a term to embrace, it's become a term of ridicule. I think it's probably deserved. As a guy who picked up the first [Extreme Programming](http://www.amazon.com/Extreme-Programming-Explained-Embrace-Change/dp/0321278658%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0321278658) book as soon as it was released and is a long-time practitioner, I feel qualified to comment on this.

<p>The second-generation acolytes turned a very pragmatic set of principles and practices into an esoteric scripture that could never meet the needs of reality. The "agile" moniker makes me cringe almost as much as "best practices". Both are cavalier substitutes for critical thinking, too often thrown about in the hopes that their mere mention will work magic. Ugh.

<p>A real unfortunate side-effect of the backlash is the disregard some have for automated testing. Before I go any further, let me be the first to say that, like any other recommendation or practice, automated testing is _not_ a panacea. I shouldn't have to say this. It's painfully obvious, like explicitly stating up front that I am against beating up defenseless children. Who _is_?

<p>However, just because automated testing isn't a cure-all doesn't mean that:
*  testing isn't worth doing
*  testing isn't hard
*  sometimes testing is so hard that it isn't worth doing

<p>Note that last point. That there is what we in the biz call _pragmatism_. Yes kids, there are times when the cost of getting sufficient test-coverage is enormously expensive. Assuming that economics are part of your project somehow, you need to pay attention to this (which is why code coverage metrics can be dangerous in the hands of the nuance-free thinker).

<p>Critics of automated testing like to point out that if developers write buggy code, how can they not write buggy tests? Assuming that it's as impossible to write perfect tests as it is to write perfect code, is there a point to writing the test? There is if the benefits you get from testing exceed the cost of developing and maintaing them.

# Test-Driven Design/Behavior-Driven Design![Marysville Falls](http://farm4.static.flickr.com/3084/2906603525_eea04c7769_m.jpg)
<p>The TDD/BDD philosophies are nearly as abstract and misunderstood as the entire concept of testing itself. So rather than parrot the original manifestos, let me break down the tangible benefits of driving your code with tests. The first misconception is the notion that you write all the tests first then you write all the code. This works almost as well as gathering all the requirements up front first and then writing all the code. I believe the technical term is "Waterfall". This is just dumb. Honestly folks, use your brains. Only a complete rookie would think that's a sensible practice to adopt.

<p>Putting testing before writing code provides no magical effect that radically increases the quality of your code. Where testing _does_ improve your code is when you use them as part of the code-building process. I like to use unit-tests as a form of mental scaffolding while I develop.

# Breaking It Down
<p>Any non-trivial problem needs to be broken down in some way. Few of us have the mental capacity to keep an entire solution in our heads. Even if we could, it generally doesn't last beyond the period in which the solution is developed. And even if you could do this, chances are few of your teammates would be able to. So at worst, breaking a problem down is a pro-social practice; at best it's a tool to ensure that you really understand what's going both now and in the future.

<p>Generally when you break a problem down, you get into the business of assigning responsibilities to various components. This is a fractal pattern that starts at the highest-level architecture and repeats itself all the way down to the lowest-level classes, modules and functions of your system. It must be an inherent part of human-nature&#8212;we simply love putting things in boxes. Perhaps this is because that in doing so, we can hang a simple tag on a collection of related concepts as a form of shorthand. That shorthand allows us to talk about things in an efficient way. Imagine a design conversation where you couldn't name anything, but had to describe a piece over and over by its details. Yuck. So yeah, boxes are important.

<p>So where does testing fit in? Testing allows you to write automated assertions about each of those boxes. It's like a logic game where you can start draw conclusions based on what you already know. It's like being able to say, "If this test is passing and that test is passing, the only thing that could torpedo this is if _that_ doesn't work". I'll come back to this later when I talk about troubleshooting.

<p>What unit-testing does _not_ cover here, are the connections between the boxes. It should be obvious that it's entirely possible to have a totally sweet set of unit-tests that never fail that cover each piece of your solution in full and _still_ have bugs or represent and incorrect solution.

<p>This is because unit-tests only cover the boxes, not the connections.

<p>Tests that cover the entire system are the best way to exercise the connections. They cover the boxes too, but they cover the _integration_ (hence the name) of the boxes and connections. Since unit-tests can't cover the system as a whole, are they still worth writing? You bet. Keep reading&#8230;

# Efficient Troubleshooting
<p>When something goes wrong, you enter a different frame of mind from programming. Now you're in the detective business. You start with some scraps of information (stack traces, error messages, late-night pages) and with a combination of logic, guile and intuition (hopefully) find the root cause.

<p>I could do an entire post on root-cause analysis, but let it suffice to say that most folks don't ask enough questions when troubleshooting. Often the conclusion people come to is an observation of a symptom rather than a thoughtful, system-aware diagnosis. In these situations it's a good idea to consider the [5 Whys Approach](http://en.wikipedia.org/wiki/5_Whys The 5 Whys).

<p>How do unit-tests help with troubleshooting? Like I said earlier, unit-tests are really good at testing the boxes, but not the connections. Let's assume that your unit-test accurately covers the box that you believe is the root of the issue you're seeing. Given that, there is a handful of conclusions you can draw:
*  The problem isn't really in this box
*  The problem is the connection coming into or going out of this box
*  Your understanding of the box is incorrect

<p>That's it. It _has_ to be one of those. Unit-tests allow you to confirm that your box is working correctly. If it's being invoked or interacted with in a way you didn't expect, it's generally a trivial exercise to write a test that _does_ use your box in that way. If it passes then you probably need to keep looking.

<p>If you're pretty confident that your box is good, then checking the connections is the next thing to look at. It's just as likely that the output of your box is being misused as the input to it. Integration tests are usually the best mechanism to catch this, but are generally much more expensive to write and maintain. For this reason they generally don't exhaust all of the possibilities. But with a real-world bug you now have a candidate for a new integration test.
I can't stress enough the benefits of using bugs as opportunities to strengthen your test-suites. This is as true for integration tests as it is for unit-tests. It's generally not practical to write tests for _every_ situation. So we use our intellect to make educated guesses that cover the most likely situations. When you observe funny behavior in your system, consider it a gift to your understanding. It's a golden opportunity to add a test for a real behavior, not a speculative one that may or may not occur.

<p>So let's consider a world in which we have _no_ tests. When something goes haywire you have to start from first principles _every time_. You have no mechanisms to get any leverage on the issue. Instead we have to rely on understanding the entire solution and holding it in our head at once. What do you think the chances are that we'll effectively troubleshoot an issue under these conditions?

# Finding Smells
<p>It is simply no fun to work on low-quality code day after day. As anyone who has every read [Zen & The Art of Motorcycle Maintenance](http://www.amazon.com/Zen-Art-Motorcycle-Maintenance-Inquiry/dp/0061673730%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0061673730) can attest, "quality" is a pretty squishy word. But in concrete terms, quality code means:
*  You enjoy working on it (or at least don't hate it)
*  You can expand its capabilities with reasonable effort
*  Somebody else can work on it too

<p>I find the process of test-driving the development of code is a great opportunity to find "smells" in your code. These "smells" generally detract from code quality. The best catalog of these smells that I've encountered is the [Refactoring](http://www.amazon.com/Refactoring-Improving-Existing-Addison-Wesley-Technology/dp/0201485672%3FSubscriptionId%3D0PZ7TM66EXQCXFVTMTR2%26tag%3Dhttplivollmne-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201485672) book by Fowler and Beck. You don't need to read the book for a detailed description of the mechanics of refactoring, but it is worth reading to learn the terminology of "code smells".

<p>At a minimum tests are the first "customers" of your code. If it's painful to test your code, you probably haven't factored it very well. Paying attention to this while your test-driving the development is a great way to keep your code high-quality. To really benefit from this, you need experience, a highly-developed sense of aesthetics and intuition. If you keep at it, you will gain these.

<p>Note that I don't equate code quality with "success". There are plenty of systems out there that are successful that are _not_ built on what I would call quality code. That's fine. I've made a conscious choice not to work on those systems. I spend an awful lot of my waking hours working on code&#8212;personally I don't want to waste that time being frustrated. I want a sense of accomplishment and satisfaction when I'm done for the day. Honestly, I'd trade success for quality code just about anytime. I expect to be doing this for a long time, so why not enjoy it?

# Safety Net for Refactoring
<p>When you need to extend or enhance a system, having automated tests serve as a great safety-net for refactoring. If you're confident in the efficacy of your unit-tests, you can be confident when you make changes and your tests still pass. You can refactor with a higher level of confidence when your tests keep passing. Of course there are no guarantees that you _haven't_ introduced some kind of regression bug. But let's face it folks, the testing game is one of probabilities. It's too expensive to make sure you're right all of the time&#8212;instead shoot for being right _most_ of the time.

<p>There will _always_ be times when something goes wrong and the only way to diagnose and fix it is to walk through the code painstakingly, line by line. No amount of testing will ever make that go away. My goal is to _reduce_ that as much as possible. It's inevitable, but it doesn't have to be the norm.

<p>Consider the case where you _don't_ have any tests while you refactor. Your code/build/test/debug cycle gets a whole lot longer and more expensive. Because of that, you do it less often. Which means that when you do go through the cycle you have more things that can go wrong and more stuff you have to hold in your head. That increases both the likelihood that you will mis-diagnose a problem and that you will write more bad code to fix the latest bug.

<p>I think this is how really twisted code is born. It almost reads like a blow-by-blow account of the developer's mounting frustration. The pace and phrasing of the code gets more and more frenetic: more odd comments, more TODOs and FIXMEs littered throughout, more long procedural stanzas. It becomes obvious that they were trying to get this done as quickly as possible, and that's generally not the path to quality.

# Confidence
<p>When it comes human-nature and software I'm a pessimist. I think we're really good at the intuitive parts and achieving the "ah-ha" moment. We are _not_ good at holding giant complicated systems in our heads. There _are_ people who can do that, but it's not the norm. For this reason, I think it's extremely foolish to build a software organization that relies on raw mental capacity. This definition of "smart" is one that can't scale and is unsustainable.

<p>Automated testing is one teeny-tiny way we can offload the need for that capacity to a better long-term storage mechanism. While I write tests my mind is very focused on a particular part of the system. As I flesh out the tests I fill out my understanding of the problem-space _at that time_. Now that it's written down in code, I can safely leave it there and let my mind free up that space to do other things.

<p>If I've written my tests well, I can get back into that focused frame of mind when I need to (e.g. for new features or bug-fixes). Without these, I have to spend a lot more time understanding a larger system just to get "up to speed". The tests can serve as an index into the design of the system. This is particularly effective when you have been paying attention to code smells and have been refactoring aggressively&#8212;your tests will map effectively to the underlying concepts of the system design.

<p>This kind of confidence has a real tangible benefit. Without it I'm easily distracted by small details and dead-ends. As soon as I have more I have to worry about at once, I have less of a chance of succeeding at the task at hand in that moment. When I have such a thing in place, I have an instant force-multiplier in my hand. I can get something done. I don't have to repeat the entire experience of developing the code the first time. Instead I can leverage that experience to be more productive the next time I come back to that part of the system.

<p>Conclusion


<p>So there you have it. That's where I stand.

<p>Is testing hard? _Yes._

<p>Does it catch everything? _No._

<p>Is it still worth doing? _I think so._

