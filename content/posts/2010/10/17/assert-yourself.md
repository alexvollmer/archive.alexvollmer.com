--- 
sha1: 289305d924de156ff41b0c7644f18da28de8e60a
kind: article
permalink: assert-yourself
created_at: 2010-10-17 09:46:11.116886 -07:00
title: Assert Yourself!
tags: 
- cocoa
- uiautomation
- TDD
--- 

Well lookee here. It's been a little while since the last post and wouldn't you
know it? I've got more stuff to share with you about UIAutomation. This time
it's about a new change made to <a
href="http://github.com/alexvollmer/tuneup_js">tuneup</a> that makes it much
easier and cleaner to assert what a particular window should look like. Like
everything in tuneup, this new feature was driven by something I really needed
out of it. I've tried pretty hard not to speculatively add features, instead
relying on the feedback of my own needs to drive its development.

As I've started writing more UIAutomation tests, I've found that there is
a common cycle to each test. Generally there is some bit of navigation to get
yourself somewhere in the app, then you assert a bunch of things about the
view, and usually navigate somewhere else. I don't think this is far off from
how you might verbally describe how the app might work. For example, you
might say: "Go to the main screen, the left button should say 'Cancel' and the
right button should say 'Done'. Fill in the username and password fields then
tap the 'Done' button. On the next view you should see the user name in a table
cell and another cell to add another account".

It's fairly straightforward process translating that description into test
code:

<% highlight :javascript do %>
test("account setup", function(app, target) {
  // initial view
  window = target.mainWindow();
  navBar = window.navigationBar();
  assertEquals("Cancel", navBar.leftButton().name());
  assertEquals("Done", navBar.rightButton().name());

  table = window.tableViews()[0];
  assertEquals("Enter your credentials:", table.groups()[0].name());
  assertEquals(2, table.cells().length);

  userName = table.cells.firstWithName("username");
  userName.textFields()[0].setValue("user boy");
  password = table.cells.firstWithName("password");
  password.textFields()[0].setValue("sekret");

  navBar.rightButton().tap();

  // verify new account on settings view
  navBar = window.navigationBar();
  assertEquals("New", navBar.rightButton().name());
  table = window.tableViews()[0];

  assertEquals(2, table.groups().length);
  assertEquals("Your accounts:", table.groups()[0].name());
  assertEquals("", table.groups()[1].name());

  assertEquals(2, table.cells().length);
  assertEquals("user boy", table.cells()[0].name());
  assertEquals("Add Account", table.cells()[1].name());
});
<% end %>

One window's worth of activity isn't so bad, but once you get beyond that, it's
pretty easy to lose track of what you're trying to do. Comments help a bit, but
if our code had the same structure that matched the way we think about our
tests, it would be even better. Now you can do exactly that with a new assertion
method in tuneup: `assertWindow()`.  Here's the previous example, re-stated
with `assertWindow()`:

<% highlight :javascript do %>
test("account setup", function(app, target) {
  assertWindow({
    navigationBar: {
      leftButton:  { name: "Cancel" },
      rightButton: { name: "Done" }
    },
    tableViews: [
      {
        cells: function(cells) {
          cells.firstWithName("username").textFields()[0].setValue("user boy");
          cells.firstWithName("password").textFields()[0].setValue("sekret");
        }
      }
    ],
    onPass: function(window) {
      window.navigationBar().rightButton().tap();
    }
  });

  assertWindow({
    navigationBar: {
      rightButton: { name: "New" }
    },
    tableViews: [
      {
        groups: [
          { name: "Your accounts:" },
          { name: "" }
        ],
        cells: [
          { name: "user boy" },
          { name: "Add Account" }
        ]
      }
    ]
  });
});
<% end %>

So what's going on here? Using `assertWindow()`, we've replaced several lines
of procedural code with a javascript object-literal that declares how to match
the current window. The property-nesting in the object given to
`assertWindow()` (the "expectation") is matched against the property-nesting of
the `UIAWindow` object representing the current view. For example, when we
declare a `navigationBar` property in our expectation object, it is matched
against the object returned by the `navigationBar()` function invoked on the
main window (an instance of `UIANavigationBar`). Then the `rightButton`
property is matched against the object returned by the `rightButton()` method
(an instance of `UIAButton`). Finally the `name` property is matched against
the object returned by invoking the `name()` function on the button, which in
this case is a `String`.

You can do more than just match `Strings` though. You can also match numeric
literals or regular expressions. These are done by applying the `assertEquals()`
and `assertMatch()` functions, respectively. You can also completely customize
your assertions by providing a function for the property. The corresponding
object will be given to the function as its single argument. If any exceptions
are thrown the assertion fails, otherwise the assertion passes.

`assertWindow()` also knows how to handle properties that return arrays (or
`UIAElementArray`s). In the example above we matched the `tableViews` property
by declaring an array with one element. The number of elements you put in the
property declaration implicitly makes an assertion about the number of elements
that should be in the property. If you are only interested in matching *some*
of the elements in an array, you can set `null` for the elements in the array
you don't care to make assertions about. This will allow you to still pass the
array-length check without forcing you to write assertions you don't care to.

The `onPass` property is an optional function you that will be invoked if all
of the assertions pass. This is a handy way to group assertions and actions
together in one package. In the example above, we use the `onPass` function as
post-assertion navigation to the next screen.

You can find all the gnarly details in the `assertions.js` file in tuneup. As
always comments, feedback, forking and patches are all welcome and appreciated.
Now go out and assert yourself!

