--- 
kind: article
permalink: uiautomation-test-fixtures-redux
created_at: 2010-09-06 14:41:13 -07:00
title: UIAutomation Test Fixtures Redux
tags: 
- iphone
- TDD
- cocoa
- uiautomation
--- 

In my ongoing exploration of the UIAutomation tool, I've iterated several
times on implementing test fixtures. In this context, "test fixture" means
a pre-defined starting state for the system-under-test (SUT). In my case, my 
test fixtures are focused almost exclusively on the current state of the
persistent Core Data database. While I think this is an obvious case of an
integration-test fixture, it's not the only possibility.

# It's About Dependencies

I think it's worth backing up and explaining why I've spent so much time
noodling on test fixtures. Any system of moderate complexity has features that
depend on the existence of other features. For example it doesn't make sense
to have a "recover your forgotten password" feature without having an
authentication feature that requires a password in the first place. If you
drew each of your features in a box then drew a line between each feature and
its prerequisite features, you would have a graph of feature-dependencies.
<sup><a href="#note1">1</a></sup>

When we design a system, we look for patterns in these dependencies. If we're
smart enough and have enough experience, we'll do our best to reduce those
dependencies, and figure out how to minimize the coupling between them. When
we get this wrong, we something that gets hard to maintain and change
over time.

A big part of using dependency-analysis in our design is figuring out exactly
at what level our features are dependent upon each other. In our
forgotten-password example, the question to ask is *how much of the
user-authentication feature does recovering a forgotten password depend on?*.
To answer this question, you have to start imagining different ways the
authentication feature could be implemented. Which ones would break the
forgotten-password feature? Which ones would make it irrelevant?

From the perspective of system-design it makes no sense to tie the
implementation of the forgotten-password feature to the form-submission
process of authentication. Instead, these features *should* be coupled at
wherever you store authentication information (likely a database). You should
be able to modify the authentication process without directly breaking the
forgotten-password feature.

Returning to automated testing, the same idea applies. But I think a lot of
people don't factor their tests this way. Instead, a lot of test-writers
get so wrapped-up in code reuse that they often recycle tests of dependent
features as a way of getting the SUT into a starting state. This is a mistake.
Just like we wouldn't over-couple the implementations of dependent features,
we should't over-couple our tests for them. If we do, we end up with a
very brittle suite of tests.

We also end up losing a lot of feedback from the testing process. If the
authentication test is failing, does that necessarily mean we should invalidate
all the other tests that use authentication information? Logically, the answer
is *no*. But with test-reuse that's exactly what we get. So when one feature
breaks and a bunch of tests fail, we have no idea just how broken the system
really is.

# A New Perspective

<img class="right" src="/images/2010/09/meechu-test-fixtures.png"/>

Coming back to UIAutomation, I made the decision early on to build test
fixtures that focused on the current persistent state of the system. Much of
the logic of the application revolves around the state of Core Data database.
I made a conscious decision to couple the features at the persistent-store
layer so, by extension, I've done the same for my test-fixture code.

In my [first
attempt](http://alexvollmer.com/posts/2010/07/09/more-uiautomation/ "Alex
Vollmer &mdash; More UIAutomation"), I built a rather complicated Rube
Goldberg contraption that simply wasn't going to scale as I added more
fixtures. The first problem I needed to solve was to cut down on the amount of
build variation. My original solution involved a separate build-configuration
for each test-fixture. The problem was that my tests had an implicit
dependency on a particular test build, but I had no way to express that with
UIAutomation. The best I could do was simply add comments to the top of my
tests. Blech. Too easy to get that wrong and waste a bunch of time figuring
out why things weren't working. This is *not* what I want out of my
integration tests.

So the first step was to get rid of the separate build configurations. I
replaced them with a single "Integration Test" build configuration that
defines a build-time variable that is used in my app delegate like so
<sup><a href="#note2">2</a></sup>:

<% highlight :objc do %>
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
#ifdef MEECHU_RESET_FOR_TESTING
  self.testFixturesController = [[[TestFixtureViewController alloc] initWithDelegate:self] autorelease];
  [window addSubview:[self.testFixturesController view]];
#else
	[window addSubview:[navigationController view]];
  [self checkFirstTimeUser];
#endif  
  [window makeKeyAndVisible];
}
<% end %>

