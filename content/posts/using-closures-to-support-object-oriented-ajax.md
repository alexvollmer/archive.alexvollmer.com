----- 
permalink: using-closures-to-support-object-oriented-ajax
layout: post
filters_pre: markdown
title: Using Closures To Support Object-Oriented AJAX
comments: 
- :author: Ajaxian
  :date: 2005-12-14 19:59:40 -08:00
  :body: |-
    <strong>Javascript closures for object oriented Ajax</strong>
    
    Alex Vollmer has posted a nifty article on using closures for object oriented ajax, using Prototype's Ajax.Request object as the example. Many developers coming from the more static Java/C++/C# worlds have problems wrapping their head around closures ...
  :url: http://ajaxian.com/archives/2005/12/closures_for_ob.html
  :id: 
- :author: "Michael Sch\xC3\xBCrig,"
  :date: 2005-12-15 00:47:13 -08:00
  :body: |-
    Alex, what you write on scoping is not correct. JavaScript uses lexical scoping throughout. This is precisely the key to closures. 
    
    When a function is defined, variables are bound according to the lexical context. This is straightforward for arguments and local variables -- just the same as in, say, Java. When a function is defined nested inside another function, and the nested functions contains references to variables that are not defined as either arguments or local variables, these variables are resolved in the lexical context of the enclosing function.
    
    Then, when the nested function is passed around, say as a completion function for an AJAX call, it still retains references to the context where it was defined. Through these references, the function can affect changes to outside objects.
    
    Here's a very simple example
    
    function accumulator() {
      var count = 0;
      return function(add) { count += add; return count; }
    }
    
    Now what's this stuff with the 'this' keyword? For one thing, it is a keyword, not the name of a variable. It just is a reference to the current object. If it were a variable, it would be considered dynamically scoped.
    
    What's confusing people who are used to more conventional class-based OO languages, is that in JavaScript functions can stand on their own. They are not methods tied to a specific object. As a consequence, it is possible to call a function in the context of an "unsuitable" object. To call a function in the intended context, functions in JavaScript provide the two methods call and apply. Using them, it is possible to specify the object bound to 'this' when a function is executing.
    
    When you're using prototype.js anyway, the easiest way to ensure that a function executes with 'this' bound as intended, is to use 
    
    onComplete: myFunction.bind(this);
    
    Note that nowhere in all of this are threads involved. I'm pretty sure that none of the browser-based JavaScript implementations is multi-threaded. Apparently, they have an event queue that they process sequentially.
  :url: ""
  :id: 
- :author: Nic Williams
  :date: 2005-12-15 07:03:51 -08:00
  :body: |-
    Cheers for taking the time to explain this. Very well worded and a great guide/explanation.
    
    It makes me realise why I shirk each time I must code my own JS... such a pity JS is the only common scripting language amongst the browsers.
  :url: ""
  :id: 
- :author: Laurens van den Oever
  :date: 2005-12-15 08:48:30 -08:00
  :body: |-
    Prototype has bind() to achieve this goal:
    
    User.prototype.retrieve = function() {
      var myAjax = new Ajax.Request($('addFeedResource').href,
        { method:'delete',
           parameters:'url=' + feedUrl,
           onComplete:this.update.bind(this)
        });
    }
    
    You could also download:
    
    http://laurens.vd.oever.nl/weblog/items2005/closures/closure.js
    
    And write:
    
    User.prototype.retrieve = function() {
      var myAjax = new Ajax.Request($('addFeedResource').href,
        { method:'delete',
           parameters:'url=' + feedUrl,
           onComplete:this.update.closure(this)
        });
    }
    
    Which fixes all closure related memory leak problems in IE.
  :url: http://laurens.vd.oever.nl/weblog
  :id: 
