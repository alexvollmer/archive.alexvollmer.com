----- 
kind: article
permalink: day-one-afternoon-railsconf-2007-patterns-to-dry-up-your-views
created_at: 2007-05-18 04:20:35 -07:00
title: Day One, Afternoon RailsConf 2007 -- Patterns to DRY Up Your Views
excerpt: ""
original_post_id: 5
tags: 
- ruby
- rails
- railsconf
toc: true
-----
Update: 2007-05-19 &mdash; Bruce and Marcel posted a PDF of their talk [here](http://codefluency.com/assets/2007/5/18/VisForVexing.pdf).

After knocking down lunch I was faced with a conundrum. I had signed up for a tutorial on view-layer patterns, but saw that Jamis Buck was doing a tutorial on [Capistrano](http://www.capify.org/ Capistrano). When I registered originally I had no idea that Cap 2.0 was coming out and I didn't really care to get any more familiar with Cap 1.0. But between then and now Cap 2.0 came out and it looks like there is some good stuff to learn. But the view tutorial looked good too. What to do? What to do?

The tutorial that Bruce Williams and Marcel Molina gave for refining the view layer was excellent. I think a lot of the content seemed to go over the heads of the audience--they seemed to get a little too wrapped up in the ugly details rather than the important over-arching points.

The first point was that the view-layer deserved as much expressiveness and thoughtful design as we put in our models and controllers. In essence, we prefer expressing the _what_ rather than the _how_ in our code. Why not apply that to the view layer? This is general concept that I hope to explore in a later post.

They started with a brief survey of other view layer technologies such as ERB, [Markaby](http://redhanded.hobix.com/inspect/markabyForRails.html Markaby),[ HAML](http://haml.hamptoncatlin.com/ HAML) and others. However the takeaway from this review was that most of these technologies were focused on cutting down on the amount of typing necessary to do the templating, but didn't really provide a means to increase domain-level expressiveness. The approach proposed by Bruce and Marcel was to embrace ERB/RHTML and use the power of Ruby to factor out complications within the view.

One way to achieve this factoring is paying attention to the natural tensions that emerge as you evolve your application. When you find that certain names come up over and over again in describing the system with your customer, you probably need something with that name in your system.

Another way to do this is to naturally evolve your view. Using regular ol' ERB in RHTML is probably a great way to start out. However once you start getting things in your templates like calls to finders, conditional logic, calls to Enumerable methods or temporary variables, it's time to push that work into a terse, but descriptive, method in your view helper.

When you accumulate enough of these helper methods that share state or particular strategies, it's probably time to make it into an Object. Normally people think of Objects as belonging strictly to the domain layer which (wrongly) implies the use of ActiveRecord. Don't get hung up on this. Objects are powerful ways to encapsulate concepts. Don't hesitate to use them.

You can use helpers as the "glue" between your view templates and these newly-emergent, sophisticated objects that are cleaning up your view. Again, we want to focus on the _what_, not the _how_.

So, perhaps a way to consider the evolution of view layer encapsulation is like so:

ERB in templates > Helper methods > first-class Objects

You need to use your past experience and your sense of smell to figure out when to evolve. Picking some complicated Object strategy up front is probably doomed to not meet future needs and will require even more re-work to replace it with something else.
