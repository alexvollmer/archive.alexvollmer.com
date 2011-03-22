What: we had a bug that only happened occasionally. It was very hard to
reproduce. It had all the smells of a concurrency bug:

  1. Only occasionally happened
  2. Happened under different circumstances

I was at my wit's end. I had reviewed the code over and over and had only
found a few places that _might_ have caused problems. After I had addressed
everything I could find through analysis, we _still_ had the bug. I was out of
answers.

Because it was impossible to reproduce the behavior consistently, falling back
on debugging wasn't a means to a solution.

What we observed were several crashes related to exceptions thrown by
UITableView. The UITableView is a particularly fussy class. When you tell it
to reload itself (in whole or in part), it will query back into its data
source to get the starting and ending state. For any partial changes to a
table view, you need to issue a -beginUpdates first, then insert, remove or
change any rows in the table, and finally issue an -endUpdates.

When you call -beginUpdates, one of the things a UITableView does is take a
snapshot of the current model: how many sections and how many rows are in each
section. Then you perform whatever update you like and finally call
-endUpdates. You need to provide consistent answers in your data source for
this to work right. Put mathematically, you might say:

  number of rows in section + updated = final number of rows in section

  number of sections + updated = final number of sections

One way to consistently crash a UITableView is to not get this right.

Step 1: Get More Information
Since I couldn't, yet, reason my way to the solution to this bug, the first
step was trying to get more information. Crash reports are all well and good,
but when your app crashes because and exception is thrown, you don't get the
original exception message. So the first step was capturing the original
exception and some surrounding debug information around it.

This required a special build that write all of the logging to a file which we
could then email to ourselves. We wanted to put this in the hands of a few
private beta-testers and didn't want to require them to have Xcode to get
console logs.

Step 2: Pore Over Console Logs
Once we had a logfile in place, the next task was to wring whatever
information we could get about it. This phase actually took a couple of builds
as I progressively added `NSAssert` statements throughout the code. These
"pinned" various assumptions in the code. If there was any chance of getting a
`nil` object or getting no objects returned in a collection, I had to know.

This is also the phase where I needed the right balance of intuition and
skepticsm. It's very easy in this phase for the brain to start leaping to
conclusions and land on the wrong one. Often you're just looking for something
that seems out place. That might be just enough to tease out the answer.

This is also the phase where you start pattern-matching. Are there certain
log statements we see around the time we crash? In our case we noticed several
warning statements that I had put in the code. By rights, they probably should
have been fully-formed assertions since the code relied on a particular state.
In my case, the API I was adapting to the table view had a dynamic collection
for each section. My table-view controller was a delegate for this collection.
We noticed that we were getting warning messages about having more than one
collection for a particular name, which was inviolation of the model we had
built.

At that moment, the warning message may, or may not, have been part of the
problem. But it certainly wasn't correct. If nothing else, we should fix it to
keep our internal model consistent and, more importantly, to remove this issue
as a possible explanation of the crashes.

Step 3: Question Your Assumptions
So now it was time to review the code with a more specific issue in mind. This
was now a life-cycle issue. That is, how were these collections getting
created in such a way that we were occasionally having duplicates? That
required finding all the places we create these collections and figuring out
every potential place it could be called.

This phase actually required another build as I refactored how the collections
were created and destroyed so that all parties used the same method calls. In
those calls I could add my `NSAssert` statements to validate my assumptions.

After the first review I couldn't imagine how this could possibly happen. This
is an extraordinarily frustrating phase during debugging. I was already
anxious enough about this bug because it had lingered for weeks and I didn't
have an answer. It made me feel dumb.

The first step was to try to divorce any emotions from the task of solving the
problem. You just can't think clearly when your emotions are too wrapped-up in
the task. The second step was go back and review all of the assumptions I had
made about when and where these collections were created. 

This part is hard. This is where I've seen an awful lot of people fail to make
the leap and instead assume that there's a bug in the underlying framework.
This is the emotional side talking&mdash;not your rational brain. You really
_want_ it to be someone else's problem. But guess what? 99.9999% of the time
that's simply not the case. Declaring something a "framework bug" is the
absolute last resort and, even then, I won't admit that that's the issue until
I have a stand-alone, reproducible test-case.

