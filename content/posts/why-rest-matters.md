----- 
permalink: why-rest-matters
layout: post
filters_pre: markdown
title: Why REST Matters
comments: 
- :author: Jim Cook
  :date: 2007-06-14 18:11:48 -07:00
  :body: |-
    Thanks for the reply.
    
    I understand your point, but perhaps not its implementation. 
    
    Are you suggesting that if I need a Person and its collection of children [Set 'o Person], I would invoke a URI that looked like "getPeopleAndChildren"? And, if I wanted a Person and his spouse [Person], I would invoke "getPersonAndSpouse"? 
    
    I have done things like this in my naive early days, but this approach quickly gets wildly out of control with service method explosion. I'm not even considering the case where Foo has a spouse of Bar who has a spouse of Foo who has a spouse of Bar who has a...headache.
  :url: ""
  :id: 
- :author: DIGITALISTIC &raquo; Blog Archive &raquo; links for 2007-06-13
  :date: 2007-06-13 20:19:31 -07:00
  :body: "[...] Why REST Matters (tags: REST http soap webservice) [...]"
  :url: http://www.digitalistic.com/2007/06/13/links-for-2007-06-13/
  :id: 
- :author: Franck
  :date: 2007-06-13 15:36:38 -07:00
  :body: For those, like me ;o), that discover the  REST acronym with this blog's post, there is a good introduction on http://www.ibm.com/developerworks/java/library/wa-ajaxarch/
  :url: http://www.martinig.ch/
  :id: 
- :author: Jim Cook
  :date: 2007-06-14 12:25:17 -07:00
  :body: |-
    My questions with REST (and SOA) always come back to how are these mono-object methodologies useful for a typical business application?
    
    Using REST, I would assume that I have a service that knows how to CRUD a "Person". If I retrieve a Person representation and it has a reference to a spouse, I would encode that reference as a URI that I can invoke to return the spouse's Person object. The same for the collection of children, collection of friends, etc.
    
    How performant can a system be if every relationship that must be traversed (I am referring to Entity to Entity relationships) requires another HTTP request?
  :url: ""
  :id: 
- :author: alex
  :date: 2007-06-14 15:44:44 -07:00
  :body: |-
    Jim, thanks for your question--it's a good one. I think a lot of the REST/CRUD analogy has been overplayed and leads to a lot of confusion. 
    
    A resource in REST does not necessarily equate to an object in the back-end. While technologies like Rails and ActiveResource use this as the default I think it misses an important point. Resources are important nouns that are available <i>externally</i>. Our internal object-model is a way of breaking down the domain from the inside and has a different set of constraints applied.
    
    Let's take your Person example. It may very well be that Person resources need to be exposed in a singular form, but that doesn't have to be the only form. If things like families or friends are important, they're resources! Those resources can expose a representation of that describes the collection structure and as much per-object depth as required. In this case the collection "views" could be though of a synthesized (or calculated) datasets, but externally a single Person or a collection are all resources.
    
    One of the hardest things I've found about understanding REST is to use different constraints to shape the resource taxonomy. I think a slavish adherence to a model where resources are simply exposed internal objects is the wrong choice. What resources are exposed should be shaped by the needs of your clients. A fine-grained service that requires too much traversal simply fails the needs of your clients.
    
    Cheers,
    
    Alex
  :url: http://livollmers.net
  :id: 
- :author: alex
  :date: 2007-06-14 21:13:29 -07:00
  :body: |-
    My point was that if you had things like a person, their family and their friends you would expose them as things like, /people/fred, /people/fred/family, /people/fred/friends. If the friends and family resource are too specific, you may simply expose fred's relations as /people/fred/relations in a suitable representation. 
    
    Hi Jim, let me see if I can provide some elaboration.
    
    If you need fine-grained control over relations you have two choices, either expose each relationship as its own URI that can be managed with the usual HTTP verbs or simply allow clients to POST new representations of fred's relationships. I think you have to really get a grip on what clients of your service/site really want to do with this data. I think it's entirely acceptable to give clients a relatively generic URI (like /people/fred/contacts) and express the relations within the representation that is returned. If your clients really <i>need</i> specific, well-known subordinate nodes like 'spouse' or 'children' then your representation will have to deal with the domain-level problems like multiple marriages and the like.
    
    You are correct that exposing lots of fine-grained objects is a performance drain. I would add that I think it's an unfair burden for clients of your service/site to have to deal with all of these atomic pieces. A 1-to-1 mapping of domain model to REST resources is a pretty naive approach to resource design.
    
    Cheers,
    
    Alex
  :url: http://livollmers.net
  :id: 
