----- 
permalink: using-closures-to-support-object-oriented-ajax
title: Using Closures To Support Object-Oriented AJAX
excerpt: If you want object-oriented design in your JavaScript when using AJAX, you need to understand closures.
date: 2005-12-14 16:27:47 -08:00
tags: ""
toc: true
-----
_updated 1/23/2006_

Coming from a Java background, I can't resist turning any moderately
involved JavaScript into a collection of objects that encapsulate data
and behavior. A majority of the JavaScript that I have come across is
decidedly non-object oriented and tends to be a library of functions
that are attached to various event handlers. This style works well
with AJAX, but loses the advantages of cohesive object-oriented
design. I won't re-hash the OO vs. functional programming argument
here, but it must be pointed out that if you want OO design in your
JavaScript when using AJAX, you need to understand closures. This
article describes why they are important and how they work.

Just what the heck are closures? Closures are a way of creating
function definitions with a particular scope chain attached to
them. Closures allow [lexical
scoping](http://en.wikipedia.org/wiki/Lexical_environment#Static_scoping)
to work correctly with nested functions. For a more refined (and
perhaps accurate) definition, see this [exhaustive discussion of
closures in
JavaScript](http://jibbering.com/faq/faq_notes/closures.html). 

If you are creating JavaScript classes and object instances of those
classes, you know that liberal use of the `'this'` keyword is what
binds your object together and gives it cohesion. However when using
AJAX the `'this'` keyword starts to take on different meaning because
it is no longer refers to the same object it referred when you setup
your `XmlHttpRequest`. 

Let's explore some examples. These all use the [prototype
framework](http://prototype.conio.net/) developed by Sam Stephenson. 

In our examples below we have a `User` object that has a reference to
its HTML element (the 'div' argument passed in the constructor). As we
add more functionality to the `User` we like having that direct
reference to the div corresponding with the JS object. 

The last line in the constructor calls the `retrieve()` method which
fires off an AJAX request. When that request has returned, we want to
populate our div element with the response text using the `load()`
method. 
Ex. 1

    function User(username, password, div) {
      this.username = username;
      this.password = password;
      this.div = div;
      this.retrieve();
    }

    User.prototype.update = function(req) {
      this.div.innerHTML += req.responseText;
    }
    
    User.prototype.retrieve = function() {
      var myAjax = new Ajax.Request('/users/demo',
        { method:'get', 
           onComplete:this.update
        });
    }

Note the `'onComplete'` property of the anonymous object given as the
last parameter to the `Ajax.Request`. This is a pointer to our
function that will handle the response. Since this is all happening
within our `User` instance, we should still have a reference to that
all-important div element that ties our object to the UI. 

Unfortunately this doesn't work. When the `Ajax.Request` calls the
function specified in the `'onComplete'` property, you get a JS error
saying that 'this' doesn't have a property called 'update'. Why?
Because in this context, 'this' is no longer your `User` object--it is
the `XMLHttpRequest` object instead.  

How can that be? Because the response for the `Ajax.Request` is
executing in a separate execution context in the browser, the meaning
of `'this'` has changed. The `'this'` reference is no longer defined
by its lexical scope (the `User` instance), but by its dynamic scope.  

OK, so if `'this'` changes meaning across contexts, perhaps we can
fool the JS engine. 

Ex. 2

    User.prototype.retrieve = function() {
      var _this = this; // don't overload the meaning of 'this'
      var myAjax = new Ajax.Request('/users/demo', 
        { method:'get', 
           onComplete: _this.update
        });
    }

Instead of referring to `'this'` in our `'onComplete'` property we
refer to a new variable `'_this'`. The `'_this'` variable that points
to `'this'` which, in this particular context, refers to our `User`
instance.

Close but no cigar. You will still get JS errors saying that the
`'this'` reference inside the `update()` method does not have a
reference to a div (as in `'this.div'`). Hmmm, we seem to be making
progress--now at least we're calling the right method, but `'this'`
still isn't referring to our instance. 

Now what's going on? Because of JavaScript's dynamic nature, even
getting a reference to an object instance's method doesn't mean that
`'this'` always refers to the instance object. Unlike Java where
`'this'` _always_ refers to the instance containing the method,
`'this'` means different things in JavaScript. This is somewhat
analagous to Python's `'self'` reference which essentially passes in
the object instance reference to method.  

Back in JavaScript, `'this'` changes meaning depending on the context
in which it is used. So how can we get enough context around the
reference to `update()` to make the instance method run properly? 

Ex. 3

    User.prototype.retrieve = function() {
      var _this = this; // don't overload the meaning of 'this'
      var myAjax = new Ajax.Request('/users/demo',
        { method:'get', 
           onComplete:function(req) { _this.update(req); } 
        });
    }

Enter the Closure. Now the `'onComplete'` property refers to a little
anonymous function that, when called by `Ajax.Request`, will have a
reference to our `User` instance (`_this`) and will call the update
method on it. Now we have built enough context around the entire
`User` instance to get it's instance methods to run. 

Note that this is very different from doing something like this:

    User.prototype.retrieve = function() {
      var myAjax = new Ajax.Request('/users/demo',
        { method:'get', 
           onComplete:this.update(req) 
        });
    }

This won't work at all because the `update()` method will be called as
JavaScript evaluates the `Ajax.Request` constructor. 

OK, now it's working, but having lots of little anonymous functions
throughout your code is a little ugly. Fortunately, prototype provides
an extension to the `Function` class in the form of the `bind()`
method.The `bind()` returns a function that applies itself to the
given parameter when invoked. 

Ex. 4

    User.prototype.retrieve = function() {
      var myAjax = new Ajax.Request('/users/demo',
        { method:'get', 
           onComplete:this.update.bind(this)
        });
    }

Closures are nifty ways of getting around the fact that the object on
the other end of the `this` keyword changes depending scope. If you
want write JavaScript objects like you write Java objects, you need be
careful with  the `this` keyword.
