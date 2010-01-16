----- 
permalink: make-view-helpers-a-little-less-helpful
layout: post
filters_pre: markdown
title: Make View Helpers a Little Less "Helpful"
comments: []

excerpt: ""
date: 2008-09-23 15:41:27 -07:00
tags: ""
toc: true
-----
<p>I stumbled across a little bit of hidden Rails fun last night when I was trying to get the form_for method to _stop_ wrapping error fields with extra div tags. Did you know that? Maybe you never noticed, but when you use the field helper methods, like text_field, password_field, etc, Rails will wrap fields with errors in a `&lt;div&gt;` with the class 'fieldWithErrors'.

<p>This was causing all sorts of grief for me in some JavaScript I was trying to write. At first I tried to go with the flow and fix my JS, but it got really hacky really fast. So I went on a little source-code spelunking to figure how to make the problem go away.

<p>In actionpack-2.1.0 there is a Proc attached to the `ActionView::Base.field_error_proc` class attribute. It's not documented in the RDoc, but this is also a _writable_ attribute which means I can shut the damn thing up. Here's what it looks like in the original file, `GEM_HOME/actionpack-2.1.0/lib/action_view/helpers/active_record_helper.rb`:

<p>
<span class="meta meta_require meta_require_ruby"><span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'cgi'</span></span>
<span class="keyword keyword_other keyword_other_special-method keyword_other_special-method_ruby">require <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'action_view/helpers/form_helper'</span></span>

<span class="keyword keyword_control keyword_control_module keyword_control_module_ruby">module ActionView</span>
  <span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class Base</span>
    <span class="punctuation punctuation_definition punctuation_definition_variable punctuation_definition_variable_ruby">@@field_error_proc</span> = Proc.new{ |html_tag, instance| <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"&lt;div class=\"fieldWithErrors\"&gt;<span class="punctuation punctuation_section punctuation_section_embedded punctuation_section_embedded_ruby">#{html_tag}</span>&lt;/div&gt;"</span> }
    cattr_accessor <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:field_error_proc</span>
  end
  ...
end
</span></pre>


<p>My solution was to create a little file in `config/initializers` named `field_errors.rb` with this text:

<p>
<span class="support support_class support_class_ruby">ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end
</span></pre>


<p>Et voila! Just a simple pass-through with no more fancy-pants markup. Putting stuff like this in separate files in the `initializers` directory keeps your config and environment files from getting out of hand.

