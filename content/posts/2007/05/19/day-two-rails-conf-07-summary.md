----- 
kind: article
permalink: day-two-rails-conf-07-summary
created_at: 2007-05-19 16:55:26 -07:00
title: Day Two Rails Conf '07 -- Summary
excerpt: ""
original_post_id: 7
tags: 
- ruby
- rails
- railsconf
toc: true
-----
After the keynote speech by David Heinemeier Hansson, I attended several session that felt disparate at the time, but magically coalesced into a meaningful takeaway by day's end. In short the day was about testing, REST and Amazon's suite of Web Services.
# Getting Religion With Uncle Bob

Update 2007-05-19: Robert posted a PDF of his slides [here](http://www.objectmentor.com/resources/articles/Clean_Code_Args.pdf).

The first session I attended was one titled "Clean Code" presented by Robert C. Martin. I will admit that I'm only familiar with his name as being the "signature" endorsement on some of my favorite texts by the likes of Kent Beck and Martin Fowler. After hearing him speak I can see why he has endorsed their writing and would include him into the small team of pragmatic agile bandits consisting of the aforementioned Kent and Martin as well as Ward Cunningham.

The point of the talk was essentially about constant vigilance. Putting off fixing smelly code today only leads to much more expensive changes later&mdash;either in the form of grand redesigns (a bad idea) or in incrementally paying down the debt you've incurred. The answer is to use the tried-and-true  weapons at your disposal are a refined nose, testing and refactoring.

He walked through a pretty good test-driven development (TDD) example that I suspect surprised a good bit of the crowd. I say 'surprising' because when someone who _doesn't_ use TDD sees it for the first time, it looks very dogmatic and slow. People who don't do TDD get really hung up on this, but fail to understand what underpins the approach: humility. TDD is really based on the notion that we _all_ write legacy code&mdash;_no one_ is brilliant enough to get it right the first time.

Another hang-up point for first-timers is the use of the term "test-first". I'm surprised at how often people think that means your write a _comprehensive_ set of tests before you write any code. This, of course, is nonsense. Just like writing a detailed specification with pseudo-code up front is not a practical pre-cursor to a healthy system realization. I've always preferred the term "test-driven" as I think it sheds a little more light on another of unit-testing's benefits which is another form of system feedback.

Sometimes you have a test that is so ugly that it alone will make you refactor code even though your production consumers may not really be suffering in the same way. Why would you do this? Test-code isn't production code, why let it force change? My answer is that you change the code because of the test for the same reason you change code used by the production system: if it hurts to understand or modify you have found a smell. If you let that smell linger, you will start incurring "debt" on your project.

While I didn't get any real juicy new bits from Uncle Bob's talk, he was an extremely entertaining speaker who made and excellent presentation. If you ever get a chance to hear him speak, it's worth it.
# Pushing the Boundaries of Rails Testing

The next session was put on by Jay Fields with ThoughtWorks. I think he probably had some very good points to make but without a few visual examples a lot of his points were lost on the audience. However he did make some points that brought questions for me about testing.

When writing Java I've found that my tests and classes are quite fine-grained compared to the Rails code I test. In part a lot of that is to enforce a stronger separation between domain-level code and external resources like RDBMS persistence. When you use `ActiveRecord` in Rails, your model is welded directly to the database. When I first saw this as a Java programmer my nose wrinkled up and I was extremely suspicious about this approach.

To my surprise testing `ActiveRecord` classes directly against a database has been much less painful than I suspected. I think this probably has to do with supporting structures such as rake tasks and fixtures that don't require you to drop down to SQL just to test your model. On the other hand, if your code is going to evolve to anything moderately sophisticated I think it's possible to exceed the capacities of these facilities. It's something to pay attention to for sure.

Jay also threw out a couple of other thoughts that caused unease in the audience:
*     While your code under test is object-oriented, your tests don't have to be
*  Repeating yourself in your production code it bad, but it's okay in your tests
*  The value of `private` and `protected` methods in Ruby is debatable

Like books that get banned or musicians that get called up in front of congressional committees, the very things that give you unease are probably worth addressing head-on rather than sweeping under the rug. At the end of the session, my final thoughts were that we have a long way to go in evolving the craft of testing.
# REST

I had about ten minutes to kill between sessions and I was desperate for a free cup of coffee. In a stroke of marketing genius the conference organizers moved the coffee bar from breakfast area to the vendor's floor show. Alright, I'm game. I'll look at your ads to get a free cuppa joe.

Most of the booths held no interest until I stumbled across the Powell's Books stand. There before my eyes were stack of geek books. The night before I made the trek out to Powell's via Portland's delightful MAX transit system. If you've never been to Powell's do yourself a favor and go. For geeks, the Technical Bookstore simply can't be beat.

Anyway, I figured there wouldn't be anything new there that I hadn't seen the night before at the Mothership. Of course, I was wrong. There before my eyes was shiny new O'Reilly book titled "REST Web Services". I had been aware that Leonard Richardson and Sam Ruby were working on this book, but had lost track of when they were actually going to publish. I spent a little quality time with the chapter on S3 and my hopes were confirmed&mdash;this is going to be a good book.

REST has gotten a lot of press lately, but I think a lot of people really don't have a good grasp of the concepts. To this point the only literature has either been Roy Fielding's original dissertation and a few derivatives of that paper. I think Fielding's paper is definitely with reading. It's very dense and repays the reader with each read. However, for REST to truly take hold the community really needs a thoughtful source that boils down the essence of the architectural style in a consumable format. Given the eagerness with which REST is being embraced and the dearth of practical resources on this topic, I would expect this book to be a well-loved, dog-eared volume on a lot of desks.
# Amazon Web Services

We took a long break from the geeks and had a fine dinner at [McMenamins Kennedy School](http://www.mcmenamins.com/index.php?loc=57&category=Location%20Homepage). We returned to the conference and headed off to a late-night BOF session about Amazon's S3 Service. The turnout seemed pretty good. After a brief dog-and-pony show from an Amazon rep the floor was opened to the attendees. Despite the size of the session, only a handful or participants were actually using S3 in production&mdash;everyone else was curious to see how it was being used.

While Amazon won't expressly claim that S3 can replace content distribution networks (e.g. Akamai), they aren't scaring people away from it. I would venture to guess that %50% of the attendees wanted to know if they could store assets in S3 that they could serve back up directly to their client. My impression is that Amazon is trying to evolve S3 to this kind of platform. This could be really big and is definitely going to be something I'm going to keep my eyes on.
# Post-Game Show

I needed a little ramp-down time before I turned off the light for night-night time. I cracked open the "REST Web Services" book and started reading the chapter about S3 until my eyes drooped and I slipped into deep relaxation. As I slipped into unconsciousness, a few final thoughts on the day coalesced:
*     If Rails is a big simplifying assumption around web apps, REST is a big simplifying assumption around web services
*     While the Rails community is pretty good at embracing testing, the craft has a long way to go (this is true of _all_ software platforms)
*     AWS has the potential to make a fundamental _economic_ and _technical_ shift in the way large web applications are deployed
