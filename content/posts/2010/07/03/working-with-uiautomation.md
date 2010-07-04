--- 
permalink: working-with-uiautomation
title: Working with UIAutomation
kind: article
tags: 
- cocoa
- TDD
created_at: 2010-07-03 08:55:23.605149 -07:00
---

In this post we're going to look at the UI Automation library/tool that Apple
added to iOS SDK 4.0. This is a huge step forward for test automation on the
iOS platform. While it's not without some compromises, it's worth looking at
to see if you can reduce the time you spend on manual testing.

UI Automation is both a probe for Instruments as well as a JavaScript library
provided by Apple to exercise and validate a running application. In this case,
"running application" isn't restricted to the simulator&mdash;you can also
automate the application on a real device. To my knowledge, this is the first
time I've heard of anyone being able to do this. 

This is huge. Having the ability to automate workflows in your application
yields two benefits: you cut down on manual testing which saves you time,
*and* you can rely less on your memory to execute all your tests. Instead, you
just push a button (okay, two or three buttons) and run your full regression
suite. Have I piqued your interest yet?

# Preparing Your Application #

First, you need to do a little groundwork to prepare your application to work
with the automation tool. The UI Automation library relies on accessibility
information in your UI, so adding a little accessibility info to your UI will
make testing it easier<sup><a href="#note1">1</a></sup>. More specifically,
the UI Automation framework looks for the `accessibilityLabel` property of
your `UIViews`. If you've built any web applications, this is somewhat akin to
sprinkling `id` attributes in your HTML markup so that you can find particular
DOM nodes easily with JavaScript.

<img src="/images/2010/07/ib-accessibility.jpg" class="right, break"/>

For views constructed in Interface Builder, you can set this property in the
Inspector in the "View Identity" tab (the fourth one). Note that not every
kind of view provides accessibility configuration in Interface Builder 
<sup><a href="#note2">2</a></sup>. You need to enable Accessibility and you
need to provide a Label value. You'll use these later in your tests to
identify particular views.

If you aren't using IB or your view doesn't expose accessibility information
graphically, you can still set it manually in your code. You can set the
`isAccessibilityElement` and `accessibilityLabel` properties to get the same
effect:

<% highlight :objc do %>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // cell configuration elided
  
  cell.isAccessibilityElement = YES;
  cell.accessibilityLabel = @"user name"
  return cell
}
<% end %>

# Writing Your Tests #

The next step is to write your first test in JavaScript<sup><a href="#note3">3</a></sup>
in your editor of choice. This step is a bit like being dropped off in a field
somewhere with no map, tools or supplies and being told you need to build a
house. There's no built-in structure for your tests. When you execute a test
script, Instruments will run it from beginning to end in linear fashion.

To get started you need to get a reference to the running application from
which you can access all the other parts of the app. Put these two lines of
boilerplate at the top of your test:

<% highlight :javascript do %>
target = UIATarget.localTarget();
application = target.frontMostApp();
<% end %>

The `UIATarget` is your primary portal into the application running on the
device or simulator. It acts as a sort of proxy for the user of the
application and is the object you interact with when you want to perform
operations on the device such as fiddling with volume controls, shaking, or
performing user gestures. The application object (a `UIAApplication`
instance), gives you access to the top-level structure of your application for
things like the navigation bar, tab bars, and the main window.

The `UIAApplication` class has a `mainWindow()` method that returns a 
`UIAWindow` instance. This class is an extension of `UIAElement` which nearly
all of the other UI-related classes derive from. This class provides access
to things like the parent view, child views, links, pickers, sliders, table
views and nearly anything else you can imagine.

While Apple didn't provide much high-level information about UI Automation in
the form of a Programming Guide, the UI Automation Reference Guide is worth
bookmarking or keeping handy in PDF format. This is an essential reference
that describes the JavaScript API in great detail. Check the Xcode
documentation.

So let's look at a real example <sup><a href="#note4">4</a></sup>. 
Let's say we have an application connects
to a variety of popular web sites. When the user launches the app for the 
first time, we want to detect that they don't have any accounts configured
and prompt them to create one. Our screen might look something like this:

