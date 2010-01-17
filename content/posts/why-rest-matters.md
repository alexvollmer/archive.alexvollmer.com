----- 
permalink: why-rest-matters
title: Why REST Matters
excerpt: ""
date: 2007-06-13 02:42:58 -07:00
tags: ""
toc: true
-----
I first ran across REST in my reading about a year and a half ago. While it took me some time to “get” what REST was, I quickly became a fan. However I’ve found that aside from pure aesthetics, I’ve had a hard time articulating why REST is not only beautiful, but effective. I’ve spent a little more time thinking about REST and I think I may have a couple of concrete arguments for REST that go beyond a simple appreciation of its beauty.
# ![uniform interface](http://farm2.static.flickr.com/1030/543372651_5e789e984d_t.jpg)

# Uniformity of Interface

When resources present a uniform interface, we can take advantage of this simplifying assumption. We can focus more on what we can do with resource rather than _how_ we interact with them. This simple convention takes a lot of churn out of the development and integration process.

Uniformity also constrains system design to the minimum required for distributed computing. Anything else is simply baroque elaboration that provides little to no value (think of SOAP’s `SOAPAction` directive) and is nearly always at the cost of the uniformity.
# ![works with http](http://farm2.static.flickr.com/1127/543397887_6a3775ded5_t.jpg)Works with HTTP

Assuming that you are going to provide data via the web, you are working within the constraints of HTTP. Since HTTP is an expression of the principles of REST, it is both foolish and counter-productive to go against the grain of HTTP’s architecture. Unfortunately, HTTP is a very misunderstood protocol. It is sad that so few people who develop with HTTP understand it so very little.

One of the least understood parts of HTTP are its caching mechanisms. Not only is caching misunderstood, it is terribly under-utilized. Most developers simply know caching as something to disable at all costs. This reflects an abuse of the protocol and an unnecessary effort expended to go against the grain.

When you express your resources as distinct URLs, you can take advantage of the built-in caching semantics HTTP provides. A large reason (though not the only reason) that many web developers work so hard to turn off caching is because their applications are verb-oriented and tend to operate through one or a few separate URLs.

Similarly, the semantics of content negotiation are also rarely well-understood let alone used in the wild. HTTP’s content negotiation mechanism separates the concerns of _what_ an underlying resource is from _how_ it will be represented. This is a _good_ separation of concerns—a user’s account details are a user’s account details regardless whether they are displayed in HTML, JSON or XML.
# Connectivity

# ![connectivity](http://farm2.static.flickr.com/1021/543273982_040b8addae_t.jpg)

Connectivity is the way a web application connects within itself. One of Roy Fielding’s main assertions is that REST uses “hypermedia as the levers of application state”. This is achieved by the linked hypermedia returned by a resource. Connectivity provides further simplifying assumptions about how a site is connected. Instead of relying on complicated specifications like WSDL, consumers of REST-ful applications can use a lot more of a web application based simple guidelines.
# The Design Analogy

# ![design](http://farm2.static.flickr.com/1065/543374965_8d8543c413_t.jpg)

Let’s try to put resources in terms of object-oriented design. A classic symptom of poor object design is where the functional aspects of the system are the first-class attributes of the system and any “objects” are simply data structures passed from function to function. Good object-oriented design puts the behavior right next to the data with a healthy sprinkling of encapsulation.

You wouldn’t have a single function that took an arbitrary number of parameters that could return an arbitrary type or amount of data or perform an arbitrary functions. The complexity would spiral out of control quickly and you would want to create some kind of taxonomy. In object-oriented design these emerge as objects that describe distinct domain entities. Why shouldn’t this apply to web applications and services?
# Your Checklist for Winning REST Arguments Around the Watercooler

So let’s sum this up into something you can print out, cut down to pocket-size and laminate and keep in your wallet:
- REST is about resources. There are an infinite number of these, but a very finite number of things you can do with them.
- This simplifying assumption makes client consumption of data simpler.
- This simplifying assumption makes for cleaner resource design.
- Since you’re using HTTP, you might as well use it correctly. Read [the spec](http://www.faqs.org/rfcs/rfc2616.html)!
- REST promotes connectivity. Express the connections between your resources and make your application more discoverable and navigable.
- REST prefers a separation of an abstract resource from its physical representation. This is good design.
