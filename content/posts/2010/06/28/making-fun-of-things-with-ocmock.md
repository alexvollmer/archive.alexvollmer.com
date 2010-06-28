--- 
permalink: making-fun-of-things-with-ocmock
title: Making Fun of Things with OCMock
kind: article
tags: 
- cocoa
- TDD
created_at: 2010-06-28 09:35:27.048314 -07:00
---

OK, I've done [plenty of ranting about the state of TDD in Cocoa development](http://alexvollmer.com/posts/2010/06/01/cocoas-broken-tests/ "Alex Vollmer &mdash; Cocoa's Broken Tests").
So instead of inflicting more
whining on your ears, I've decided to figure out how to get better at this.
This is the first in a series of posts I'll be doing about testing in Cocoa.
We're going to look at OCMock, a framework for creating and
using mock objects in your Cocoa tests. 

This isn't the only tutorial out there on OCMock, but hopefully it's the
clearest. I found the documentation on the site to be a bit, ahem, lacking. As
a result I ended up figuring out how to use it by going through the source
code<sup><a href="#note1">1</a></sup>.

# Installation #

First, you need to download the [OCMock project](http://www.mulle-kybernetik.com/software/OCMock/ "Mulle kybernetiK -- OCMock").
Before Xcode 3.2.3, you used to be able to simply add the `OCMock.framework`
to the "Link Binary With Libraries" build phase of your unit tests. This
[appears to have stopped working](http://www.mulle-kybernetik.com/forum/viewtopic.php?f=4&t=73 "Mulle kybernetiK &bull; Information"),
so you have two options: you can include the OCMock source Xcode project
and declare a build dependency on its static library target, or you can build
the static library once and put the following header files somewhere accessible
to your Xcode build:

  * `NSNotificationCenter+OCMAdditions.h`
  * `OCMArg.h`
  * `OCMConstraint.h`
  * `OCMock.h`
  * `OCMockObject.h`
  * `OCMockRecorder.h`

I didn't want to rebuild the library over and over so I built the static 
library once and put the `libOCMock.a` and `OCMock.h` files in a directory
in my project and added that directory to the `LIBRARY_SEARCH_PATHS` in the
unit-test target configuration <sup><a href="#note2">2</a></sup>.

# Underlying Concepts #

I'm assuming that you already know what [mock
objects](http://en.wikipedia.org/wiki/Mock_object "Mock object - Wikipedia,
the free encyclopedia") are and how to use them. I'm not going to explain
their value here, or the design changes you end up making to accommodate them.
Mock objects are simply one of many tools you can employ in your testing. They
have their pros and cons so let experience and intuition be your guide.
Instead, I want to focus on how to use OCMock.

The general recipe for using mocks in unit-tests is:

  1. Create the mock object
  2. Specify the expected invocations and return values
  3. Associate the mock object with the code under test
  4. Execute the code under test
  5. Validate that your assertions are correct

It's worth spending some time looking at the test cases that come with the
OCMock source code. The coverage is quite good so it's a great demonstration
of OCMock's capabilities.

## Making Mocks ##

To create a mock object, use one of the factory methods available on the
`OCMockObject` class: `+mockForClass:`, `+mockForProtocol:` or
`+partialMockForObject:`. There are also two variants of this called "nice"
mocks, which you can get by calling either `+niceMockForClass:` or
`+niceMockForProtocol:`. The difference between a "nice" mock and regular
(mean? stand-offish?) mock, is how they behave when they receive an unexpected
method invocation. A "nice" mock will simply ignore the unexpected invocation,
whereas a regular mock will raise a `NSException`.

Factory Method           | Description                                        
------------------------ | -------------------------------------------------  
`+mockForClass:`         | Create a mock based on the given class             
`+mockForProtocol:`      | Create a mock based on the given protocol          
`+niceMockForClass:`     | Create a "nice" mock based on the given class      
`+niceMockForProtocol:`  | Create a "nice" mock based on the given protocol   
`+partialMockForObject:` | Create a mock based on the given *object*          
`+observerMock:`         | Create a notification observer (more on this later)

If you're like me and you like to keep your builds free of compiler warnings,
declare the returned object to be of type `id` to shut the compiler up.

<% highlight :objc do %>
id myMock = [OCMockObject mockForClass:[MyClass class]];
<% end %>

The `+partialMockForObject:` method allows you to turn an existing object into
a mock. This can be useful in cases where a collaborating object has several
of its methods invoked, but you only want to override one or two. The obvious
dangers here are that, 1) your collaborating class probably violates the
[Single-Responsibility
Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle
"Single responsibility principle - Wikipedia, the free encyclopedia") and 2)
your tests now indirectly rely on the subtleties of which methods you mocked
and which you didn't. Use at your own peril.

