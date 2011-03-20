----- 
sha1: fed0b37e6dd3739f4b8f7031f6cebfae4a44bbb7
kind: article
permalink: make-view-helpers-a-little-less-helpful
created_at: 2008-09-23 15:41:27 -07:00
title: Make View Helpers a Little Less "Helpful"
excerpt: ""
original_post_id: 115
tags: 
- ruby
- rails
toc: true
-----
I stumbled across a little bit of hidden Rails fun last night when I was trying to get the form_for method to _stop_ wrapping error fields with extra div tags. Did you know that? Maybe you never noticed, but when you use the field helper methods, like text_field, password_field, etc, Rails will wrap fields with errors in a `<div>` with the class 'fieldWithErrors'.

This was causing all sorts of grief for me in some JavaScript I was trying to write. At first I tried to go with the flow and fix my JS, but it got really hacky really fast. So I went on a little source-code spelunking to figure how to make the problem go away.

In actionpack-2.1.0 there is a Proc attached to the `ActionView::Base.field_error_proc` class attribute. It's not documented in the RDoc, but this is also a _writable_ attribute which means I can shut the damn thing up. Here's what it looks like in the original file, `GEM_HOME/actionpack-2.1.0/lib/action_view/helpers/active_record_helper.rb`:

<% highlight :ruby do %>
require 'cgi'
require 'action_view/helpers/form_helper'

module ActionView
  class Base
    @@field_error_proc = Proc.new{ |html_tag, instance| "<div class=\"fieldWithErrors\">#{html_tag}</div>" }
    cattr_accessor :field_error_proc
  end
  ...
end
<% end %>

My solution was to create a little file in `config/initializers` named `field_errors.rb` with this text:

<% highlight :ruby do %>
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end
<% end %>

Et voila! Just a simple pass-through with no more fancy-pants markup. Putting stuff like this in separate files in the `initializers` directory keeps your config and environment files from getting out of hand.

