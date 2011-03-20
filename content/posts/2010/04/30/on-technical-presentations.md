--- 
sha1: a9afd85f5b5d17d54143d13a6acb681e38e8255c
permalink: on-technical-presentations
kind: article
title: On Technical Presentations
tags: 
- presentations
created_at: 2010-04-30 07:51:51.154171 -07:00
toc: true
---

I spent last weekend at the Seattle version of the [Voices That Matter iPhone
Developer's conference](http://www.voicesthatmatter.com/iphone2010/ "iPhone
Developers Conference - Using the iPhone OS to build apps for the iPad and
iPhone"). The content was great, but aside from John "Wolf" Rentzch's Core
Data talk, the quality of the slides and presentation was pretty lacking. I'm
not here to dogpile on those speakers. I still got a lot out of their talks,
but the experience crystallized some important rules for me about technical
presentations.

## Size and Geometry

[<img src="http://farm1.static.flickr.com/122/405446783_a88c63ce0c_m.jpg"
class="left"/>](http://www.flickr.com/photos/laffy4k/405446783/ "Huntington
University: Zurcher Auditorium on Flickr - Photo Sharing!") 

There is a axiom in military science that says no plan survives contact with
the enemy. In a similar vein, no slide layout survives contact with an actual
display screen. As we craft presentations it's easy to get so locked into
looking at our screens that we often forget about the context of the room in
which it will be given. There are two important things to consider about the
room: how far back the audience stretches from the screen and the angle of the
audience. In a room with a "deep" audience and shallow angle, anywhere from
the bottom 20% - 30% of the screen will only be visible to the front row. Some
professional presenters make it a matter of habit to simply avoid the bottom
quarter of the screen. Think of this as a creative constraint to embrace and
help you focus your message.

The dimensions of the audience also affect the size of the content in your
slides —specifically the font size you choose. Somehow font sizes that look
like billboards on your laptop are diminished to footnotes once they are
projected. In practice, it's pretty hard to make text too big. If you have a
problem fitting what you want to say on the slide, perhaps you need to
reconsider the phrasing.

Aside from direct quotations, I find that it's rarely useful to have full
paragraphs of text in your slides. You want your audience to be focused on
*you*, not your slides. Think of the slides as simply the supporting cast to
what you're telling the audience verbally. How can you craft your slides to
complement what you're trying to convey?

## Live Demos

Slides can only take us so far, especially for technical presentations.
Sometimes we need to turn away from the "what", and explain the "how" of
something. We want to demonstrate how something works. For coders, this often
means a live coding or tool demonstration. If you're trying to convince your
audience that technology XYZ is the greatest thing since sliced bread and will
save them all sorts of time and headaches, you want to be able to *show* it,
not just tell it.

Fantastic. Good for you. Here's the problem: *live* coding demos are a recipe
for disaster. I can't think of a better scenario that demonstrates Murphy's
law than trying to execute a live coding demo. You may not have an internet
connection (oops, there goes the ubiquitous twitter client demo). You may have
installed some beta software on the plane ride out and, unknowingly, destroyed
your development environment. The list of things that could go wrong is
unbounded.

The other problem with live demos is the switching in and out of the
presentation software you're using. Not only is it visually jarring for the
audience, but there is invariably some down-time as you switch displays and
try to figure out which windows are where. Don't give your audience the
opportunity to tune you out during these noisy transitions.

So, just like you wouldn't create your slides on-the-fly as you present, you
shouldn't demonstrate live without a net. Instead, record a video of it and
embed it in your presentation. With a video you get a chance to edit out all
of the hiccups and noise of the demonstration process. Mistyped something? Got
a compilation error? Tools are running really slow for some reason? Great,
just edit those frames out. 

Leaving these blemishes in only gives the third-grader part of your audience's
brain time to sneak in and distract them. You want to keep your audience
engaged with you every step of the way. Introducing these interruptions into
the continuity of your presentation breaks the audience's concentration and your
flow.

Once you get your video captured and edited, practice speaking over it. Really
make sure that what you say matches well with the video. Get the timing down
and stay focused on what you're trying to show. Is there something you want to
say that you isn't in the video? Get back in there and record the right video.
Don't half-ass it. When you put the time in to make a good supporting video,
you keep your audience longer.

### Keynote Specifics

<img src="/images/2010/04/keynote-video.png" alt="Video prefs in Keynote" class="right"/>

If you're using Apple's Keynote, here are a couple of tips. Once you've
captured and edited your video, simply drag the video object onto a new slide.
Open the inspector palette and select the last tab with the Quicktime logo on
it. Select the checkbox labeled "Start movie on click". This way your video
won't start running before you're ready to talk about it.

<div class="clear"></div>

<img src="/images/2010/04/apple-remote.jpg" class="left"/> Also, with a stock
Apple remote, you can pause and resume your video as needed. This is
especially helpful when you have a multi-step process to explain that you want
to cover in bite-sized chunks. This means that you should consider
pause-points in your capture and editing process. Practicing your speech along
with the video will help you figure out where the natural breakpoints are.
Alternatively, you could split the process up into multiple videos on
different slides.

## Eschew Style

Customization and personal style are well and good. On your machine you should
feel free to tweak every little setting to your heart's content. But, please,
don't force these styles on your audience. Ditch the alpha blend on your
terminal. Turn off your crazy four-line shell prompt. Pick a color theme in
your editor that is easy to read in a large font. Pick a display font that is
appropriate for large projection, not just what you prefer.

<img src="http://ecx.images-amazon.com/images/I/51toYiHF35L._SL500_AA300_.jpg" height="150" width="150" class="left"/>

Make those fonts BIG. Just like your regular speaking voice needs to be
amplified to carry to the back of the room, so does the visual volume of your
content. When recording your coding demos, pick unusually large font sizes and
take up all of the screen. Also, when capturing your video, try to keep the
capture frame focused on the essential parts of the demo. For example, if
you're only editing text, don't clutter the video capture up with a toolbar
full of things you won't use. Remember, keep it focused! Don't give your
audience a chance to get distracted by clutter.

<div class="clear"></div>

## Keep It Focused

When presenting a technical topic, it can be frustrating having to jam a large
amount of content into a small space. There's just so much to share! How can I
possibly discuss Core Animation in forty-five minutes? The answer is, *you
don't*. What you *can* do is give your audience a taste of the topic you're
trying to present. Give them enough information for them to decide if they
want to pursue more on their own. Give them enough terminology and background
concepts to help them continue the journey.

Presentations are *not* a good vehicle for in-depth training. Books or
workshops are much more appropriate for real hands-on learning. Presentations
are good at giving people a mental roadmap to get started. Get them excited
by your topic, but don't exhaust them with it.
