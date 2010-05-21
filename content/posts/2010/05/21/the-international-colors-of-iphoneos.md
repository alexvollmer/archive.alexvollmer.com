--- 
permalink: the-international-colors-of-iphoneos 
title: The International Colors of iPhoneOS 
kind: article 
tags:
- iphone 
- i18n
created_at: 2010-05-21 08:46:32.726352 -07:00
--- 

Like flossing or saving for retirement, localizing
and internationalizing your applications is one of those things "you should
do". Cocoa, and by extension Cocoa Touch, has pretty decent localization
(l10n) and internationalization (i18n) support. If you use the
`NSLocalizedString` macro along with locale-specific strings files, you will
handle 99.9% of your localization needs.


<img src="http://revoir1printemps.canalblog.com/albums/benetton/m-benetton654.jpg" height="100" class="left">


But what if you're integrating with a web service? What's the best way to
convey the user's current settings to an external party? I've run into this
exact situation a couple of times and wanted to share the approach I like to
take.

# The Server-Side #

The first thing you need to determine is how you'll express the user's 
current locale settings. If you own the servers-side, you can implement this in
whatever way you see fit. Personally, I like to take advantage of as much
of the HTTP specification as I can. Rather than overloading every request
with a request parameter, I like to use the `Accept-Language` header.
[The specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4 "HTTP/1.1: Header Field Definitions")
says that the format of the `Accept-Language` header allows multiple locales with
["quality values"](http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.10 "HTTP/1.1: Protocol Parameters") 
optionally given to each one to express order of preference.
For example, a valid `Accept-Language` header might look like this:

<% highlight :sh do %>
Accept-Language: da, en-gb;q=0.8, en;q=0.7
<% end %>

In this example, Danish (with no specific region) is preferred first, followed
by English (in the Great Britain region), followed by English in any region. The
language and region are delicately intertwined in a bunch of different ways.
Depending on the combination, the region may affect how words are spelled
(for example "armor" in American English vs. "armour" in British English). Not
all locales and regions work this way so there are plenty of corner-cases.

