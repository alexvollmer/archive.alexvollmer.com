----- 
permalink: day-three-railsconf-07-summary
layout: post
filters_pre: markdown
title: Day Three RailsConf '07 -- Summary
comments: []

excerpt: ""
date: 2007-05-20 19:05:28 -07:00
tags: ""
toc: true
-----
<p>The day opened with a disappointing keynote speech from Tim Bray. He was upfront about the fact that Sun wrote a big check to big a sponsor and proceeded to launch, unapologetically, into a forty-five minute advertisement of Sun and just how great their servers and JRuby are.


<p>In contrast the opening act, Cyndi Mitchell of ThoughtWorks, had a much better presentation that called out to the Ruby and Rails community [to “take back the enterprise”](http://conferences.oreillynet.com/cs/rails2007/view/e_sess/14493). Her slide deck and presentation were fantastic. Anyone who crosses John Travolta&#8217;s awful &#8220;Battlefied Earth&#8221; with Dick Cheney gets big points in my book. I hope they post them somewhere.


<h1 id="memcache">Memcache</h1>

<p>This feels like the year the conference has gotten more &#8220;serious&#8221;. To that end, a consistent underlying theme of the whole conference has been scalability and performance. I&#8217;ll walk away from this conference with a new and, hopefully, enlightened view of the whole software/hardware ecosystem. It ain&#8217;t just about Rails folks. A real production app has a lot more moving parts than what&#8217;s on your dev box.


<p>My first morning session was Chris Wanstrath&#8217;s presentation about Rails and memcache. I wasn&#8217;t real close so I didn&#8217;t get a good look at the dude, but from where I was sitting I&#8217;d swear he looked an awful lot like Shaun White (aka &#8220;the Flying Tomato&#8221;).


<p>I loved the fact that his first slide in his presentation was titled [“YAGNI”](http://c2.com/xp/YouArentGonnaNeedIt.html). Memcache is such a neat tool with such a clear, appealing design that it&#8217;s easy to be wooed by it. Chris made an excellent point that you shouldn&#8217;t even _think_ about using memcache until you have some real numbers backing up your need.


<p>Chris showed off the <a href="http://require.errtheblog.com/plugins/browser/cache_fu">`cache_fu`</a> plugin which looked like it did everything short of make you breakfast. I&#8217;ll definitely have to spend some quality time with the docs on that. He also hipped us to [libketama](http://www.last.fm/user/RJ/journal/2007/04/10/392555/) which is a cool replacement for memcache&#8217;s default host-hashing algorithm. It allows you to dynamically add and remove memcache nodes without invalidating your entire memcache cluster.


<p>What&#8217;s brilliant about memcache is just how dumb it is. That dumbness keeps it simple to manage and deploy. That means though, that there is a back-pressure in your system to use the tool wisely. However it seems like a fair trade-off, especially when you consider that any decent performance-enhancing tool should force you to think about what the hell you&#8217;re doing.


<h1 id="getting_real_numbers">Getting Real Numbers</h1>

<p>The next session was put on by Julian Boot of ThoughtWorks, a hyper-active guy who was clearly more enthusiastic about his talk than about 90% of the presenters at the conference. He started his presentation of with a bang by making the claim that no off-the-shelf testing framework or product would be able to do proper performance testing for your application. Because setting up a test harness is (relatively) cheap and each team/environment/application is different, this is the one case where rolling-your-own makes more sense.


<p>He had a couple of interesting concepts that I hadn&#8217;t thought of. He suggested including a 90th-percentile measurement in your summary stats (y&#8217;know, min, max, avg) since max response times can jack your average. Seems like a helpful data-point to me.


<p>He also didn&#8217;t want to fool around with configuring several test nodes so that reporting stats would land in a single place. His answer was to simply have each test node send its stats out via UDP broadcast. A single stat-gathering &#8220;master&#8221; would listen on the broadcast address and simply write the packet contents (serialized samples) to a flat file for processing. In a switched network the likelihood of losing UDP packets is pretty low. I loved it the solution&#8212;it was brilliantly dumb and took about five lines of code.


<p>His last simple suggestion was to have each test client node output a single character indicating its state. I&#8217;ve seen a lot of processes that do this and the output is just noise. What makes this different though, and why I like it, is that you are actually interested in what&#8217;s going on at that moment. Often this kind of output is misapplied because it isn&#8217;t helpful until the process finishes and the output is too terse to be of much help.


<p>One of his key points is that writing a test harness is relatively simple. That hard part is the analysis and decision making made after the fact. While writing the harness might be fun, it&#8217;s a fraction of the time you will spend writing the ugly little test actions that will simulate what your users are doing. Julian stated that you know your test harness is correct when your test logs look like your production logs.


<h1 id="nice_answers_to_dumb_questions">Nice answers to dumb questions</h1>

<p>In between the morning keynote and the first session, I had a thirty minute window to get caffeinated and catch up on email. I only had to do the first, didn&#8217;t want to bother with second, and needed to find something to entertain myself until the next session. In the main foyer I noticed that DHH was chatting with a few folks. After a drive-by skulk realized that they were talking about one of my favorite topics, REST.


<p>During the conference I&#8217;ve been noodling around with the resources and URLs in a little side project I&#8217;m working on and I was getting really stuck on a satisfying way to apply REST-ful modeling to sessions and credentials. Since sessions are really managed by cookies, it&#8217;s kind of a round-peg-in-a-square-hole problem when applied to REST. So I walked up and posed this question to DHH directly. He hipped me to the `[map.resource](http://api.rubyonrails.org/classes/ActionController/Resources.html#M000177)` call in the routing configuration and the concept of &#8216;singleton resources&#8217;. We chatted a little bit more, I thanked him and headed off to my next session.


<p>Later, I started going over the Rails docs to get hip to this singleton resource concept. I realized that my question was on the edge of warranting a RTFM answer, but David was gracious enough to take the time to describe his solution and what the mechanism was. I have to say that I was really impressed with how helpful and gracious he was. I know that people sometimes want to treat DHH as a rockstar, but I think part of what has made Rails successful is the lack of a deeply-nested hierarchy that separates the ivory-tower types from the great unwashed masses. It&#8217;s comforting to know that you can pose a n00b question to someone like David and get a polite, helpful answer. I have great hope for this platform and this community.


<h1 id="rejectconf_2007">RejectConf 2007</h1>

<p>Living in Seattle I&#8217;m really fortunate to have access to such an [active group of Rubyists](http://www.zenspider.com/Languages/Ruby/Seattle/index.html). One fellow Seattle-ite, Ryan Davis, put on [RejectConf](http://blog.zenspider.com/archives/2007/05/rejectconf_2007_final_details.html) which was described as a &#8220;gong show&#8221; style presentation forum where people get up and give very short (&lt; 5min) presentations on things they&#8217;ve been working on. 


<p>The near-anarchic atmosphere (fueled by beer and snacks graciously donated by Addison-Wesley) gave a great energy to the gathering. Most of the ideas were pretty interesting, some were fringey, but it was a great forum to see what the rest of the community is up to. Oh yeah, a big shout-out to [Free Geek](http://freegeek.org/) for providing the space.


<h1 id="day_three_takeaway">Day Three Takeaway</h1>

<p>By the end of the day I came away feeling like I have some serious wood-shedding to do. I&#8217;ve only been doing Ruby for about nine months so I don&#8217;t have a problem with this. For years I&#8217;ve relied on being an experienced Java programmer to give me that nice warm feeling of comfort and confidence. However that has also led to a sneaking feeling of gathering dust. I jumped onto Ruby because it reached a good head of steam right as I was looking for something to push myself in new ways. Right now, I&#8217;m okay with being a total n00b dork to learn something new.
