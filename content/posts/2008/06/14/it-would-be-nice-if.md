----- 
permalink: it-would-be-nice-if
title: It Would Be Nice If...
date: 2008-06-14 22:00:02 -07:00
tags: ""
excerpt: ""
original_post_id: 91
toc: true
-----
When talking about building software, few sentences set off more red flags than those beginning with "it would be nice if..". I don't mean some variation of this phrase, I mean exactly this phrase. It's like those words are a specific code-phrase for "speculative features coming your way!"

What the heck is "nice" anyway? The very language of that statement does nothing more than imply; it makes no assertions and offers no proof. A piece of candy is nice. So are flowers and a new house. But those things all require widely varying levels of planning, effort and cost. So "nice" isn't a very precise word and certainly fails us when we try to evaluate what goes into our product and what stays on the sidelines for further evaluation.


In a geek-heavy setting, such as my workplace, I often observe this phrase used as a desire to establish authority in a conversation. This happens when features are proposed not so much for their value, but as a way of showing how deep and nuanced the proposer's understanding of the domain is. For example in a brainstorming session we had recently about new visualizations for rich data structures, a lot of IWBNI ideas were proposed that were fairly baroque and hard to imagine being interesting to a wider audience. In this instance instead of focusing on the goal, making sense of a big pile of information, the exercise turned into a demonstration of various participants' grasp of market dynamics, web trends and cutting-edge features. You can imagine how useful the final set of ideas were.


Another issue with IWBNI features is that they are often very implementation-focused. For example if you are working on a web service that is consumed by other services, you might want to track usage statistics to generate a regular report to see who is using it. The real feature is tracking usage, but that original need can easily be obscured by an overly-specific implementation. Ideas for these features often emerge out of the system constraints that are a result of the system design, not necessarily a natural outcome of the problem domain. Differentiating between these two is probably one of the hardest things to do in any kind of design.

It's vital to differentiate between these because IWBNI features seem especially prone to calcifying the current implementation. Back to our web services example, let's say we implement this usage report, which dumps a text file every hour of usage statistics. We love that feature so much that we hook it up to our automated monitoring system as it seems like a nice way to monitor the "heartbeat" of the system. However, down the road we discover that we need a maintenance window that makes the file unavailable for a period of time that causes the monitoring system to alert us. Now we have a choice: we can patch up the monitoring to manage this exception, or we can re-think just how important the text-file interface is.

In this case I would argue that the text-file dump might instead be replaced with a simple web-request. When the system is in its maintenance mode, it could still answer questions about general availability (which is what we were originally interested in) without tying a more specific feature, usage, to monitoring. I don't think that making the monitoring script more sophisticated is the right answer. More complexity there means a higher likelihood of breaking and it spreads some very implementation-specific details to other parts of the system.

The features and attributes of a system can be viewed like walls in a house. Some are load-bearing and some are not. The load-bearing features are those that without which, the house would simply fall. In your applications these are features that are the very essence of the software. An application like Quicken has an awful lot of walls. The load-bearing features of Quicken are the ledgers and reconciliation process. Without these, the other features of Quicken are irrelevant.

However features like downloading transactions over the internet or viewing pie-charts are mostly decorative. This doesn't mean they are without worth, but they are not as essential as the load-bearing features. These could be removed and Quicken's essence would still be preserved. Quicken is certainly more useful with these features, but those aren't the features that generally drive users to use it. (NB: This is not to say Quicken is a well-designed application. But I'll save that for another post...)

You can move the decorative walls around to change the space of a room without major fuss. Moving a load-bearing wall is a fairly major operation and has a huge impact on the character of the house and requires extra planning so that the house doesn't collapse during the change. The danger of IWBNI is that it's easy to confuse these features with essential "load-bearing" ones. Worse yet, the compound of multiple IWBNI features can end up as a load-bearing walls that are difficult to move. Revisiting our web services example, if more features like the text file were piled on and external parties began to rely on these, it would become much more difficult to move these in the future. It's not difficult to imagine getting to a point where the original role of the web service is obscured by all of the other tangential bells and whistles.

Sometimes IWBNI features are user- or domain-driven. These seem like they might have a better chance of withstanding the litmus test. More often than not these ideas end up obscuring the core of the application, but these can be, relatively, easy to test with tools like mockups, user interviews and usability testing. In supporting services it's much harder to evaluate these features. How do we do usability testing for a web service? Does the variable for a request belong in the path or as a query parameter? How do we figure out what consumers want? This is tricky because in this case we're designing something by geeks, for geeks. This doesn't mean that it's okay to pile on a bunch of implementation details and stop thinking about separating our load-bearing features from our decorative ones. But it does mean that we have to be extra vigilant about the IWBNI features and view them with a particularly suspicious eye.


So I think this is the real trick&#8211;whether you are a visual designer, information architect or software developer&#8211;is to separate the essential from the decorative. Being able to sort features in this way gives you a chance to properly evaluate the cost/benefit tradeoffs. Without this I believe it is much more difficult to clearly see the value of a feature and its overall impact on the system.

So let me offer up a challenge: treat IWBNI as a codeword for something requiring exceptional scrutiny. When something is proposed as a IWBNI feature, regard it with a suspicious eye. When you feel yourself proposing a IWBNI feature, think long and hard about whether or not it is really "nice" or whether it might "essential" or "superfluous". And for goodness' sake, don't get hung up on your IWBNI features. If they're "nice" they probably aren't a core feature anyway. You're a smart, creative person and you'll have other ideas in the future.

And finally, let's remember the most common trait that nearly all IWBNI features share...




<div style="font-size: 72px; font-weight: bold;">YAGNI*</div>

* Ya ain't gonna need it