- :author: Sebs
  :date: 2005-12-15 14:53:47 -08:00
  :body: |-
    A bit of mixed up topics: 
    
    1. the prototype of a object has no real connection to passing of functions.And that is the point where you really need to start:
    defining object properties BEFORE you create a new m MYSOMETHING is a very important feature of jacvascript that, as far as i know, makes a real difference to a lot of oo langages where this context is not available.
    
    2. We favourize me over _this: its just a lot clearer. _ could be seen as a indicator for a private var, and exactly this its not: its av beyond the direct scope.
    
    3.  its not a problem to use callbacks and objects ;) Noting anonymous functions is just a bit more likely, since you can do different implementations with the same interface. 
    
    
    ;)
  :url: ""
  :id: 
- :author: David Kemp
  :date: 2005-12-15 15:59:03 -08:00
  :body: |-
    An interesting discussion, but why not go on to discuss, and encourage use of, Function.prototype.bind? (It's provided by the Prototype library!)
    
    That what, we can all get away with:
    
    User.prototype.retrieve = function() {
      var myAjax = new Ajax.Request($('addFeedResource').href,
        { method:'delete',
           parameters:'url=' + feedUrl,
           onComplete:this.update.bind(this);
        });
    }
    
    and avoid _this!
  :url: ""
  :id: 
- :author: Travis Wilson
  :date: 2005-12-15 17:39:08 -08:00
  :body: |-
    This seems like a very complicated way to say that when you dereference a function (or any member) of an object X, you no longer have a reference to object X anymore. The line:
    
      var myAjax = new Ajax.Request( ... , {
           ...
           onComplete:this.load
        });
    
    sets the onComplete field to a function, and that's it, and makes no pretense of holding onto the "this" object. The function is just a member, and like any other member, it don't know where it came from.
    
    I'm pretty sure that these are the same static scoping rules used in every modern language. It is somewhat useful in Java to believe that "this" always refers to the instance containing the method, but instances don't actually contain methods. The instance's class contains methods. In Java you rarely pass methods; you always pass objects containing methods, which is more data (and that's the extra data your first two code snippets lack). But if, in Java, you did just pass the method (via object reflection), you'd have the same problem you do here. It _is_ an issue of scope, just not one unique to Javascript.
    
    That said, closures are a great way to fix the problem -- you get to attach members to function objects, which is cool -- but closures are so implicit that it's hard to see what's going on in the code, and you don't need them. I believe they're just another form of shorthand. You can explicitly attach those members to function objects:
    
    User.prototype.retrieve = function() {
      var update = function(req) { user.update(req); }
      update.user = this;
      var myAjax = new Ajax.Request($('addFeedResource').href,
        { method:'delete',
           parameters:'url=' + feedUrl,
           onComplete:update;
        });
    }
    
    Maybe it's me, but I feel this is much clearer. It keeps the "this" reference out of the callback code, and -- as you say -- "this" is overloaded enough as it is.
  :url: ""
  :id: 
- :author: Jesse Millikan
  :date: 2005-12-15 18:27:56 -08:00
  :body: |-
    I've written a few thousand lines of structured Javascript lately, so I run into this sort of thing a few times a day.
    
    This problem can be solved more elegantly, though. One way is to write a simple function (say, 'bind') of an object and function, whose return value acts as the function called as a method on the object.
    
    function bind(o, f){ return function(){ return f.apply(o, arguments); }}
    
    User.prototype.retrive = ...
     onComplete: bind(this, this.update) }); }
    
    The other way would be to write a 'return named method, bound' method generator, such as:
    
    function bind(name){ return function(){ 
      var me = this; return function(){ me[name].apply(me, arguments); }}}
    
    User.prototype.updating = bind('update'); 
    
    User.prototype.retrive = ... 
     onComplete: this.updating() }); }
    
    
    A related problem that I have run into is trying to create closures in a loop with a related variable inside the closure body - such as writing an array of functions to return or print the numbers 1 through 10. You end up having to write a function to return the closure you want, since Javascript doesn't provide any other way to change environments, unlike Lisp.
    
    Yakkity yak.
  :url: ""
  :id: 
- :author: Mislav
  :date: 2005-12-15 21:36:25 -08:00
  :body: Brilliant article. Very much sums up all the common mistakes with callback functions. Understanding closures and the behaviour of 'this' keyword is indeed critical for OO patterns in JavaScript.
  :url: ""
  :id: 