## Setting Expectations ##

The object returned by any of these factory methods allows you to both
setup expectations, invoke methods and verify its configuration. OCMock does
a clever little trick to distinguish between invocation configuration and
handling method invocations. Calling either the `-expect` or `-stub` method
will return an object that you can use to setup your expectations. The cool
thing about this object is that you setup your expectations by (more or less)
invoking the methods on it that you want your class under test to invoke.

Let's imagine that we have a simple stock-portfolio management application.
Our portfolio model is encapsulated by the `AVStockPortfolio` class. An
instance of that class is given an object that implements the `AVQuoteService`
protocol, which is our gateway to a real-live stock quote service. When we
test the `AVStockPortfolio` class, we don't want to be encumbered with a
"production" implementation of `AVQuoteService`. Instead we want to craft
a stand-in object to exercise and validate the portfolio class.

Our first test is to see that the portfolio class initiates a connection
with the quote service in its `init` method:

<% highlight :objc do %>
- (void)testInit {
  id mockService = [OCMockObject mockForProtocol:@protocol(AVQuoteService)];
  [[mockService expect] initiateConnection];
  
  AVStockPortfolio *portfolio = [[AVStockPortfolio alloc] initWithService:mockService];
  
  [mockService verify];
}
<% end %>

When the `-expect` method is called, it returns a ["trampoline" object](http://www.cocoadev.com/index.pl?TrampolineObject "CocoaDev: TrampolineObject")
that captures additional method calls dynamically. Any methods invoked on
the service that I haven't explicitly configured will raise an exception. I
can also check that the methods I've configured were all invoked by calling
the mock object's `-verify` method.

You can also configure your mock object to act as a more forgiving "stub" for
particular methods by using `-stub` instead of `-expect` 
<a href="#note3"><sup>3</sup></a>. Admittedly, the ability to turn a so-called
"mock" object into a "stub" for particular method invocations muddies the
nomenclature a bit, but it can be handy to have this ability at times.

### Return Values ###

If methods on your mocks need to return values, you have a variety of methods
to call on the object returned by `-expect` or `-stub`. Any method we call on
this object that isn't one of the built-in OCMock methods, is captured
dynamically as an expected method invocation.

Method               | Explanation                                        
-------------------- | -------------------------------------------------  
`-andReturn:`        | Return the given object                            
`-andReturnValue:`   | Return a non-object value (wrapped in a `NSValue`) 
`-andThrow:`         | Throw the given exception                          
`-andPost:`          | Post the given notification                        
`-andCall:onObject:` | Call the selector on the given object              
`-andDo:`            | Invoke the given block (only on OS X 10.6 or iOS 4)

Since each of these methods returns the same expectation object, you can
chain these method calls, where it makes sense. For example to post a 
notification *and* return a specified value we could do this:

<% highlight :objc do %>
NSNotification *notfication = [NSNotification notificationWithName:@"foo" object:nil];
[[[mock expect] andPost:notfication] andReturn:@"FOOBAR"] doSomethingMagical];
<% end %>

The `-andDo:` option is one of my favorites since it uses blocks and blocks
are the most awesome addition to Objective-C in a long time. You can do a lot
of validation locally within a block which keeps the code very succinct and
clean:

<% highlight :objc do %>
- (void)testSellSharesInStock {
  id quoteService = [[OCMockObject] mockForProtocol:@protocol(AVQuoteService)];
  [[[quoteService expect] andDo:^(NSInvocation *invocation) {
    // validate arguments, set return value on the invocation object
  }] priceForStock:@"AAPL"];
  
  AVStockPortfolio *portfolio = [[AVStockPortfolio alloc] initWithService:quoteService];
  [portfolio sellShares:100 inStock:@"AAPL"];
  
  // other validations and assertions
  
  [quoteService verify];
}
<% end %>

### Arguments &amp; Return Values ###

Basic method expectations are useful, but we also want to validate the
arguments given to methods. Back to our stock portfolio, imagine that when
we buy a stock, we know that part of that process is to ask for the current
price of a stock from a stock service, so we want to assert that when we
sell a particular stock, our portfolio object queries the quote service for
the latest price for the same stock symbol:

<% highlight :objc do %>
- (void)testBuyShares {
  id mockService = [OCMockObject mockForProtocol:@protocol(AVQuoteService)];
  [[mockService expect] andReturn:[NSNumber numberWithFloat:214.57]] priceQuoteForSymbol:@"AAPL"];
  
  AVPortfolio *portfolio = [[AVPortfolio alloc] initWithQuoteService:mockService];
  [portfolio buyShares:100 inStock:@"AAPL"];
  
  // other validation and assertions

  [mockService verify];
}
<% end %>