![Choose an account type](/images/2010/07/account-types.png)

We want to verify that when we launch the application we see this screen. Once
we've verified this, we want to create a twitter account, so we'll select the
"twitter" table cell. Here's the test script so far:

<% highlight :javascript do %>
test("Initial screen", function(target, app) {
  // check navigation bar
  navBar = mainWindow.navigationBar();
  assertEquals("Add Account", navBar.name());
  button = navBar.leftButton();
  assertEquals("Back", button.name());

  // check tables
  table = mainWindow.tableViews()[0];
  tableGroup = table.groups()[0];
  assertEquals("What type of account?", tableGroup.name());

  assertEquals(4, table.cells().length);
  ["facebook", "flickr", "github", "twitter"].each(function(i,e) {
    assertNotNull(table.cells().firstWithName(e));
  });
  
  // more to come...
}
<% end %>

The `test`, `assertNotNull` and `assertEquals` functions are ones I wrote to
add some structure and high-level validation to the testing process. I found
the way the UI Automation suite does test case declaration to be really
verbose and crude so I boiled test declaration into something simpler. First,
the `test()` method takes a string title and a function to execute as the
body:

<% highlight :javascript do %>
function test(title, f, options) {
  if (options == null) {
    options = {
      logTree: true
    };
  }
  target = UIATarget.localTarget();
  application = target.frontMostApp();
  UIALogger.logStart(title);
  try {
    f(target, application);
    UIALogger.logPass(title);
  }
  catch (e) {
    UIALogger.logError(e);
    if (options.logTree) target.logElementTree();
    UIALogger.logFail(title);
  }
}
<% end %>

This handles the boilerplate of getting the target and application references.
It also provides some structure around `UIALogger.logStart()`,
`UIALogger.logPass()` and `UIALogger.logFail()`. These three methods are how
the UI Automation framework demarcates tests. However I found that using `if`
checks and calling `logFail()` really muddied the tests, so I wrote some
assertion methods that throw exceptions and the test structure automatically
catches them and logs the test as a failure.

Here are the assertion methods:

<% highlight :javascript do %>
function assertEquals(expected, received, message) {
  if (received != expected) {
    if (! message) message = "Expected " + expected + " but received " + received;
    throw message;
  }
}

function assertTrue(expression, message) {
  if (! expression) {
    if (! message) message = "Assertion failed";
    throw message;
  }
}

function assertFalse(expression, message) {
  assertTrue(! expression, message);
}

function assertNotNull(thingie, message) {
  if (thingie == null || thingie.toString() == "[object UIAElementNil]") {
    if (message == null) message = "Expected not null object";
    throw message;
  }
}
<% end %>

Whew. Still with me? OK, back to our test. Next we want to fill out the text
fields in the next view with our twitter credentials:

![Enter twitter credentials](/images/2010/07/twitter-creds.png)

We extend the test code above with the next set of stimuli and assertions:

<% highlight :javascript do %>
  // create a new account
  table.cells().firstWithName("twitter").tap();
  mainWindow = app.mainWindow();
  table = mainWindow.tableViews()[0];

  userName = table.cells().firstWithName("user name");
  assertNotNull(userName, "No username field found");
  userName.textFields()[0].setValue("mrfoobar");

  password = table.cells().firstWithName("password");
  assertNotNull(password, "No password field found");
  assertNotNull(password.secureTextFields()[0], "No text field found for password");
  password.secureTextFields()[0].setValue("sekret");
  
  finish = table.cells().firstWithName("finish");
  assertNotNull(finish, "No finish button found");
  finish.tap();
  
  // more to come...
<% end %>

The first line above finds the "twitter" cell by calling the `firstWithName()`
method on the collection of cells in the table view. This table view was 
generated programmatically, so that "twitter" label came from setting the
cell's `isAccessibilityElement` property to `YES` and its `accessibilityLabel`
property to `@"twitter"`. Next we touch that table cell via the `tap()` method
to navigate forward in our application.

The next two stanzas validate that we have user name and password fields, and
also fills them out using the `setValue()` method. Finally we look for the cell
that contains the "Finish" button and tap it to finish creating our account.

![Our landing point, the settings screen](/images/2010/07/settings-screen.png)

The last bit of testing to do here is to validate that we did indeed land
on our settings screen. So we add a few more assertions to our test:

<% highlight :javascript do %>
  // validate settings screen
  finish.waitForInvalid();
  mainWindow = app.mainWindow();
  assertEquals("Settings", mainWindow.navigationBar().name());
<% end %>

Here I call the `waitForInvalid()` method on the finish button object. Without
this, I found that the other code executed too quickly before the window
transition completed. The `waitForInvalid()` will wait (up to a configurable
timeout value) for that object to be invalidated. Our last assertion is that
the title in the navigation bar is "Settings".

# Running Your Tests #

Now that we have a test, we need to run it in Instruments. When you launch
Instruments, choose "Automation" from the iPhone templates.

![Automation template in Instruments](/images/2010/07/choose-automation.png)

In the details for the Automation instrument, choose your script via the
"Choose Script&hellip;" drop-down. Next, you need to choose your target from
the toolbar. Once you have these setup, you run the flow by (somewhat
counter-intuitively) hitting the record button (or using ⌘+R). This will
launch your application, wait a few seconds and then run your test. Note that
even if your test completes, Instruments will keep running your application.
To formally end the test toggle the red record button, or hit ⌘+R again.

Tests are listed in the detail view, with the test name in the "Log Messages"
column. If your test passes, the "Log Type" value will be "Pass" in comforting
green. If your test fails, the value is "Fail" in scary red. You can expand
the test to see the details of what happened. Because of the way I wrote the
test structure above, any test failures automatically log the view hierarchy
for inspection.

![A test failure](/images/2010/07/test-failure.png)

# Debugging Your Tests #

When things go wrong with your tests you don't have a lot to look at. However
there are a few things you can inspect to try to figure out what's broken.
First, log the element tree (via `UIATarget.logElementTree()`) liberally and
often. Although view hierarchy is a tree and it's presented in a tree control,
it's "flattened-out" out for display purposes. However, the numeric prefix
listed in each row indicates the level that node is at, so you can infer
parent-child relationships:

![The tree hierarchy](/images/2010/07/tree-hierarchy.png)

In this case, the tree looks something like this:

  * `UIATarget`
    * `UIAApplication`
      * `UIAWindow`
        * `UIATableView`
          * `UIATableGroup`
            * `UIAStaticText`

You don't always have to traverse the entire tree, node-by-node, to find what
you're looking for. Take a look at the various methods on the `UIAElement`
class and experiment a bit.

You can also log any message you choose using any of these log methods on
the `UIALogger` class:

  * `logDebug()`
  * `logMessage()`
  * `logWarning()`
  * `logError()`

All of these just log messages of varying severity, but don't affect whether
or not the test is marked as passing or a failure.

# Building on UI Automation #

While Apple may not have provided much support for automation testing beyond
a JavaScript API and a reference doc, they (wisely) left the whole mechanism
open to easy extension. You can import other JavaScript into your tests with
the `#import` statement. I'm not 100% sure how smart that statement is
with regard to paths, but I found that if you put supporting scripts in the
same directory as the test script you're executing, Instruments will 
automatically pick it up.

So I took the extensions I mentioned earlier, plus a few more, and put them
into a small, but growing, JavaScript library I call [tuneup_js](http://github.com/alexvollmer/tuneup_js "alexvollmer's tuneup_js at master - GitHub").

You can simply copy all of the JavaScript files into the same directory as
your automation tests. For my project, I created a separate directory called
"Automation Tests" and dumped everything in there. This is pretty crude and
I'd like to improve it, but I need to spend some more time figuring out the
nuances of how Instruments handles paths in `#import` statements.

Please check it out, file bugs, send patches and/or your feedback.

# Stepping Back #

These kind of tests are high-level, flow-oriented tests that exercise entire
scenarios. As much as possible, these run against a "real" system though,
at times, you may swap out external dependencies with mocked ones in order
to control the test environment and execution. 

There have been other third-party open-source projects that have addressed the
lack of good automation testing. In particular
[iCuke](http://github.com/unboxed/icuke "unboxed's icuke at master - GitHub")
and [UISpec](http://code.google.com/p/uispec/ "uispec - Project Hosting on
Google Code") both have a lot going for them. If you like
[Cucumber](http://cukes.info/ "Cucumber - Making BDD fun"), iCuke is nice for
writing integration tests. It's pretty impressive what they've been able to
accomplish on their own. Personally I prefer the Cucumber approach to
integration tests. However, because iCuke uses a small embedded web server and
XML to exercise and validate the UI, I found that I often ran into time-out
issues and got frustrated wrestling with XPath expressions to validate my UI.

What iCuke has going for it, and what Instruments can't do, is the fact that
you can automate the entire process. As far as I can tell, there isn't a good
way to automate getting Instruments to run your automation tests. I hope this
is something that either Apple addresses, or somebody figures out a clever
hack for.

![iCuke responds](/images/2010/07/robholland-twitter.png)

I like the way the Apple library is connected to the running application. It
definitely feels "first-class" compared to iCuke's implementation 
<sup><a href="#note5">5</a></sup>. Let's hope that we can bring the two
approaches together to have one fantastic automation tool.

One thing that <strike>none of these tools</strike> UI Automation can't really help you with
is building reliable, repeatable test harnesses. One of the hardest parts of
making good integration tests is setting up application state to test various
modes of your application. This is one of the reasons why xUnit-style tests
don't work well for automation. Too often people write fine-grained tests that
have an implicit order, each test relying on the side-effects of the previous
one. This makes your tests highly-coupled and extremely brittle.

In my application I have a couple of initial application states to test. None
of these tools provides much help for that. For now, I've chosen to sprinkle
a few `#ifdefs` around in my app delegate to setup the application in a
known state. Then I use different build configurations to build separate
binaries, each with a different known initial state. There's no doubt that
it's a bit Rube Goldberg-esque, but it's a start.

There is a growing list of options available out there for writing automated
integration tests for your iPhone apps. Apple's UI Automation tool is just
one of them. It has it's pros and cons, but it's a big step forward in the
right direction. Now it's up to us to figure out how to build upon them,
develop extensions and idioms around them and, ultimately, build better
apps.

# Resources #

As I stated earlier, there isn't much out there in the way of documentation,
but here are a couple things to look at:

  * [UI Automation Reference Collection](http://developer.apple.com/iphone/library/documentation/DeveloperTools/Reference/UIAutomationRef/Introduction/Introduction.html "UI Automation Reference Collection")
  * [O'Reilly Answers Post on UI Automation](http://answers.oreilly.com/topic/1646-how-to-use-uiautomation-to-create-iphone-ui-tests/ "How to use UIAutomation to create iPhone UI tests - O'Reilly Answers")

<h1 id="footnotes">Footnotes</h1>
<ol>
  <li>
    <a name="note1"></a>
    I don't know if this was a ploy to get developers to be more mindful
    of disabled users or not, but the net-result is a win for everyone. You 
    get better test automation and disabled users get better apps.
  </li>
  <li>
    <a name="note2"></a>
    I haven't spent the time to figure out which ones do and don't so perhaps 
    there's some kind of rhyme and reason to this.
  </li>
  <li>
    <a name="note3"></a>
    I have to admit that I was surprised to see JavaScript as the language
    of choice given Apple's support of the <a href="http://www.macruby.org/" title="MacRuby &raquo; Home">MacRuby</a> 
    project. JavaScript has had to weather a lot of bad press over the 
    years. It's a language that has a lot of quirks but, once you separate 
    it from the vagaries of various browser implementations, you'll find that
    it's a pretty flexible and expressive language.
  </li>
  <li>
    <a name="note4"></a>
    This comes from a real app that I've been working on. You can't beat
    learning new things from a real project.
  </li>
  <li>
    <a name="note5"></a>
    No disrespect meant for the iCuke team. Honestly, they've done an 
    awesome job, I can't wait to see where they go next. Definitely keep
    your eye on this project.
  </li>
</ol>