If the `MEECHU_RESET_FOR_TESTING` compiler flag is set, we insert a special
test-fixture controller into the UI. That view controller is simply a
control-board for running any number of pre-defined test-fixture operations.
Here's an example of one such operation that completely nukes my Core Data
database:

<% highlight :objc do %>
@implementation ClearAllDataOperation

- (void)main {
  MeechuAppDelegate *meechu = (MeechuAppDelegate *)[[UIApplication sharedApplication] delegate];
                                                    
  NSPersistentStoreCoordinator *coordinator = [meechu persistentStoreCoordinator];
  NSError *error = nil;
  for (NSPersistentStore *store in [coordinator persistentStores]) {
    [coordinator removePersistentStore:store error:&error];
    if (error) {
      NSLog(@"Unable to remove persistent store %@: %@", store, error);
      return;
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:[store URL] error:&error];
    if (error) {
      NSLog(@"Unable to remove persistent store file %@: %@", [store URL], error);
    }
    
    if (! [coordinator addPersistentStoreWithType:[store type]
                              configuration:nil
                                        URL:[store URL]
                                    options:[store options]
                                            error:&error]) {
      NSLog(@"Unable to create new persistent store at %@: %@", [store URL], error);
      return;
    }
  }
}

@end
<% end %>

I have a couple of other test-fixture operations like this. All of them
fiddle with the underlying Core Data database.

The next step was to create some kind of first-class representation of this
"control-board" in my JavaScript layer. So I wrote a small wrapper for the
test-fixture view controller:

<% highlight :javascript do %>
TestFixtures = {
  ensureFixturesMenu : function() {
    this.target = UIATarget.localTarget();
    this.application = target.frontMostApp();
    this.mainWindow = this.application.mainWindow();
    assertEquals("Test Fixtures", application.navigationTitle());
  },
  
  addTwitterAccount : function() {
    this.ensureFixturesMenu();
    cell = this.mainWindow.tableViews()[0].cells().firstWithName("addtwitteraccountoperation");
    cell.tap();
  },
  
  addEncounters : function() {
    this.ensureFixturesMenu();
    cell = this.mainWindow.tableViews()[0].cells().firstWithName("addencounterhistoryoperation");
    cell.tap();
  },
  
  clearAllData : function() {
    this.ensureFixturesMenu();
    cell = this.mainWindow.tableViews()[0].cells().firstWithName("clearalldataoperation");
    cell.tap();
  },
  
  close : function() {
    this.mainWindow.navigationBar().rightButton().tap();
  }
};
<% end %>

With these in place, the final task was explicitly defining the test-fixtures
for each automation test. Now the pre-requisites for the test are specified
right in the test, which greatly clarifies the pre-requisites for the test:

<% highlight :javascript do %>
#import "tuneup/tuneup.js"
#import "fixtures.js"

test("Additional Account", function(target, app) {
  TestFixtures.clearAllData();
  TestFixtures.addTwitterAccount();
  TestFixtures.close();

  // test continues here
});
<% end %>


Now when the tests run, the test-fixture view controller appears, the test
pokes a button for each fixture operation it requires, dismisses the
test-fixture setup and continues on its merry way.

# Conclusion

This is definitely a step forward, but I think there is some more refinement
to be had. First, there's still too much duplication for my tastes. For each
new test-fixture operation I have to update the view controller as well as the
JavaScript wrapper file. I don't think it would take too much effort to
automatically generate the view controller and wrapper JavaScript code simply
by snooping the directory that contains the test-fixture operation classes in
the same way [Xmo'd](http://rentzsch.github.com/mogenerator/ "mogenerator + Xmo’d") 
does for Core Data models and generated classes.

<h1 id="footnotes">Footnotes</h1>
<ol>
  <li>
    <a name="note1"></a>
    It's amazing how much a simple drawing exercise can reveal about your
    project in ways that simply reading the code doesn't. I've found it 
    really helpful to sketch stuff out with paper and pencil or use
    <a href="http://www.omnigroup.com/applications/omnigraffle/" title="OmniGraffle for Mac - Products - The Omni Group">OmniGraffle</a> for quick box-sketches.
  </li>
  <li>
    <a name="note2"></a>
    You could argue that having separate builds isn't strictly necessary.
    All I'm really trying to do is avoid having test-related code in my
    final application bundle. That could simply be expressed by the
    differences between the stock "Debug" and "Release" build configurations.
  </li>
</ol>
