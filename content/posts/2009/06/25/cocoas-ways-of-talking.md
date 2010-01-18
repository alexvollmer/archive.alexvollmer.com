----- 
permalink: cocoas-ways-of-talking
title: Cocoa's Ways of Talking
date: 2009-06-25 01:53:32 -07:00
tags: ""
excerpt: ""
original_post_id: 386
toc: true
-----
Getting objects to talk to one another in Objective-C is a easy as passing a message from one to the other. These messages are typically passed through the message-invocation mechanism of using the square-braces to bind a message and arguments to a receiver. Most of the time this is a perfectly reasonable way to communicate. However there are times when you need objects to communicate _without having explicit knowledge of one another._

In this post we'll look at three ways to allow your objects to communicate with each other in a highly-decoupled manner using the Cocoa frameworks. Cocoa provides three common ways of connecting objects for messaging: Notifications, Key-Value Observation and delegate pattern.

### Notifications

Both Cocoa and Cocoa Touch provide a notifications framework built on two classes: `NSNotificationCenter` and `NSNotification`. The former contains a singleton instance, (via the `defaultCenter` method) with which observers register themselves and observables post notifications. The latter is the "envelope" for the notification which can contain an `NSDictionary` instance of customized data as its payload.

![NSNotificationCenter.png](/images/2009/06/nsnotificationcenter.png)

When an object registers for notifications, it specifies a notification to listen for (as a `NSString`) and, optionally, a target object. If the target is set to an object, only notifications posted by that object will be received. If the target object is set to `nil`, _any_ object posting that notification will be sent to the receiver. Senders can optionally include a `NSDictionary` instance filled with domain-specific objects. You can use this as a way to further parameterize a notification, or eschew it altogether.

Consider the example below:

<% highlight :objc do %>
@implementation Foo
- (void)init {
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNote:)
                                                 name:@"TheBigNotification"
                                               object:nil];
  }
  return self;
}

- (void)didReceiveNote:(NSNotification *)notification {
  NSLog(@"Hey, I got a notification with user info: %@", [notification userInfo]);
}
@end

@implementation Bar
- (void)doSomething {
  NSLog(@"I'm up to something!");
  NSDictionary *stuff = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"bar", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"TheBigNotification"
                                                      object:nil
                                                    userInfo:stuff];
}
@end
<% end %>

Here the `Foo` class registers itself as a notification receiver for the notification named "TheBigNotification" on _any_ object. The `Bar` class will post the same notification when the `doSomething` method is invoked. 

We could have been much more specific about which object to observe, but I think this violates one of the key features of notifications which is that the sender and receiver are decoupled. To me if the receiver is going to go to the trouble of listening for notifications from a specific object, you'd be better off declaring a custom protocol and using the delegate pattern (explained below).

While at the 2009 WWDC, I had a chance to pick the brains of some Apple engineers and one of them told me that notifications are really intended for one-to-many broadcasts. I think that's a great rule of thumb, because the code can really feel like overkill for single object-to-object messages. However, I'd add one more clause to that rule which is that notifications work for one-to-one messages when you would otherwise have to pass instances around of delegates just to connect objects.

As an example, consider an iPhone application with a stack of view controllers in a `UINavigationController` instance. If you have a view controller several steps removed from another view controller (i.e. one is a further up the stack in a tab bar controller) and it needs to call some method back to the view controller lower down in the stack, each intermediate object would need a reference to the delegate class just to pass it down the line. This seems like the worst kind of encapsulation breakage since you're forcing a bunch of otherwise-unrelated classes to have knowledge of a class they don't even use.

Maybe it's my long track-record with Java, but I pay attention to the classes I import and I like to keep that list as short as possible. The more classes know about each other, the more difficult it is to modify them.

There's one final thing worth knowing about the `NSNotificationCenter`, and that is how it works with threads. When one object posts a notification, that call blocks while the notification is delivered to _all_ targets. This means that you want your notification-handling code in the receiving object to be as quick as possible. If you can live with deferred notifications and want to avoid the synchronous nature of notification delivery, you can use the `NSNotificationQueue` instead.

### Key-Value Observation

When I first read about, and used Key-Value Observation (KVO) it seemed like magic. You simply point one object at another and say "I'd like to know when this attribute changes" and Cocoa handles all of the notifications and threading automatically. Genius!

KVO also allows you to use a special syntax when specifying the attributes you want to observe so that you can register with an object and traverse its object graph. Let's look at the classic customer/orders/line items example. If you want to know when changes are made to any line items in an order you would observe changes in the order like so:

<% highlight :objc do %>
Order *order = [self anyOrder];
[order addObserver:self
        forKeyPath:@"lineItems"
           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
           context:nil];