- :author: Jim Cook
  :date: 2007-06-15 12:54:18 -07:00
  :body: |-
    Again, thanks for the discourse. This is helping to firm up my understanding of the challenges I have about SOA architectures. 
    
    I think REST is perfectly fine for the simple types of lookup services that are in use today (Google, Yahoo, Amazon, EBay, etc. and their APIs), but I struggle greatly with trying to understand how certain business applications would perform well, especially those applications with domain objects having rich relationships. This is where a Java object model and a lazy-loading infrastructure shine.
    
    Unfortunately, I haven't seen many examples of a properly implemented API in REST that supports full CRUD functionality on a rich domain model. Most online articles are simple such as read-only or a simple blog application.
    
    I agree with you that you would not want to expose a fine-grained object model via REST. I understand that a client should not calculate how much a customer has ordered this month by retrieving the customer, all his orders, and performing the calculation locally. 
    
    Sometimes however, the creation of an object does involve initializing a domain model with various hierarchies. 
    
    In our Person example, assume a collection of friends and a collection of children. Assume the Person objects who are in the friends collection don't exist in the domain model already, and the children do exist.
    
    Firstly, would the XML you pass to the REST service include nested XML structures for the friends collection?
    
    Secondly, how would I represent the children in this relationship given that they already have URIs that point to them?
    
    Thanks,
    Jim
  :url: ""
  :id: 
