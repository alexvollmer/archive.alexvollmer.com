----- 
permalink: what-jersey-means-to-java
title: What Jersey Means To Java
excerpt: ""
date: 2009-03-04 18:42:49 -08:00
tags: ""
toc: true
-----
In the last few days at [work](http://evri.com) I've been migrating a home-grown REST framework over to the [Jersey project](https://jersey.dev.java.net/) (the reference implementation of JSR-311 or, JAX-RS). Previously I had done some work moving JRuby into the VM and launching Merb. It was satisfying to figure out how to do that, but involved an awful lot of wiring and special-casing.

As anyone who has read this blog recently knows, the luster is coming off of Java for me in a big way. These days my goals are simply to co-exist with it in a way that keeps me happy. I'm not going to be able to toss Java overboard so my working-life becomes a question of how to be happy with the situation.

While our home-grown framework has worked well for us, I'd much rather see us using something with wider adoption and use. So I took a look at Jersey and came away pretty impressed. Looking at how the API is built and what you need to do to build REST-ful web services in Java I couldn't help but feel like Java has learned some lessons from the rest of the world.

The original Servlet API is what could be termed a "classic" Java API, wherein consistency and type-safety are the rules. In the Servlet API, you interact with requests and responses as monolithic objects. Each type of HTTP method (i.e. GET, POST, PUT and DELETE) has their own method which takes a `ServletRequest` and a `ServletResponse` object.

It's a reasonable first solution, but it breaks down quickly. The primary issue is that by packing all possible request-related data into a single request object, and all possible response-related data into a single response object the classes themselves start to feel bloated. A more sinister second-order effect is that these classes, especially the response object, have some hidden state and "gotchas" because they are so general.

As an example, consider the case where you want to return a response with a non-200 response code, an entity body and some headers. The order in which you set these on the response object is important because of how it's implemented. You need to set the status and headers _before_ you write any output to the stream. This make sense because you want a stream-oriented interface which means not storing the entire response in memory and then flushing. But, due to the strict order of HTTP response messages, you need to flush the header information prior to sending the body. It's not a particularly difficult thing to remember, but it is unnecessary mental overhead that is an artifact of the implementation.

The request object is its own special brand of fun to deal with. Again its broad coverage makes for a rather clunky API to deal with. You want request parameters? You have to grovel through `String` arrays if you want to capture all of them. When implementing a Servlet, often what you want is some combination of request parameters, cookies and header; rarely do you need all of them at once. However what you get is one big über-object that has everything. Enjoy!

One final beef with the `ServletRequest` class is that getting path parameters out is an absolute nightmare. If you're building REST resources you really really care about the path as it is _the_ way to identify resources. The poor support the `ServletRequest` class provides for this is simply shocking. Here's a `String` — you parse it and figure out what the hell the segments are.

In contrast, Jersey has a much looser philosophy with how requests and responses are handled. First, the monolithic request and response objects go away. Instead your methods provide the narrowest possible interface, expressing only what they need in exacting terms. This is done by making extensive use of Java annotations to mark up simple method parameters. For example, if you have a resource that needs a request parameter, use the `@QueryParam` annotation. Need a header? Just use `@HeaderParam`. Interested in cookies? Use the `@CookieParam` annotation. Here's an example:

public MyResult getMyResult(@QueryParam("name") String name) {
  …
}
</pre>

This does away with a tremendous amount of "busy-work". You want the "name" parameter? By god you're going to get it—no intermediate objects to reach into and pull stuff out of.

A really nice side-effect of this is that writing tests for your resources become _so much_ cleaner than using the more general Servlet API. Instead of setting up the monolithic request and response objects, you simply pass in the bits you want.

What about the response side? I think that it's in this area that we really see a fundamental philosophical shift emerge. In an earlier time the textbook answer to how to design an API like this would be to have each request method return some kind of superclass or interface. This would allow us to use polymorphism to vary the response, but keep our type-safety.

Jersey takes a different approach based on real-world needs. Whereas the Servlet API is intended to keep everyone equally happy by making sure everyone suffers the same amount of pain, Jersey lets you vary what you return—no special markers, no special configuration. If you have a simple case where you want to serialize an object as the entity response, just return the object.

What if you need to fiddle with the response some more? Maybe set some headers or alter the status code? In this case your method returns a `Response` instance. Now this may sound monolithic and perhaps, under the covers, it is. What saves it from degenerating into the Servlet API is the fact that you build a `Response` object with only as much as you need.

In the Servlet API you might have to set a moderately complicated response like this:

public void doGet(HttpServletRequest req, HttpServletResponse resp) {
  // do some stuff
  resp.addHeader("Expires", computeExpires());
  resp.setStatus(201);
  writeResponse(resp.getWriter(), new MyStuff());
}

private void writeResponse(Writer writer, MyStuff stuff) {
  // do whatever you have to do to serialize your object
}
</pre>

In Jersey it looks like this:

public Response getMyStuff() {
  MyStuff stuff = new MyStuff();
  return Response.created(stuff).expires(computeExpires()).build();
}
</pre>

The amount of code probably comes out to be the same, but the fact that you can build the response in a single line feels really good to me. The amount of vertical space dedicated to response-building is much more proportional to it's conceptual space in the method in Jersey than the Servlet API.

Now I realize that comparing Jersey to the Servlet API is perhaps unfair. The Servlet API is really designed to operate a layer below where Jersey plays. But I think the same arguments apply to a majority of the other popular web frameworks. The models are all essentially the same.

So here's where the philosophical sea-change comes in. To vary the response type to do the right thing means that after a decade of existence, people are finally embracing Java's reflection capabilities. Up until pretty recently this was considered the domain of the lunatic fringe. 

The primary argument against reflection has always been that it's too slow. While it's true that their can be a penalty _under certain circumstances_, the modern perspective is that it's an acceptable price to pay for a kinder, gentler API. Simply put, this level of dynamism is essential for reducing the amount of boilerplate and busywork.

I think if other frameworks like Rails, Django and Merb hadn't gained so much traction in the last few years Java would have continued on it merry way. However I think the popularity of those alternatives has forced the Java greybeards to learn a thing or two. Strict static type-safety can become a burden and using reflection to vary behavior instead of polymorphism can make for some very clean APIs.

After spending a few days with Jersey I find myself a little re-energized to work with Java again. We're even considering [Groovy](http://groovy.codehaus.org/)  as a way to cut down Java's chubby syntax for another small productivity win. Of course, my personal preference would be to do this JRuby since I, personally, don't find Groovy to be terribly compelling on its own. But since Jersey is _so_ dependent on annotations, using JRuby is a non-starter.

Who knows? This could be a complete fiasco and another frustrated attempt at tilting windmills. I'm already a little suspicious of the "enterprisey" way this thing gets configured. However if nothing else, it's refreshing to see some new ideas make their way into Java after all these years.