<% end %>


Whenever you register for KVO, you _must_ implement the method `- observeValueForKeyPath:ofObject:change:context:`. Unlike notifications, you don't get to specify a selector. This means that if you're object is observing several other objects, you will have to inspect the object given in the callback method and dispatch appropriately.

Key paths have a ton of flexibility including the ability to traverse deep object graphs and observe aggregate functions on a collection (e.g. observe the max date of all of a customer's orders). Check out the [Key-Value Programming Guide](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/KeyValueCoding.html) for details, which is an indispensable reference.

KVO works like notifications in that the thread that invokes the change will block until all observers have been notified and their callback methods have been invoked. Unlike notifications, there is no built-in asynchronous KVO-triggering mechanism unless you explicitly mutate properties in another thread using something like the `detachNewThreadSelector:toTarget:withObject:` class method of `NSThread`.

For classes to be key-value _observable_ they must be, what the documentation calls, "key-value compliant". This generally means that each observable property exposes certain methods for accessing and mutating them. Again, [the KVO guide](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/KeyValueCoding.html) is your go-to reference.

KVO is structurally similar to notifications, but is really intended for fine-grained messaging, generally around your model classes. Notifications are intended for broader application-level events. Both mechanisms give you a way to decouple classes that would otherwise need more intimate knowledge of one another.

Consider the simple case of managing a tabular view of line items in an order. When a user adds a line item, removes a line item or updates the quantity of a line item we want a field showing the total price to be updated. Without KVO we would need to add extra logic in our event-handing for the table view to also update the total field. With KVO our event-handling logic can simply focus on updating the underlying model. The total field will simply observe the total cost of the order and be updated appropriately. Now if we want to remove the total field or perhaps add another view of total information, we don't have to touch the original event-handing code.

### Delegates

If you've spent any time with the Cocoa docs you'll run across The Delegate Pattern. This thing is like the quark&mdash;it is the fundamental building block of the Cocoa APIs. Conceptually, it's really pretty simple. A delegate is simply an object that provides custom behavior for another object, often by implementing a specific protocol.

Let's return to our running example. A table view of line items in an order has to handle a lot of things such as rendering each cell, handling scrolling, managing user-generated events and so on. These features are common enough that they are simply part of the table view class itself. What is specific to your application is the _data_ that goes in those cells and _the actions_ to be taken for user-generated events. Cocoa solves this by providing protocols for delegating that behavior to custom classes. In the case of providing data, a data-oriented delegate would be queried by the table view for the total number of rows, appropriate object to put in each row, the column headers, etc. In the case of event-handling, the table view will forward events to the event-handling delegate.

Notifications use the `NSNotificationCenter` (or by proxy, the `NSNotificationQueue`) as an intermediary between message-senders and message-receivers. KVO uses the observed object as the intermediary. In the delegate model there is no intermediate object, but you still have relatively decoupled code because the object that invokes methods on the delegate has no knowledge of what _class_ of object it's dealing with. Put another way, you could remove all of the classes in your project that implement a particular delegate protocol, and the class that _uses_ the delegate would still compile correctly.

The delegate pattern isn't so much about decoupling which objects are communicating with each other, as much as decoupling the classes of those objects. This doesn't make it any less powerful than the other two methods. In a lot of cases a simple delegate model is much more straightforward and preferable the alternatives.

The delegate pattern is Cocoa's version of dependency injection. The object receiving the injected dependency has no idea of the type (and by extension, the implementation) of the object it is receiving, only what it's capabilities are via a contract specified as a protocol. This is basic polymorphism where the interface and the implementation are separated to reduce coupling.

Delegating is a popular alternative to sub-classing. It is a _preferred_ alternative because it's less likely to break encapsulation. If customization is done through subclassing it can be difficult to know which methods to override and implement, and easy to break the parent class. This is why Java provides all sorts of safety features like marking methods `abstract` and `final`. However that is simply more of a headache to deal with and using polymorphism would be a much better design.

So there you have it, three ways to keep your code flexible and loosely-coupled!

### Resources
*  [Apple's Notification Programming Topics](http://developer.apple.com/documentation/Cocoa/Conceptual/Notifications/Introduction/introNotifications.html)
*  [Apple's Key-Value Coding Programming Guide](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/KeyValueCoding.html)
*  [Apple's Cocoa Fundamentals](http://developer.apple.com/documentation/Cocoa/Conceptual/CocoaFundamentals/Introduction/Introduction.html)
*  [Mike Ash's Well-Reasoned Critique of KVO Design](http://www.mikeash.com/?page=pyblog/key-value-observing-done-right.html)
