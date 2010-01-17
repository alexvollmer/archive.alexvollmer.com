----- 
permalink: why-cant-web-apps-be-rest-ful
title: Why Can't Web Apps Be REST-ful?
excerpt: ""
date: 2007-06-27 02:55:14 -07:00
tags: ""
toc: true
-----
In case the recent posts haven&#8217;t made it obvious, I&#8217;ve been on a bit of a tear about REST lately. In large part this is due to [Leonard Richardson’s and Sam Ruby’s “RESTful Web Services”](http://www.oreilly.com/catalog/9780596529260/) book that I picked up at RailsConf. One of the thoughts that has been bouncing around in my head is how web service-oriented the book was and, besides a chapter about Ajax, said very little about how REST applied to user-facing _web applications_.


I wondered to myself, &#8220;are browsers so broken that we can&#8217;t make REST-ful web applications?&#8221; I know that in the last year there have been times that I have really struggled with applying REST consistently to web applications. Things like the sign-up and sign-in process seem like square pegs trying to go into round holes. Should I have just given up on REST?


Before we can answer this question we first have to tackle the sticky question of just what, in practice, makes a web app REST-ful or not. One of the obvious places to start is the URLs of your application. It feels pretty un-RESTful to have URLs like `/signup` or `/signin` since these are very verb-oriented&#8212;REST prefers an infinite array of nouns with a very constrained set of verbs. 


So how do URLs like `/signup` and `/signin` become REST-ful? One possibility is looking at what the underlying nouns are for these actions. The act of &#8220;signing up&#8221; for an account could be modeled as POSTing user information to a noun like `/accounts`&#8212;the resource we are attempting to create with the POST message is an account. Similarly, the act of &#8220;signing in&#8221; is really the act of creating some authorization within an application. We could POST our credentials to a resource like `/sessions` or `/credentials` to create an internal resource representing our session with the site. Now things get a little sticky when strictly adhering to REST-ful guidelines and trying to do authentication. That&#8217;s a whole other topic for a different post at a different time. Let&#8217;s say that with a little thought, you can create REST-ful URLs that still work quite well within a web application.


The next thing to consider is one of the biggest places where strict adherence to REST falls down: the lack of support for any HTTP verbs beyond GET and POST within (X)HTML. Frankly it&#8217;s just shocking that we are in this predicament. I really hope that there&#8217;s either a good rationale or funny story for why things are this way. I really _really_ hope that it gets fixed soon. Currently there are two ways around this: Ajax and the &#8220;_method&#8221; parameter hack a la [Rails](http://www.rubyonrails.org/).


The first technique is reviewed in Richardson and Ruby&#8217;s book. It turns out that Ajax-driven applications fit pretty nicely with REST. Other than Safari/Konqueror, browsers can support other HTTP verbs quite easily with `XMLHttpRequest`. Because the Ajax client code shoulders the bulk of the responsibility for the UI, the backend resources can limit their returned representations to data that the Ajax clients work with. This gets rid of a lot of sticky problems that come with having to render fully-functional pages with each request.


The second technique is essentially a hack, but one that allows to code our resources REST-fully. Frameworks like [Rails](http://www.rubyonrails.org/) and [Restlet](http://www.restlet.org/) do this for us automatically. Even if you are using another framework or rolling your own, you should be able to apply this little &#8220;hack&#8221; in a nice little corner of the request-response dispatching code without too much fuss. In short, I&#8217;m willing to live with this little turd to keep the rest of my system consistently organized.


OK, we&#8217;ve got our nouns squared away with a consistent set of verbs. Well-factored nouns implies a good URI design (how else will we identify resources?) What else do we need to have in place to be REST-ful? Hmmm, how about proper state responsibility? You will often hear people say that REST-ful applications are stateless. I think this misses the point. The _HTTP protocol_ is stateless, but your applications undoubtedly have state. Any app with a shopping cart has state. So the question then becomes, do user-facing web applications have different needs that necessitate a violation of REST regarding state?


The short answer is probably not. By and large your application state is usually server-driven and ideally done via [“hypermedia as the engine of application state”](http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm). In practice this means that the current state of a user&#8217;s shopping cart is probably persisted in a shared store allowing any application node to serve the client&#8217;s request. Yes folks, a good bit of why REST guys harp on statelessness is for the sake of scalability.


Things get a little grayer when we want to have small bits of saved state on the client for things like &#8220;remember me&#8221; features or other quick, token-based identification schemes. I won&#8217;t lie to you, I&#8217;ve used cookies a lot. I know the strict REST approach decries their use and characterizes them as the root of all internet evil, but if they weren&#8217;t so damn useful I&#8217;d be in complete agreement. Like real-life, having cookies often is probably not a good thing, but once in a while isn&#8217;t going to do any long-term damage.


So, can user-facing web applications be REST-ful? Sure. Are there some compromises to be made along the way? Most likely. Does that mean that REST is an overly-idealistic approach that fails in real-world implementations? I would say not&#8212;however, your mileage may vary.