Ruby on Rails is my server-side stack of choice these days. Like Cocoa, Rails
is pretty good at making it easy to localize and internationalize your
application. However, despite Rails claim to being "opinionated", it's
surprisingly indecisive about the best way to express language and region
preferences. The [Rails i18n Guide](http://guides.rubyonrails.org/i18n.html
"Rails Internationalization (I18n) API") suggests that you can get the locale
as a query parameter (blech), via the domain name (if you've set your
application and client up this way), via URL parameters (i.e. as a path
segment within a larger URI structure), via built-in user settings, via GeoIP
or using the `Accept-Language` header. As I stated before, I like the latter
solution the most. However parsing the header, dealing with the quality scores
and then figuring out the best one is something that has already been solved.
For that, I like the [`http_accept_language`
gem](http://rubygems.org/gems/http_accept_language "http_accept_language |
RubyGems.org | your community gem host").

In the `ApplicationController`, I setup a `before_filter` that uses the gem to
parse the `Accept-Language` header. Since I may not have localized the web
server to match a given request, I use the `compatible_language_from` method
to figure out what, if any, language match there is.

<% highlight :ruby do %>
before_filter :check_language

def check_language
  params[:locale] = if params[:locale].nil?
    request.compatible_language_from(MyApp::AVAILABLE_LANGUAGES)
  else
    params[:locale]
  end
  I18n.locale = params[:locale]
end
<% end %>

`MyApp::AVAILABLE_LANGUAGES` is constant array defined in a Rails
initializer (in `config/intializers`) that figures out all of the possible
locales I have configured:

<% highlight :ruby do %>
module MyApp
  AVAILABLE_LANGUAGES = Dir[RAILS_ROOT + "/config/locales/*"].map do |f|
    File.basename(f).split('.').first
  end
end
<% end %>

Despite my aversion to using request parameters, it can be handy for ad-hoc
testing to be able to tack a query parameter on to change the locale. Also,
once you've determined the locale, you need to notify the `I18n` framework
as I've done in the last line of the `check_language` method.

# The Client-Side

OK, great. Now we've figure out how to vary the locale on the web-side. How
do we extract this information from the device and ship it off in our
HTTP headers?

Here you have two tasks: the first is to determine what the value of the
`Accept-Language` header should be and second, to actually make sure you send
those values. Since there are several ways of making HTTP requests in iPhoneOS
I'm not going to go into the details. Whether you're using `NSURLRequest`,
[ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/ "ASIHTTPRequest Documentation - All-Seeing Interactive"),
[HTTPRiot](http://alternateidea.com/blog/articles/2009/7/11/introducing-httpriot-easily-consume-rest-resources-on-the-iphone-and-os-x "AlternateIdea:  Introducing HTTPRiot - Easily Consume REST Resources on the iPhone and OS X")
or your own homegrown thing, presumably you have 
some reasonable way of setting the `Accept-Language` header in a consistent
way.

To figure out what locale your user is in, you need to consult the
`NSLocale` class. This provides several class methods that yield a
`NSLocale` instance that reflects the user's current settings. If you look
at the docs, there are three class-methods that return a `NSLocale` instance:
`+systemLocale`, `+currentLocale` and `+autoupdatingCurrentLocale`. The 
differences between the three are not apparently obvious and, I think, reflect
`NSLocale`'s original desktop heritage.

The `+systemLocale` method will return a default `NSLocale` instance when one
cannot otherwise be determined. In my experience, I've never seen this return
anything but a blank and useless `NSLocale` instance. Don't bother using it.

The `+currentLocale` method returns a `NSLocale` instance that reflects the
user's current setting. However there is a bit of language in the docs that
I initially found confusing:

> Settings you get from this locale do not change as System Preferences are
> changed so that your operations are consistent. Typically you perform some
> operations on the returned object and then allow it to be disposed of.
> Moreover, since the returned object may be cached, you do not need to hold on
> to it indefinitely.

*Huh?* To understand what's going on here, we need to take a look at the docs
for the `+autoupdatingCurrentLocale` method:

> Settings you get from this locale do change as the user’s settings change
> (contrast with currentLocale).

Remember, a lot of CocoaTouch came from the desktop Cocoa environment. On the
desktop you can open the System Preferences and change your region and
language settings anytime *while applications are running.* However, until
iPhone OS 4.0 is released, this is *not* something you can do on any iPhoneOS
device. So the net effect, and this matches my own observations, is that on
iPhone OS 3.x `+currentLocale` and `+autoupdatingCurrentLocale` are
essentially the same. But, if you want to be prepared for the future, go ahead
and use the `+autoupdatingCurrentLocale` method. Once you have a `NSLocale`
instance, you call the `-localeIdentifier` method on it to get a `NSString`
like **en_US** or **fr_FR**.

So if you're like me, you want to test that this actually works. So, naturally,
you would figure out how to modify the settings on your phone to yield 
different responses. What you'll soon discover is that the current locale
settings are derived from two separate and independent settings and that 
various combinations of the two can produce unexpected results.

Start by launching the "Settings" application. Select *General ⇢
International*. You'll get a screen where you can pick your language, your
keyboards and your region format. What may surprise you is that *changing the
language does not affect the current locale.* I'm in the United States so my
region format is set to "United States". If I change my language to French,
but leave the region format setting alone, all localization within the system
and applications will use the French language, but my locale remains
**en_US**.

![International Settings on iPhone](/images/2010/05/international-iphone.jpg)

OK, so `NSLocale` doesn't quite work as expected, but where does the system
store the current language? It turns out the `NSLocale` provides yet another
class method, named `+preferredLanguages`, that returns an array of language
codes as strings. With the settings described above, the first entry in that
array is "fr".

If you change your settings where you leave the language set to English, but
change the region format to French (in the "France" region), the current locale
will now be set to **fr_FR** and the first entry in the `preferredLanguages`
array will be "en" for English.

# What It All Means #

Out of the box, Rails doesn't provide full-blown region-specific localization.
You can either hack something or use one of many [i18n plugins](http://rails-i18n.org/wiki "Rails I18n")
or [Globalize2](http://github.com/joshmh/globalize2 "joshmh's globalize2 at master - GitHub").
So if you try to send a language-region combination to Rails (such as **en_US**),
chances are good that you won't have the right localization setup and you'll
fall-back to your default locale.

You have two choices: you can make the client send something that the server
understands, or teach the server to respect more fine-grained localization
values. If you want to go the first route, I would suggest simply querying the
`+preferredLanguages` array and using the first entry as the value for your
`Accept-Language` header. However if your server-side localization can handle
it, use the `+currentLocale` instead so that you can handle regional
differences and spelling much better.