In this case, we're declaring the expected argument to be the string
literal `@"AAPL"`. We've also configured the method with a return value, in
this case a `NSNumber` instance with the value `214.57`. However, OCMock can
do more. You can use any of the following `OCMArg` class methods in place of
a real argument when setting up your method expectations:

`OCMArg` method                | Description                                                 
------------------------------ | ----------------------------------------------------------  
`+any`                         | Any argument is accepted.
`+anyPointer`                  | Accepts any pointer                                         
`+isNil`                       | The given argument *must* be `nil`                          
`+isNotNil`                    | The given argument must *not* be `nil`                      
`+isNotEqual:`                 | Given argument is not object-equivalent with expectation    
`+checkWithSelector:onObject:` | Check the argument with the given action/target pair        
`+checkWithBlock:`             | Check the argument with the given block (OS X 10.6 or iOS 4)

OCMock also provides a few handy macros for argument matching:

Macro                         | Description                                                        
----------------------------- | -----------------------------------------------------------------  
`OCMOCK_ANY()`                | Equivalent to `[OCMArg any]`                                       
`OCMOCK_VALUE(value)`         | A quick way to match a non-object argument                         
`CONSTRAINT(selector)`        | Validate with a given selector on `self`                           
`CONSTRAINTV(selector,value)` | Validate with a given selector on `self` and an additional argument

### But Wait&hellip;There's More! ###

One nice little feature of OCMock is its handy support for testing
notifications. To create a mock for notifications, call the `+observerMock`
factory method on the `OCMockObject` class. This will return a mock that works
differently from the mocks/stubs described earlier. Instead of setting up
method invocation expectations, you can set up notification expectations which
are useful when you want to assert that your class under test posts
notifications. Let's say that we want our aforementioned portfolio class to
post notifications whenever stocks are bought or sold:

<% highlight :objc do %>
- (void)testSellSharesInStock {
  id mock = [OCMockObject observerMock];
  // OCMock adds a custom methods to NSNotificationCenter via a category
  [[NSNotificationCenter defaultCenter] addMockObserver:mock
                                                   name:AVStockSoldNotification
                                                 object:nil];
                                               
  [[mock expect] notificationWithName:AVStockSoldNotification object:[OCMArg any]];

  AVPortfolio *portfolio = [self createPortfolio]; // made-up factory method
  [portfolio sellShares:100 inStock:@"AAPL"];

  [mock verify];
}
<% end %>

If the `AVStockSoldNotification` isn't posted by the time we call `verify`,
the mock will raise an exception. Note that you need to add the mock as an
observer, which you can do by the handy `-addMockObserver:name:object:`
category method on `NSNotificationCenter` provided by OCMock.

## Execution &amp; Validation ##

Any method invoked on your mock object will be checked against the configured
invocations. Any unexpected invocations will result in an exception being
thrown (unless it's a stub or the mock is in "nice" mode). Also, any configured
invocations that did *not* happen will trigger an exception when the mock's
`-verify` method is called. As a matter of habit, you want to call this at the
end of your test.

# Conclusion #

Using mocks, stubs and test-doubles in your testing is a handy way to keep
your tests lean and focused on one class at a time. This is especially 
helpful when you have dependent classes that require a lot of setup that
you would rather avoid in your test-harness (e.g. Core Data).

The downside to testing with mocks and stubs is that you lose some test
coverage for the objects you're replacing with test-doubles. This approach
probably works best when your code is interacting with objects from other
libraries that you don't want to deal with in your tests.

<h1 id="footnotes">Footnotes</h1>
<ol>
  <li>
    <a name="note1"></a>
    I know it seems like a drag, but it's hard to overestimate the value of
    reading the original source code for any tool that you use. You'll be
    amazed at how much more of an intimate understanding it gives you of
    the tool and the rationale behind its design.
  </li>
  <li>
    <a name="note2"></a>
    I forked the OCMock codebase and have started to make a few tweaks to it.
    Feel free to take a look at it on <a href="http://github.com/alexvollmer/OCMock" title="alexvollmer's OCMock at master - GitHub">GitHub</a>.
  </li>
  <li>
    <a name="note3"></a>
    If you aren't familiar with mocks vs. stubs, Martin Fowler has written
    the <a href="http://martinfowler.com/articles/mocksArentStubs.html" title="Mocks Aren't Stubs">canonical text</a> on the differences.
  </li>
</ol>