--- 
permalink: more-uiautomation
title: More UIAutomation
kind: article
tags: 
- cocoa
- TDD
created_at: 2010-07-09 07:14:06.519853 -07:00
---

After having spent another week with Apple's UI Automation framework, it's
clear that to really wring the most benefit out of it, you need to roll up
your sleeves and extend what's already there. One area that UI Automation
gives you no help is establishing an initial state for your application to run
your tests against. So this week I hacked something to do just that.

# Why We Do What We Do #

Before moving forward, it's probably worth reviewing what my goal is with
UI Automation (or any integration testing setup for that matter). To me,
testing, whether it's  unit-testing or integration-testing, is all a matter
of economics. There is a balance to be struck between the up-front investment
in the test harness and the long-term risk mitigation that it provides. One
of the things that has frustrated me about test automation in Cocoa is how
expensive it can get to build and maintain this stuff compared to other
environments I've worked in. At a certain point, if the cost is too high,
I'm perfectly willing to abandon the effort.

<img src="/images/2010/07/thx1138.png" class="right"/>

I like to think of it like the last scene of the film *THX-1138*. There's a
wonderful shot in the command and control center that shows the running cost
of pursuing the escaped fugitives. At a certain point the cost exceeds the
budget of the pursuit and the hounds are called off. That's somewhat like my
attitude toward test automation. It's not an absolute, totalitarian,
philosophical must-have. I only insist on it when it makes sense.

# Setting the Stage #

The UI Automation toolkit provides *a portion* of what I think we need for an
effective integration-test suite, but not all of it. A good suite would have
the following properties:

  1. runs on the device or simulator with equal ease
  2. has a rich API to dig deep into the details of the running system
  3. is extensible so that we can build abstractions over the aforementioned 
     rich API
  4. is completely automatable from the command-line for continuous integration 
     builds
  5. provides a way to set your application in particular states as a 
     pre-condition for tests

UI Automation covers the first three items, but completely misses on the
fourth item. It doesn't help with the last item, but doesn't necessarily
preclude a solution either.

What I did was create a special block of code in my application delegate that
looks for some extra configuration in the application plist file. Since I 
don't plan on ever needing any of this stuff in a release, it's all guarded
by an `#ifdef` statement.

<% highlight :objc do %>
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
#ifdef MEECHU_RESET_FOR_TESTING
  NSArray *operations = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MUTestHarnessOperations"];
  if (operations) {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    for (NSString *opName in operations) {
      Class clazz = NSClassFromString(opName);
      NSOperation *op = (NSOperation *)[[[clazz alloc] init] autorelease];
      [queue addOperation:op];
      NSLog(@"Enqueued operation: %@", NSStringFromClass(clazz));
    }
    
    [queue waitUntilAllOperationsAreFinished];
    [queue release];
  }
#endif

  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}
<% end %>

In the special block, if I find the string array associated with the key
`MUTestHarnessOperations` in the application plist, I treat each string as a
class name which is instantiated and added to an operation queue. Now I don't
have any concurrency requirements which led me to use an `NSOperationQueue`.
Instead, it seemed like a nice way to package up discrete bits of work.

One of these setup classes creates an account (an instance of `MUAccount`)
that some of my tests rely on. It looks something like this:

<% highlight :objc do %>
@interface AddTwitterAccountOperation : NSOperation {
}
@end
<% end %>

<% highlight :objc do %>
#import <CoreData/CoreData.h>

#import "AddTwitterAccountOperation.h"
#import "MUAccount.h"
#import "AccountType.h"
#import "MeechuAppDelegate.h"


@implementation AddTwitterAccountOperation

- (void)main {
  MeechuAppDelegate *meechu = (MeechuAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  NSPersistentStoreCoordinator *coordinator = [meechu persistentStoreCoordinator];
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
  [moc setPersistentStoreCoordinator:coordinator];
  
  MUAccount *newAccount = [MUAccount insertInManagedObjectContext:moc];
  newAccount.identifier = @"alexvollmer";
  newAccount.type = @"twitter";
  newAccount.password = @"supersekret";
  newAccount.enabled = [NSNumber numberWithBool:YES];
  
  NSError *error = nil;
  if ([moc save:&error]) {
    NSLog(@"Added twitter account for 'alexvollmer'");
  }
  else {
    NSLog(@"ERROR: Unable to create test twitter account: %@", error);
  }
   
  [moc release];
}

@end
<% end %>

Once I've built up a library of these setup actions, I create a different
build configuration for each combination of setup actions. Each of those
configurations uses a specific application plist file with the 
`MUTestHarnessOperations` key set to an array with the appropriate setup
class names.

<p><img src="/images/2010/07/plist.png"/></p>

To create a new build configuration, I just duplicate the existing debug and
modify two settings: the name of the application plist file, and defining the
`MEECHU_RESET_FOR_TESTING` symbol for the preprocessor.

<p><img src="/images/2010/07/plist-configuration.png"></img></p>

<p><img src="/images/2010/07/cflags-configuration.png"></img></p>

If I build and run a configuration of the application with a particular
collection of setup actions, that application will *always* run with those
setup actions. This is exactly what you need for repeatable testing.

Now it's simply a matter of choosing the correct application build and test
script in Instruments:

<p><img src="/images/2010/07/select-app.png"></img></p>

You can save your Instruments files off to capture the combination of the test
script and executable. One thing to keep in mind is that Instruments won't
build your code. If you have a failing test and you're making fixes, you
need to re-build the executable in Xcode then re-run the test in Instruments.
You don't need to reconfigure Instruments, it will just use whatever version
of the executable you have at the specified path.

# Conclusion #

OK, this works, but I think it's pretty hacky. There are still way too many
steps to go through and interface points that need to be configured correctly.
I'm sure there's a more elegant, less error-prone way to do this. If you think
of it, please tell me. I'm only 50% satisfied with this. 

There's a lot I really like about UI Automation, but it is missing a few key
ingredients that make me think long and hard about using it long-term. This
test setup approach is somewhat workable. Now we just need to address the
remaining issues of scriptability and complete automation.