- :author: Administrator
  :date: 2005-12-16 20:50:31 -08:00
  :body: Thanks to everyone who posted a comment. Clearly I need to read more of the existing prototype literature out there. The use of the 'bind' function is clearly a more elegant solution.
  :url: ""
  :id: 
- :author: "Michael Sch\xC3\xBCrig,"
  :date: 2005-12-16 21:39:10 -08:00
  :body: "Jesse Millikan wrote:\r\n\
    \r\n\
    \"A related problem that I have run into is trying to create closures in a loop with a related variable inside the closure body - such as writing an array of functions to return or print the numbers 1 through 10. You end up having to write a function to return the closure you want, since Javascript doesn\xE2\x80\x99t provide any other way to change environments, unlike Lisp.\"\r\n\
    \r\n\
    So, you got ten functions each returning 10 (or 11?). I've stumbled into this too, myself, as probably everyone does at some time. This behavior is exactly how it should be with closures, though. When a function is defined in JavaScript, it retains the *bindings* of names (variables), not their values at the time of definition.\r\n\
    \r\n\
    Take this function\r\n\
    \r\n\
    function makeFuncs(n) {\r\n  var fs = [];\r\n  for (var i = 0; i ,0,1,Mozilla/5.0 (compatible; Konqueror/3.4; Linux) KHTML/3.4.3 (like Gecko) (Debian packa,,0,0);\n\
    insert into wp_comments values (18,17,Michael Sch\xC3\xBCrig,michael@schuerig.de,,81.173.144.44,2005-12-16 16:12:08,2005-12-17 00:12:08,[Sigh, apparently WordPress is borked. It doesn't escape/convert less-than properly.]\r\n\
    \r\n\
    Take this function\r\n\
    \r\n\
    function makeFuncs(n) {\r\n  var fs = [];\r\n  for (var i = 0; i &lt; n; i++) {\r\n    fs[i] = function() { return i; }\r\n  }\r\n  return fs;\r\n\
    }\r\n\
    \r\n\
    it returns an array of functions where each has a reference to the same (integer) object originally defined in makeFuncs as var i = 0. Of course, after makeFuncs has run, the value of this object is the integer n + 1.\r\n\
    \r\n\
    This is the same behavior as what you get with closures in Lisp and Scheme."
  :url: ""
  :id: 
- :author: Jay R
  :date: 2006-01-23 18:05:39 -08:00
  :body: |-
    I'm not sure where all the references to update() come from.  The initial example defines load() and the second code snippet makes reference to it.  But then references to update() appear, despite it being completely absent.  Or I may be a bit slow on the uptake here.
    
    Great article though.
  :url: ""
  :id: 
- :author: Administrator
  :date: 2006-01-23 19:58:09 -08:00
  :body: Thanks for the comment Jay. I cleaned up the examples to be consistent. It looks like I need to give my editor a good scolding. Oh wait...that's me. ;-)
  :url: ""
  :id: 
- :author: attila lendvai
  :date: 2006-04-16 18:16:25 -07:00
  :body: |-
    ok, no luck with googling. so i had to roll my own js equivalent of my handy lisp rebind, and luckily lisp saved the day again... :)
    
    this is a parenscript (lisp to js compiler) macro, that creates a new context, copies the listed variables and executes body in the new environment.
    
    (defjsmacro rebind (variables statement)
      (unless (listp variables)
        (setf variables (list variables)))
      `((lambda ()
          (let ((new-context (new *object)))
            ,@(loop for variable in variables
                    do (setf variable (symbol-to-js variable))
                    collect `(setf (slot-value new-context ,variable) (slot-value this ,variable)))
            (with (new-context)
                  (return ,statement))))))
    
    an example:
    
    (rebind (row)
      (lambda (event)
        ;; body
      ))
    
    compiled:
    
    (function () {
            var newContext = new Object;
            newContext['row'] = this['row'];
            with (newContext) {
              return function (event) {
                // body
                }
            }
    })()
  :url: ""
  :id: 
