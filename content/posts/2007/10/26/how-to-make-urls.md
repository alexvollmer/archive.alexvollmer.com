----- 
kind: article
permalink: how-to-make-urls
created_at: 2007-10-26 22:05:18 -07:00
title: How To Make URLs
excerpt: ""
original_post_id: 32
tags: 
- REST
toc: true
-----
One of the things that makes a web application &#8220;look&#8221; RESTful is the type of URLs it presents. Like many things, whether or not these URLs really meet a particular criteria is a matter of degrees. But anyone who has some basic understanding of a resource-oriented view versus a functional view can tell the extremes apart (e.g. `/system?sport=football&amp;team=seahawks&amp;year=2006` vs. `/football/seattle_seahawks/2006`).


However it&#8217;s the in-between URLs that seem to provoke the most heated discussions between the REST-anistas and the non-believers. Those not impressed with REST would argue that all we&#8217;re doing is prettying-up our URLs with no real functional improvement. Now I happen to prefer good-looking URLs over ugly ones because I think they are easier to work with. But outside of the aesthetic argument I couldn&#8217;t really make a good case for RESTful URL design. However, after a bit of thought, I&#8217;ve come up with a theory on how URLs ought to be constructed.


### The Theory

Requests for resources have two basic components: the _identity_ of the resource and _variation_ information. Identity is the minimum amount of information required to distinguish one resource from another. Variation criteria is additional information that refines or qualifies the _representation_ of the requested resource. Variation information can include things like:
*  type of requester
*  content type
*  session or user
*  portions of the representation



In a proper URL design, identity information should be expressed as a first-class notion. In URLs this is best expressed within the path portion of the URL. This information does _not_ belong in request parameters. This not only makes your URL structure easier to manage mentally, it also stands a better chance of working well with HTTP caches (more on this in a bit) and proxies. Variation information can be expressed by the requester in any combination of headers (e.g. Content-Type) or request parameters.


### Hold the query parameters!!!

So why do so many people fall back on request parameters? In the Java world, I think a lot of it comes from people developing applications in a Servlet environment. The servlet specification provides no easy way to access path information. You have to get the request path and split the string by hand. Yecchh. Also, the built-in URL mapping in Servlets leaves quite a bit to be desired. So a lot of folks just fall back on the simple dictionary interface that servlets provide for request parameters. Unfortunately this has bred a lot of bad habits in Java web developers.


I think the other reason this design is prevalent, is the holdover of the first great paradigm shift on the web when we moved from "web sites" to "web applications". Many of the people writing the first web applications (myself included) tended to view HTTP requests as function or method calls where variable information is passed in as arguments. What many of us failed to realize was that requests for dynamic content didn't require a different way of structuring URLs. We were still, by and large, asking for _things_.



There are two problems with the functional approach. The first is that a lot of request parameter information could be better expressed with existing headers. The second is action-oriented view that developers take of these requests which violates a core principle of REST where a finite set of actions are applicable over an infinite set of nouns.



### Collections


One place where query parameters make sense are specifying views across collections. This is also known as providing a search parameter. Think of the Most Popular URL In The World, `http://www.google.com/q?=`. When you search, that 'q' parameter is a specification for a filtered view of that top-level Google resource. In other words when you query for `http://www.google.com/q?=Led+Zeppelin` you're really asking for all things Led Zeppelin from the Google collection.




On a smaller scale, query parameters are quite appropriate when asking for a filtered view over a collection that has arbitrary dimensions. However, not all views over a collection should use  query parameters. For example, in a case like Flickr where tags are first-class aspects of certain resources, `/tags/` is expressed as a path segment. When resources are normalized like this, you should favor paths over query parameters. However when you want to select a sub-set of resources out of some larger heap _and_ the way you specify that subset is open-ended, query parameters are a good way to go.



### Caching


Perhaps the best rationale I can give you for the RESTful approach is that playing by these rules will allow you to take full advantage of HTTPs built-in caching semantics. When you think about what a cache has to do and all of the rules it has to follow, its main function is identifying and returning cached responses to cacheable requests.




That Wild West Frontier that is the "query parameters" section of a URL can give HTTP caches fits. Heck, by default [Squid](http://www.squid-cache.org/) ignores query parameters for resource identification. [You have to go out of your way to get this to work](http://wiki.squid-cache.org/ConfigExamples/DynamicContent?highlight=%28%5EConfigExamples/%5B%5E/%5D%2A%24%29). You could argue that Squid "isn't doing it right", but I think it would be more fair to say that Squid is trying to be safe with regard to query parameters. This is similar to the way Google's Web Accelerator [treats URLs with query parameters](http://webaccelerator.google.com/webmasterhelp.html) (i.e. an opaque Pandora's Box not to be trifled with.)




So keep your URLs clean! Figure out what information you need identify a resource and keep it in the path of the URL. Use headers or request parameters for any of the variation information.