- :author: alex
  :date: 2007-06-15 18:56:57 -07:00
  :body: |-
    Thanks for hanging in on this thread Jim, it's a good discussion. I want to address your specific questions about the Person example, but before I do I want to make the assertion that REST is not object modeling. REST is an architectural style for exposing data and services. I bring this up because, while I think it's a small example to work with, the Person example we've been riffing on strikes me as mapping an object model to a resource model--not necessarily something I would want to expose.
    
    Nevertheless, it's a decent foil for our discussion. Let me address your specific question about Fred and his friends and children. Let's assume that the service being exposed is for Fred to declare who his friends and children (a Linked In knock-off perhaps?), <i>and</i> we're highlighting "friends" and "children" as important aspects of Fred. We'll say that Fred can modify his relations (let's ignore authorization and authentication) and that anyone can find out who Fred's friends and children are by issuing GET requests to <b>/people/fred/friends</b> and <b>/people/fred/children</b>, respectively.
    
    Today Fred decides he's ready to post a list of who his friends are. The easiest thing for the service designer to do is to enforce application-level validation that says that the representation Fred POSTs to <b>/people/fred/friends</b> has to be list of already-known URLs mapping to each related person.
    
    This is nice for the service designer, but not so fun for Fred. Fred now has to keep track of which of his friends are already known to our service and which ones aren't. One <em>could</em> apply some application-level heuristics to the POSTed representation that would find or create Person records for each relation prior to storing the actual relation. Whether or not we want to support that is driven entirely by what we want to support and is not constrained by REST. Resources are about pretty high-level, coarse-grained nouns. The constraint of the limited list of verbs we can apply to resources fundamentally shapes what boxes we draw around our resources. That's okay, I think this is a good thing. Also note that some of what we're talking about is really an application-level concern, meaning that the semantics are applied to the representations passed back and forth and aren't strictly expressed in the declaration of resources.
    
    Moving on, as for getting a representation of Fred's children, I'm assuming that all people are equal in this domain and that looking at Fred as a person and one of his children as a person are of equal value. If that's true then, yes, the GET of <b>/people/fred/children</b> would return a representation that <i>should</i> contain URLs indicating the canonical location of each child record. However that doesn't mean that we are limited in what else we can return in that representation. There's no need to speak exclusively in just URLs and force clients to perform additional lookup queries for each person. We can easily return immediately useful data like name, age, height, a description, etc. Again resources really describe the boxes we draw around resources, not necessarily what's in them.
    
    At the end of the day I think the key is thinking about the nouns you want to expose to the world. In some cases these might map to your domain model, but in a lot of cases they won't. Some resources may be views or calculations done on your domain. Second, the representations that are sent back and forth provide a lot of flexibility for the top-level domain logic. Some things such as the nuances of how other resources and entities are referred to are best left to the application level and not a concern of REST necessarily.
    
    I hope that provides some clarification.
  :url: http://livollmers.net
  :id: 
- :author: Jarne Cook
  :date: 2007-09-03 06:08:43 -07:00
  :body: |-
    Two key components of REST are Stateless, and Cacheable.
    
    How would one go about writing a web application for a bank, conforming to the REST way of thinking, while still providing at least the same level of security?
  :url: ""
  :id: 
excerpt: ""
date: 2007-06-13 02:42:58 -07:00
tags: ""
toc: true
-----
I first ran across REST in my reading about a year and a half ago. While it took me some time to “get” what REST was, I quickly became a fan. However I’ve found that aside from pure aesthetics, I’ve had a hard time articulating why REST is not only beautiful, but effective. I’ve spent a little more time thinking about REST and I think I may have a couple of concrete arguments for REST that go beyond a simple appreciation of its beauty.
<h1 id="uniformity_of_interface">![uniform interface](http://farm2.static.flickr.com/1030/543372651_5e789e984d_t.jpg)</h1>
<h1 id="uniformity_of_interface">Uniformity of Interface</h1>
When resources present a uniform interface, we can take advantage of this simplifying assumption. We can focus more on what we can do with resource rather than _how_ we interact with them. This simple convention takes a lot of churn out of the development and integration process.

Uniformity also constrains system design to the minimum required for distributed computing. Anything else is simply baroque elaboration that provides little to no value (think of SOAP’s `SOAPAction` directive) and is nearly always at the cost of the uniformity.
<h1 id="works_with_http">![works with http](http://farm2.static.flickr.com/1127/543397887_6a3775ded5_t.jpg)Works with HTTP</h1>
Assuming that you are going to provide data via the web, you are working within the constraints of HTTP. Since HTTP is an expression of the principles of REST, it is both foolish and counter-productive to go against the grain of HTTP’s architecture. Unfortunately, HTTP is a very misunderstood protocol. It is sad that so few people who develop with HTTP understand it so very little.

One of the least understood parts of HTTP are its caching mechanisms. Not only is caching misunderstood, it is terribly under-utilized. Most developers simply know caching as something to disable at all costs. This reflects an abuse of the protocol and an unnecessary effort expended to go against the grain.

When you express your resources as distinct URLs, you can take advantage of the built-in caching semantics HTTP provides. A large reason (though not the only reason) that many web developers work so hard to turn off caching is because their applications are verb-oriented and tend to operate through one or a few separate URLs.

Similarly, the semantics of content negotiation are also rarely well-understood let alone used in the wild. HTTP’s content negotiation mechanism separates the concerns of _what_ an underlying resource is from _how_ it will be represented. This is a _good_ separation of concerns—a user’s account details are a user’s account details regardless whether they are displayed in HTML, JSON or XML.
<h1 id="connectivity">Connectivity</h1>
<h1 id="connectivity">![connectivity](http://farm2.static.flickr.com/1021/543273982_040b8addae_t.jpg)</h1>
Connectivity is the way a web application connects within itself. One of Roy Fielding’s main assertions is that REST uses “hypermedia as the levers of application state”. This is achieved by the linked hypermedia returned by a resource. Connectivity provides further simplifying assumptions about how a site is connected. Instead of relying on complicated specifications like WSDL, consumers of REST-ful applications can use a lot more of a web application based simple guidelines.
<h1 id="the_design_analogy">The Design Analogy</h1>
<h1 id="the_design_analogy">![design](http://farm2.static.flickr.com/1065/543374965_8d8543c413_t.jpg)</h1>
Let’s try to put resources in terms of object-oriented design. A classic symptom of poor object design is where the functional aspects of the system are the first-class attributes of the system and any “objects” are simply data structures passed from function to function. Good object-oriented design puts the behavior right next to the data with a healthy sprinkling of encapsulation.

You wouldn’t have a single function that took an arbitrary number of parameters that could return an arbitrary type or amount of data or perform an arbitrary functions. The complexity would spiral out of control quickly and you would want to create some kind of taxonomy. In object-oriented design these emerge as objects that describe distinct domain entities. Why shouldn’t this apply to web applications and services?
<h1 id="your_checklist_for_winning_rest_arguments_around_the_watercooler">Your Checklist for Winning REST Arguments Around the Watercooler</h1>
So let’s sum this up into something you can print out, cut down to pocket-size and laminate and keep in your wallet:
- REST is about resources. There are an infinite number of these, but a very finite number of things you can do with them.
- This simplifying assumption makes client consumption of data simpler.
- This simplifying assumption makes for cleaner resource design.
- Since you’re using HTTP, you might as well use it correctly. Read [the spec](http://www.faqs.org/rfcs/rfc2616.html)!
- REST promotes connectivity. Express the connections between your resources and make your application more discoverable and navigable.
- REST prefers a separation of an abstract resource from its physical representation. This is good design.