- :author: alex
  :date: 2006-04-17 03:34:30 -07:00
  :body: |-
    Attila,
    
    Clever indeed. Can you give me an example of <i>when</i> you would want to do this?
    
    --Alex
  :url: http://www.feedbagnews.net
  :id: 
- :author: attila lendvai
  :date: 2006-04-16 16:12:28 -07:00
  :body: |-
    This is the same behavior as what you get with closures in Lisp and Scheme.
    
    Except that in lisp you can easily rebind stuff with a
    
    (let ((name name))
      ...)
    
    which causes the variables not to be shared anymore. In javascript you can create a new binding only with a function (I'm right in the process of googling for another solution if there's any at all).
  :url: ""
  :id: 
- :author: bill
  :date: 2006-04-24 22:52:49 -07:00
  :body: |-
    Please forgive me as I play devils advocate here -- because honestly the Example 3 disproof failed to persuade me.
    
    Of course "_this" won't exist in the update() method -- it is defined in the retreive() method.  Forget Prototype -- define "_this" in the class's scope and you're in business.  EG:
    
    
    function User() {
      _this = this;
      _this.hello = "hello world";
      document.onclick = _this.yell;
    }
    User.prototype.yell = function(req) { alert(_this.hello); };
    var devilsAdvocate = new User();
    
    
    Don't take this as a troll -- tread lightly now fanboys.   I just want to know why Prototype's binding syntax [ultimately using anonymous functions to "apply" "this"] are any better than the simple "_this = this;" trick?
  :url: ""
  :id: 
- :author: alex
  :date: 2006-04-25 15:30:46 -07:00
  :body: |-
    I believe both David Kemp and Travis Wilson covered this earlier in the comment thread.
    
    --Alex
  :url: http://www.feedbagnews.net
  :id: 
- :author: peter
  :date: 2006-05-31 19:08:57 -07:00
  :body: |-
    The Yahoo! UI connection library avoids the need for user closures by having a scope parameter
    
    http://developer.yahoo.com/yui/connection/#scope
    
    Yahoo! UI corel libraries are really great.
    
    -Peter
  :url: ""
  :id: 
- :author: Robert Sayfullin
  :date: 2006-06-07 02:06:50 -07:00
  :body: |-
    Dear Jesse and Michael
    I have the same difficulties with an array of functions. 
    Can you please provide a snippet with your solution to this problem?
  :url: ""
  :id: 
- :author: Javascript Closures for Ajax &laquo; Coldfusion Yummy Mummy
  :date: 2008-12-02 09:06:31 -08:00
  :body: "[...] http://www.softwaresecretweapons.com/jspwiki/javascriptrefactoringforsaferfasterbetterajax Url: http://livollmers.net/index.php/2005/12/14/using-closures-to-support-object-oriented-ajax/ Url: [...]"
  :url: http://eileenaw.wordpress.com/2008/12/02/javascript-closures-for-ajax/
  :id: 
excerpt: If you want object-oriented design in your JavaScript when using AJAX, you need to understand closures.
date: 2005-12-14 16:27:47 -08:00
tags: ""
toc: true
-----
_updated 1/23/2006_

Coming from a Java background, I can't resist turning any moderately involved JavaScript into a collection of objects that encapsulate data and behavior. A majority of the JavaScript that I have come across is decidedly non-object oriented and tends to be a library of functions that are attached to various event handlers. This style works well with AJAX, but loses the advantages of cohesive object-oriented design. I won't re-hash the OO vs. functional programming argument here, but it must be pointed out that if you want OO design in your JavaScript when using AJAX, you need to understand closures. This article describes why they are important and how they work.

