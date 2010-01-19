----- 
kind: article
permalink: the-iphone-and-web-apis
created_at: 2009-05-27 03:57:39 -07:00
title: The iPhone and Web APIs
excerpt: ""
original_post_id: 366
tags: 
- iphone
- cocoa
- REST
- evri
toc: true
-----
# The iPhone Ecosystem

We live in a very interesting time for application development. The distinctions between desktop, browser and mobile applications are blurring more and more every day. "Ubiquitous platform" applications, like [Evernote](http://evernote.com), are where the future is because it reduces the major hurdle of access for users. As time goes on users are going to expect applications to be available in a bunch of different ways that all need to work together.

The common way to do this is base the application on shared-state accessed via an HTTP-based API. This makes it relatively easy to create apps for various devices as well as offer up a public API for others to use. An interesting side-effect of this is that the API, the shared-state and data behind it become the differentiator between products. The end-user client software is simply the packaging, turning the stand-alone application market into something more akin to the "razors and razor-blades model".

Okay, none of this should be earth-shattering news to anyone. You should be prepared to write more apps that are integrated with one (or possibly more) "backend services". These services will, as likely as not, be connected over HTTP. As an iPhone developer you should know how to do this in your sleep.

The [Evri](http://www.evri.com) API is absolutely crucial to the EvriVerse phone application. Without it, the app does _nothing_ of interest on its own. Our iPhone application is merely one kind of presentation of our web APIs. I don't think that's unique. What good would Tweetie be without Twitter?

# Dealing with Web APIs

An unfortunate fact of integrating with web APIs is that they are, relatively speaking, slow. We don't want the user to get frustrated and give up on our app because they have their flow continually disrupted by waiting for data.

There are some things you can do to mitigate the latency costs, if you control the API such as using some sensible caching parameters. However, especially if you don't control the web API, the bulk of what you should focus on is _concurrency_ within your application. The biggest arrow in your quiver is figuring out how to turn unnecessarily serial operations into parallel ones. Now keep in mind that the iPhone doesn't support true multi-core concurrency. What I'm talking about is taking advantage of the I/O wait times that are inherently part of working with a high-latency I/O source (the web).

Coming from a Java background, using threads seemed like a pretty natural approach and after reading the docs on the `NSThread`class I felt pretty confident I knew how to make it work. However, I was surprised by how quickly the code complicated. There is a lot to like about Objective-C, but I sorely miss Ruby's blocks and even Java's inner-classes. In Objective-C you connect methods together dynamically by handing objects selectors. The problem with this is that it's difficult to tell the high-level methods from the low-level callback methods just by looking at your class definition. Yes, you can use special comments and the like, but if you've worked in a language that has _structural_ support for this differentiation, moving to a language without it feels like losing an arm.

So instead of managing your own threads, let Cocoa Touch do the work for you. The `NSURLConnection` class is inherently asynchronous&mdash;you can fire a request and immediately move one with your life. Now you just need a little structure for handling the response and getting it back into your views.

# The EvriApi

We tried to push as much of the mechanics of URL-handling into a separate code-base we call [EvriApi](http://github.com/evri/EvriApi). A good bit of the design was inspired by Matt Gemmell's [MGTwitterEngine](http://mattgemmell.com/2008/02/22/mgtwitterengine-twitter-from-cocoa), so I can't claim that I came up with the whole idea myself.

We wanted the API to be as simple to work with as possible. Each API call has the same structure:
*  Each API method takes zero-or-more domain-specific parameters, a selector and a target object.
*  Each API method returns a unique request identifier
*  The target object will have the given selector called when the request completes, and will be given an instance of the `EvriAPIResponse` class.
*  If the response is successful (check `[response success]`), the payload of the request is retrieved as a domain-object
*  If the response is unsuccessful, check the error message on the response
*  Requests can be cancelled by handing the request identifier back to the API
*  Attempts to cancel already-completed requests do nothing


The `NSURLConnection` class makes asynchronous requests by default, and uses the familiar delegate model for handling the response. When a client invokes an API method, it returns immediately with a unique identifier (as a `NSString` instance) and the request is initiated on another thread which is handled automatically by `NSURLConnection`. The client is responsible for keeping track of that and using it to cancel any outstanding requests.

When the request completes, the body of the response is parsed using the `NSXMLParser` class. The parser is given one of our specialized XML handlers as a delegate. These handlers deal with the XML event-stream and produce a model object or collection of model objects. The framework then packages this up into an `EvriAPIResponse` instance and invokes the selector given in the original request on the target given in the original request.

# Wiring it Up

The EvriVerse app is primarily a "productivity" style application. In [Interface Guidelines](http://developer.apple.com/iPhone/library/documentation/UserExperience/Conceptual/MobileHIG/Introduction/Introduction.html)-parlance this means that we use a lot of hierarchical navigation. In general we have no more than one or two API calls associated with a particular view controller. 

The common pattern for handling a user-initiated action that requires an API call is:

1.  A new view-controller is instantiated and displayed, typically with an activity indicator visible
2.  User-interaction is disabled on the new view controller
3.  The new view controller is displayed (usually by pushing it on the navigation controller stack).
4.  A request is submitted to the `EvriApi`, setting the new view controller as the target and some special method as the target selector.
5.  The request ID from the `EvriApi` is given to the newly-created view-controller
6.  When the API request finishes, the handler method on the new view-controller executes, handling both success and failure cases. It also re-enabled user interaction on the view.
7.  If the user navigates back before the request has completed, any outstanding requests are cancelled. This is usually handled in the `viewWillDisapper:(BOOL)animated` method of the view controller.

Stepping back, the actors and interactions look something like this:

![evri-api.png](/images/2009/05/evri-api.png)

In code (snippets) it might look something like this:

    // our parent view controller
    @implementation ParentViewController
    - (void)didSelectEntity {
      ChildViewController *cvc = [[[ChildViewController alloc] init] autorelease];
    
      [self.navigationController pushController:cvc animated:NO];
    
      NSString *requestId = [EvriApi fetchEntityByURI:entity.uri
                                      performSelector:@(didReceiveEntityResponse:)
                                             onTarget:cvc];
    }
    @end



    @interface ChildViewController : UITableViewController {
      NSString *requestId;
    }
    
    @property (nonatomic, retain) NSString *requestId;
    @end
    
    @implementation ChildViewController
    
    @synthesize requestId;
    
    - (void)didReceiveEntityResponse:(EvriAPIResponse *)response {
      // TODO: hide the activity indicator
      // TODO: re-enable user interaction
    
      if ([response success]) {
        Entity *e = (Entity *)[success result];
    	 // TODO: redisplay as necessary
      }
      else {
        // TODO: show an alert
      }
    }
    
    - (void)viewWillDisappear {
      [EvriApi cancelRequest:requestId];
    }
    
    @end


So there you have it, one developer's way of integrating the iPhone with web APIs. More to come. Stay tuned.
