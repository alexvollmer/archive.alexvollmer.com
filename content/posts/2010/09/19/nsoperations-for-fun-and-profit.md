--- 
kind: article
permalink: nsoperations-for-fun-and-profit
created_at: 2010-09-19 16:54:43.913671 -07:00
title: NSOperations for Fun & Profit
tags: 
- cocoa
--- 

If you've spent any time working in Cocoa, you get very familiar with
asynchronous processing. It's the classic ["Hollywood Principle"](http://en.wikipedia.org/wiki/Hollywood_Principle "Hollywood Principle - Wikipedia, the free encyclopedia")
&mdash;don't call
us we'll call you. But what do you do when you have several simultaneous
asynchronous operations whose results depend on each other? The brute-force,
caveman approach is to simply have each callback method invoke a single method
that checks the results of each operation and then proceeds forward when
everything is completed. But by using Cocoa's `NSOperation` and
`NSOperationQueue` classes you can handle dependent, asynchronous operations
much more safely and elegantly.

# Kicking it Caveman Style #

Before diving into operations and queues, let's imagine doing this in the
"primitive" style. Let's say we have three operations: A, B, and C. Each does
some asynchronous work and we have no idea when it will complete. The
primitive way of handling this is to have each callback methods invoke a
single method that checks for the results of all three units of work. Only
when all three have returned do we continue processing. It might look
something like this:

<% highlight :objc do %>
// our final unit-of-work when all other operations have completed
- (void)checkAllOperationsAndProceed {
  if (self.resultA && self.resultB && self.resultC) {
    // do that magic thing you do
  }
}

// our mythical call-back methods

- (void)operationADidComplete:(id)result {
  self.resultA = result;
  [self checkAllOperationsAndProceed];
}

- (void)operationBDidComplete:(id)result {
  self.resultB = result;
  [self checkAllOperationsAndProceed];
}

- (void)operationCDidComplete:(id)result {
  self.resultC = result;
  [self checkAllOperationsAndProceed];
}
<% end %>

You can think of this as a "last-one-in-wins" pattern. It's kind of ugly and
doesn't scale well with more complicated dependencies. It gets worse when
you have specific threading concerns like working with Core Data, which is
notoriously fussy about threads.

I had this exact problem using Core Location and Game Kit. I use Core Location
to first retrieve the current location, while simultaneously communicating
with other devices via Game Kit. When the location is resolved, we then
attempt to reverse-geocode it which results in another asynchronous operation.
All of these bits of work are intertwined and update the underlying persistent
model in different ways. It didn't take too long before it spiraled completely
out of control. What's more, it was easy to hit odd edge-cases with
synchronizing various threads to keep Core Data happy. Since I wasn't getting
consistent failures, it was clear that there were race-conditions in the code.
Then a little voice in the back of my head reminded me that `NSOperation`
instances can have dependencies between each other. A ha!

# A More Elegant Weapon, for a More Civilized Age #

Maybe the caveman approach doesn't offend your sensibilities for such a
trivial example. But imagine a much more complicated set of dependencies, 
perhaps something that looked like this <sup><a href="#note1">1</a></sup>:

![operation dependencies](/images/2010/09/operation-dependencies.png)

Now imagine all the `if` checks and the spaghetti code that would be required
to make this work. I don't know about you, but this makes my Spidey-sense
tingle&hellip;and not in a good way.

So let's turn these into `NSOperation` instances with dependencies. We would
start with method prototypes and properties declarations like this:

<% highlight :objc do %>
@property (nonatomic, retain) NSOperationQueue  *operationQueue;
@property (nonatomic, retain) NSOperation       *operationA;
@property (nonatomic, retain) NSOperation       *operationB;
@property (nonatomic, retain) NSOperation       *operationC;
@property (nonatomic, retain) NSOperation       *operationD;
@property (nonatomic, retain) NSOperation       *operationE;
@property (nonatomic, retain) NSOperation       *operationF;

- (void)performOperationA;
- (void)performOperationB;
- (void)performOperationC;
- (void)performOperationD;
- (void)performOperationE;
- (void)performOperationF;
<% end %>

We'll do the actual work in instance methods of our class and wrap each
one with an instance of `NSInvocationOperation`. Here's our setup method:

<% highlight :objc do %>
- (void)initializeOperations {
  self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
  [self.operationQueue setMaxConcurrentOperationCount:1];
  
  self.operationA = [[[NSInvocationOperation alloc] initWithTarget:self
                                                          selector:@selector(performOperationA),
                                                           object:nil] autorelease];
                                                           
  self.operationB = [[[NSInvocationOperation alloc] initWithTarget:self
                                                          selector:@selector(performOperationB),
                                                           object:nil] autorelease];
                                                           
  [self.operationB addDependency:operationA];
                                                           
  self.operationC = [[[NSInvocationOperation alloc] initWithTarget:self
                                                          selector:@selector(performOperationC),
                                                           object:nil] autorelease];
                                                           
  self.operationD = [[[NSInvocationOperation alloc] initWithTarget:self
                                                          selector:@selector(performOperationD),
                                                           object:nil] autorelease];
                                                           
  [self.operationD addDependency:operationA];
  [self.operationD addDependency:operationC];
                                                           
  self.operationE = [[[NSInvocationOperation alloc] initWithTarget:self
                                                          selector:@selector(performOperationE),
                                                           object:nil] autorelease];
                                                           
  self.operationF = [[[NSInvocationOperation alloc] initWithTarget:self
                                                          selector:@selector(performOperationF),
                                                           object:nil] autorelease];

  [self.operationE addDependency:operationD];
  [self.operationE addDependency:operationF];
}
<% end %>

One interesting thing to note here is that the operations that have
dependencies could be queued right away. They won't execute until their 
dependent operations execute first. Another cool feature of `NSOperation`s 
is that dependent operations *don't* have to execute in the same operation
queue. Believe it or not, I've actually needed this very feature.

To execute these operations in the correct order, we simply need to add
them to the queue. If the dependencies are correctly declared, the order in
which we add them is irrelevant. Instead the final execution order is 
determined by the dependency graph of the queued operations<sup><a href="#note2"></a></sup>. 
So one of our asynchronous callback methods might look like this:

<% highlight :objc do %>
- (void)didGetSpecialCallback:(NSDictionary *)userInfo {
  self.firstName = [userInfo objectForKey:@"firstName"];
  self.lastName = [userInfo objectForKey:@"lastName"];
  [self.operationQueue addOperation:operationD];
}
<% end %>

The call to add `operationD` is *effectively* like invoking the 
`performOperationD` method except that it won't get executed until it's
two dependent methods, `operationA` and `operationC` have completed first.
But the beauty of all of this, is that my callback code doesn't have to care
about that ordering. 

Once your code has enough concurrent asynchronous operations that are
dependent on each other, this can be a great way of straightening out what
work is going to get done in a thread-safe way.

# Rules of Thumb #
## Queues Make Life Easy ##

One common principle of concurrency is being able to replace mutexes
(muteces?) with queues. Any time you have shared data operated on by multiple
threads, you can synchronize them with serial operations in a single queue
instead of using explicit locks. The operations in my app are lightning-quick
so I'm not worried about slowing things down with a single-threaded queue. A
great side-effect in using operations with dependencies is that I know
*precisely* what order those units of work are going to execute. This takes
away a slew of edge-cases that are difficult to reproduce and debug.

## Be Assertive ##

Because you know the order of operations, you can put a nice safety-net
underneath yourself as you develop with a liberal application of assertions.
For example, in the operation 'D', which requires that 'A' and 'C' have
completed, the code can expressly assert that effects of 'A' and 'C' have
been applied. If they aren't, it means there's a programming error:

<% highlight :objc do %>
- (void)performOperationD {
  @try {
    NSAssert(self.firstName != nil, "First name is nil!");
    NSAssert(self.lastName != nil, "Last name is nil!");

    // rest of method elided for readability
  }
  @catch (NSException * e) {
    NSLog(@"ERROR associating place with encounter: %@", e);
  }
}
<% end %>

## Try, Try Again ##

The last piece of advice is to make sure you put `@try/@catch` blocks in 
the methods that are executed by your operations. Since these are on a 
separate thread, you may not see a standard backtrace when an exception is
thrown. You need to handle this yourself, otherwise things may silently
fail. This is especially true of Core Data which will throw exceptions for
programming errors like accessing objects with the wrong thread.

<h1 id="footnotes">Footnotes</h1>
<ol>
  <li>
    <a name="note1"></a>
    This is a simplified version of the dependency graph of an application
    I'm currently working on, so it's not just some trite example I
    invented to make a point. Rather than saddle you with the mundane 
    details of each operation, I've chosen to go with the rather abstract,
    if boring, A-B-C nomenclature.
  </li>
  <li>
    <a name="note2"></a>
    Okay, that's not strictly true. Operations can also have different
    priorities which also affect the execution order. However assuming that
    all operations have the same priority, the original statement still
    holds true.
  </li>
</ol>