Just what the heck are closures? Closures are a way of creating function definitions with a particular scope chain attached to them. Closures allow [lexical scoping](http://en.wikipedia.org/wiki/Lexical_environment#Static_scoping) to work correctly with nested functions. For a more refined (and perhaps accurate) definition, see this [exhaustive discussion of closures in JavaScript](http://jibbering.com/faq/faq_notes/closures.html). 

If you are creating JavaScript classes and object instances of those classes, you know that liberal use of the `'this'` keyword is what binds your object together and gives it cohesion. However when using AJAX the `'this'` keyword starts to take on different meaning because it is no longer refers to the same object it referred when you setup your `XmlHttpRequest`.

Let's explore some examples. These all use the [prototype framework](http://prototype.conio.net/) developed by Sam Stephenson.

In our examples below we have a `User` object that has a reference to its HTML element (the 'div' argument passed in the constructor). As we add more functionality to the `User` we like having that direct reference to the div corresponding with the JS object.

The last line in the constructor calls the `retrieve()` method which fires off an AJAX request. When that request has returned, we want to populate our div element with the response text using the `load()` method.
Ex. 1
`
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
`</pre>
Note the `'onComplete'` property of the anonymous object given as the last parameter to the `Ajax.Request`. This is a pointer to our function that will handle the response. Since this is all happening within our `User` instance, we should still have a reference to that all-important div element that ties our object to the UI.

Unfortunately this doesn't work. When the `Ajax.Request` calls the function specified in the `'onComplete'` property, you get a JS error saying that 'this' doesn't have a property called 'update'. Why? Because in this context, 'this' is no longer your `User` object--it is the `XMLHttpRequest` object instead. 

How can that be? Because the response for the `Ajax.Request` is executing in a separate execution context in the browser, the meaning of `'this'` has changed. The `'this'` reference is no longer defined by its lexical scope (the `User` instance), but by its dynamic scope. 

OK, so if `'this'` changes meaning across contexts, perhaps we can fool the JS engine.
Ex. 2
`
User.prototype.retrieve = function() {
  var _this = this; // don't overload the meaning of 'this'
  var myAjax = new Ajax.Request('/users/demo', 
    { method:'get', 
       onComplete: _this.update
    });
}
`</pre>
Instead of referring to `'this'` in our `'onComplete'` property we refer to a new variable `'_this'`. The `'_this'` variable that points to `'this'` which, in this particular context, refers to our `User` instance.

Close but no cigar. You will still get JS errors saying that the `'this'` reference inside the `update()` method does not have a reference to a div (as in `'this.div'`). Hmmm, we seem to be making progress--now at least we're calling the right method, but `'this'` still isn't referring to our instance.

Now what's going on? Because of JavaScript's dynamic nature, even getting a reference to an object instance's method doesn't mean that `'this'` always refers to the instance object. Unlike Java where `'this'` _always_ refers to the instance containing the method, `'this'` means different things in JavaScript. This is somewhat analagous to Python's `'self'` reference which essentially passes in the object instance reference to method. 

Back in JavaScript, `'this'` changes meaning depending on the context in which it is used. So how can we get enough context around the reference to `update()` to make the instance method run properly?
Ex. 3
`
User.prototype.retrieve = function() {
  var _this = this; // don't overload the meaning of 'this'
  var myAjax = new Ajax.Request('/users/demo',
    { method:'get', 
       onComplete:function(req) { _this.update(req); } 
    });
}
`</pre>
Enter the Closure. Now the `'onComplete'` property refers to a little anonymous function that, when called by `Ajax.Request`, will have a reference to our `User` instance (`_this`) and will call the update method on it. Now we have built enough context around the entire `User` instance to get it's instance methods to run.

Note that this is very different from doing something like this:
`
User.prototype.retrieve = function() {
  var myAjax = new Ajax.Request('/users/demo',
    { method:'get', 
       onComplete:this.update(req) 
    });
}
`</pre>
This won't work at all because the `update()` method will be called as JavaScript evaluates the `Ajax.Request` constructor.

OK, now it's working, but having lots of little anonymous functions throughout your code is a little ugly. Fortunately, prototype provides an extension to the `Function` class in the form of the `bind()` method.The `bind()` returns a function that applies itself to the given parameter when invoked.

Ex. 4
`
User.prototype.retrieve = function() {
  var myAjax = new Ajax.Request('/users/demo',
    { method:'get', 
       onComplete:this.update.bind(this)
    });
}
`</pre>

Closures are nifty ways of getting around the fact that the object on the other end of the `this` keyword changes depending scope. If you want write JavaScript objects like you write Java objects, you need be careful with  the `this` keyword.
