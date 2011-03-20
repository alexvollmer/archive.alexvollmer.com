----- 
sha1: 38b5507cda9bab12ad32c207c724a1b529776550
kind: article
permalink: day-two-railsconf-07-dhhs-keynote-address
created_at: 2007-05-18 21:43:06 -07:00
title: Day Two RailsConf '07 -- DHH's Keynote Address
excerpt: ""
original_post_id: 6
tags: 
- ruby
- rails
- railsconf
toc: true
-----
This is my first RailsConf so I can only say this given second-hand information. But it seems that I've arrive just as the interest and popularity in the framework has hit the bend in the hockey-stick. The enthusiasm at the morning keynote address by David Heinemeir Hanssson was equals parts technology preview, religious revival and idol worship.

I&#8217;ve always found the use of &#8216;DHH&#8217; to be a little off-putting as it always smacked of a strange geek cult-of-personality. However given the length of the guy&#8217;s name, I can see why he went with the initials. At least it&#8217;s better than some obtuse l33t h4x0r handle.

Anyway&#8230;

Let me give you a quick 30,000 foot overview of things coming in Rails 2.0.

# REST-ful Resources are the New World Order

>  "The world of resources is a better, greener place" &mdash; DHH

REST will be the default way things are done in 2.0, meaning that there will be more default notions built-in to support the style.


## Controllers

<% highlight :ruby do %>
def create
  @person = Person.create(params[:person])
  respond_to do |format|
    format.html { redirect_to(@person) }  # person_url(person)

    format.xml do
      ...
    end
  end
end
<% end %>

Look at how simple it is to render a the `@person` object. Isn&#8217;t that lovely?

## Views

Views get cleaner by using a single `form_for` that understands updated vs. new creations (as well as the default URLs for that resource and actions). You no longer have to &#8220;drop-down&#8221; on the bare metal and expressly configure your `form_for` declarations with the correct URL and HTTP verbs.

## Routes

REST-ful routing is getting a bit of a makeover, adding some more flexibility within the otherwise liberating constraints of REST.

<% highlight :ruby do %>
# /admin/products/inventory
# /admin/products/5/tags
# /admin/products/5/seller
map.namespace(:admin) do |admin|
  admin.resources :products,
    :collection => { :inventory => :get },
    :member => { :duplicate => :post },
    :has_many => { :tags, :images, :variants },
    :has_one => :seller
end
<% end %>

# 9 other things to like about Rails 2.0

The best part of the keynote was the preview of new features in Rails 2.0. There is enough good-looking stuff in here that I&#8217;m probably going to move my main Rails side-project to Edge Rails and feel the good lovin&#8217; on the bleeding edge.

## Breakpoints are Back!

This was broken by a fix made in Ruby 1.8.5. The takeaway of course is not to implement features based on hacks.

## ruby-debugger

One of the few embarrassing things about developing in Rails is the lack of a first-class debugger. So far I&#8217;ve been able to work with Rails quite well without having a debugger. In part this is because using a Test-driven approach means the debugger is usually the last tool you reach for rather than the first. But I will have to admit that I have had to &#8220;devolve&#8221; into using logging or `puts` statements to dump what was going on in the running app.

Thanks to the inclusion of the [ruby-debug](http://rubyforge.org/forum/forum.php?forum_id=7778) into the core you can actually do real debugging in Rails. With this new technology you can set a breakpoint in your code with a single `debugger` line in your code. When the code is hit your console will drop into a command-line interface where you can:
  * View your place in the stack
  * Modify objects in place
  * This looks like it&#8217;s gonna rock!

## HTTP Performance

### JS/CSS Bundling

There is a tension between segmenting JS and CSS into separate files and HTTP performance. As a developer you want to separate our Javascript and CSS to keep your head straight. But the performance of downloading those assets suffers given the de-facto two-connections per site limitation in browsers. Rails 2.0 will have a way to send a single request to Rails for a collection of JS and CSS at once and it will returned as a single gzipped bundle.

<% highlight :ruby do %>
<%%= javascript_include_tag :all, :cache => true %>
<%%= stylesheet_link_tag :all, :cache => true %>
<% end %>

### Connection limits

JavaScript and CSS aren&#8217;t the only assets where you run into the two-connection limit. Any other static assets (particularly images) can kill you here. Rails 2.0 will have support for a type of name-based virtual hosting for your assets so that you can &#8221;trick&#8221; the browser into using more simultaneous connections to download content. You can set this in your config:

<% highlight :ruby do %>
config.action_controller.asset_host = 'asset%d.example.com'
<% end %>

## Query cache for `ActiveRecord`

This new feature sniffs the SQL being executed and looks between calls for the exact same SQL. If any UPDATEs or DELETEs were not executed between queries that affected those records AR will return a cached version of the objects.

## MIME type handling

In the past the means to generate content and its format were mixed into the name (ex. `index_rss.rhtml`). Rails 2.0 has made some naming changes to better call out the separation between the type of the final content and the means by which it was generated.

Now view files look like [template].[format].[rendering]. For example:
    * people/index.html.erb  # Use ERB to generate HTML
    * people/index.xml.builder  # Use builder to generate XML
    * people/index.rss.erb  # Use ERB to generate RSS
    * people/index.atom.builder  # Use builder to generate Atom

## Configuration initializers

Application-specific configuration that used to go into `config/environment.rb` now goes into separate files in the `config/initializers` directory. I haven&#8217;t felt the pain of this, but I can certainly imagine how this might be helpful.

## Sexier Migrations

A typical migration looks something like this:

<% highlight :ruby do %>
create_table :users do |u|
  u.user_name :type => :text, :null => false
  u.first_name :type => :text
  u.last_name :type => :text
  u.age :type = >:integer
end
<% end %>

See all the redundancies? Why keep specifying the `:type` parameter. Why not reverse it like this?

<% highlight :ruby do %>
create_table :people do |t|
  t.integer :account_id
  t.string :first_name, :last_name, :null => false
end
<% end %>

## HTTP Authentication

Because REST-ful web services have become much more first-class in Rails, the need to support Basic HTTP Authentication has become important. HTTP Basic Auth for browsers and user-facing applications just plain sucks: there is no notion of &#8220;logging out&#8221; and there&#8217;s no control of the user interface. However for web services HTTP Basic Auth is fine. Rails 2.0 provides a new `authenticate_or_request_with_http_basic` method that can be used in controllers. This is very nice for computers interfacing to your APIs

## Spring cleaning

Remember those deprecation warnings you see in the console when you run your app? Yeah, it&#8217;s time to address those and clean them up. Those deprecated features are going to be going away in Rails 2.0. Fix your code. Don&#8217;t say you weren&#8217;t warned.
