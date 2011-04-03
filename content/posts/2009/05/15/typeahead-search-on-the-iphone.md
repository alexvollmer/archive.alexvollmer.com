----- 
sha1: 1dec79493027638c0e310d97073a4939b49fea16
kind: article
permalink: typeahead-search-on-the-iphone
created_at: 2009-05-15 04:55:38 -07:00
title: Incremental Find on the iPhone
excerpt: ""
original_post_id: 340
tags: 
- iphone
- cocoa
toc: true
-----
This is the first in a series of posts I'll be writing about my experiences developing the [EvriVerse iPhone application](http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=312716560=8) for [work](http://evri.com). Since the end of 2008 I've been getting more and more into Cocoa for both the iPhone and Mac. The more I work on it, the more fun I have. I've got several side-projects in mind so I'll be spending a lot more time in Cocoa-land and, as a result, blogging and tweeting about it a lot more.

I wanted to kick this off with a little appetizer. We're going to look at how we implemented incremental find in EvriVerse. Evri has a huge database of structured entity data (people, places and things) and our users want to be able to search for any of them. After putting the initial prototype for EvriVerse on a few folks' phones, a lot of them wanted a search feature that worked more like our website.

![Picture 5.png](/images/2009/05/picture-5.png)

In the original implementation a user would type in the search field, then hit the "Search" button and then get their results back in the table view. This takes too many steps, and we wanted something that felt faster and more responsive.

<img src="/images/2009/05/picture-6.png" class="right"/>

So our incremental find solution needed the following properties:

*  It should only send a search request when there is a measurable pause in input
*  It should enable some kind of activity indicator while a search request is running
*  A user should be able to modify the contents of the search field while a search request is in-progress
*  It should not preclude the existing two-step search process
*  If a search request is in process when another one starts, the first one should be cancelled and the new one should be the only request in-process

At first I tried managing my own `NSThread` instance while tracking the timestamps of touch events in the `searchBar:textDidChange:` method (part of the `UISearchBarDelegate` protocol). If the the gap between time samples was big enough I'd cancel any outstanding request and start a new one. This seemed like a good approach at the whiteboard, but really fell apart in the implementation. I had race-conditions left and right and I had the sneaking suspicion that I was swimming upstream against "the Cocoa way". 

As an aside, if there's one thing I've learned in my brief time with Cocoa, it's that mucking about with your own threads is a pretty crummy way to do things asynchronously. Usually there's a much more elegant, built-in solution in the Cocoa APIs that will handle the threading for you. I'll riff on this theme in a later post.

So back to the problem at hand. What to do? When I get stuck like this I often start thinking of how I'd do this in another language. This got me to thinking about how one would go about implementing this sort of thing in Javascript. This is standard Web-2.0 kind of stuff&mdash;right after drop-shadows and rounded corners, you learn about type-ahead search at AJAX School.

See, Javascript has this very nifty little function named `setTimeout` where you hand it a function and tell it how long you want to wait until that function is executed, and it returns you a reference identifier. There is a companion function, `clearTimeout` that allows you to cancel any previously-created "timeout" function by handing it the reference identifier you got earlier from `setTimeout`.

In the common AJAX-ified dynamic search that you often see, an event-handler observes the search field in a web form for key presses. Each key press cancels any existing timeout function, and starts a new one that will execute in whatever time-interval was chosen as the "quiescence period". The trick is that because you're scheduling future tasks, _and_ you cancel any outstanding ones when you kick off a new one, you get the "measurable pause" feature in a simple, elegant solution.

Cocoa provides a very similar mechanism, through the `NSTimer` class. In my view-controller, the code ended up looking something like this:

<% highlight :objc do %>
@implementation FindViewController
// much implementation code has been elided for demonstration purposes

// observe text-field changes and fire the scheduled task
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if ([searchText length] > 2) {
    if (timer) {
      [timer invalidate];
      self.timer = nil;
    }
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:searchText, 
                          @"Text", 
                          nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(submitSearchRequest:)
                                                userInfo:info
                                                 repeats:NO];
  }
}

// The method that runs in the NSTimer--equivalent to the function 
// we'd pass to Javascript's "setTimeout" function
- (void)submitSearchRequest:(NSTimer *)aTimer {
  NSDictionary *info = [aTimer userInfo];
  NSString *text = [info objectForKey:@"Text"];
  [activityIndicator startAnimating];
  self.requestId = [EvriApi fetchEntitiesMatchingPrefix:text
                                        performSelector:@selector(didReceiveEntitiesDynamically:)
                                               onTarget:self];
}

// The callback from our API class, included for completeness
- (void)didReceiveEntitiesDynamically:(EvriApiResponse *)response {
  [timer invalidate];
  self.timer = nil;
  [activityIndicator stopAnimating];
  if ([response success]) {
    [entities removeAllObjects];
    [entities addObjectsFromArray:(NSArray *)[response responseObject]];
    [tableView reloadData];
  }
  else {
    UIAlertView *error = [[UIAlertView alloc] 
                          initWithTitle:@"Uh oh&hellip;"
                          message:@"Sorry, we were unable to execute your request. Please try again.
"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [error show];
    [error release];
  }
}

@end
<% end %>

In the `searchBar:textDidChange:` method we check to see if our instance field, `timer`, points at an existing `NSTimer` instance. If it does we cancel it, clear the reference, and start a new timer instance. That timer is configured to run in one second and will execute our `submitSearchRequest:` method. This makes a call to our API and designates the `didReceiveEntitiesDynamically:` method as the callback for that asynchronous operation.

Finally, the `didReceivedEntitiesDynamically:` method handles the UI by disabling the wait indicator, dealing with any error cases and populating our table view if our request was successful. I'll write another post later about how the `EvriApi` class works and its design.

So that's it. Simple and elegant. One of the things I love about working on several different programming languages is figuring out how to apply the best tricks of one language to another.

That's all for now, but stay tuned! More iPhone posts to come&hellip;
