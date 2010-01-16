----- 
permalink: activerecord-associations-and-counters
layout: post
filters_pre: markdown
title: ActiveRecord, Associations and Counters
comments: []

excerpt: ""
date: 2009-01-04 22:39:21 -08:00
tags: Ruby
toc: true
-----
Maybe this is old hat to all you grizzled vets out there, but today I thought I'd post about my experience with ActiveRecord's counter caches and the tricks I had to pull to get it working. Let me first set the stage with what I was trying to accomplish.

In [moochbot](http://moochbot), your main transaction screen has a standard tabbed-interface. Each tab is a different view of all your transactions. In a tabbed display you can only show one view at a time so it helps the user when you can provide some hints in the non-selected tabs. Anything that helps them figure out whether or not they want to click on something _without actually having to click on it_ is, in my opinion, a great help.

![Moochbot Tabs](http://img.skitch.com/20090104-xi79khd8e9242dhbf5yes6nmg6.jpg)

So I wanted to add a number in the tab to indicate how many items were there. The most naïve way to implement this would be to issue three different SQL statements for the counts. However somewhere, in the back of my mind, I remembered that ActiveRecord has a feature known as the _counter cache_. The basic idea is to hook some additional code into the lifecycle of ActiveRecord's associations to update a single column in the parent record as you add and remove child records.

Like an iceberg, the bulk of this feature lay deep below the surface. The actual view-layer changes were minimal, but I had to jump through some hoops to get the counter-cache working correctly.

In moochbot, a `User` model object has multiple `Transaction` records. Each `Transaction` points at two separate `User` records: one for the lender and one for the borrower. All of a user's transactions are stored in the `TRANSACTIONS` table, each record differentiated by the `STATE` column.

In ActiveRecord-land we express these relationships in the model with _three_ `has_many` relations for the `User`: one for items they are lending, one for items they are borrowing and all closed transactions. The first two are fairly straight-ahead:
<span class="meta meta_class meta_class_ruby"><span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class User<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt; ActiveRecord::Base</span></span></span>

  has_many(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:lent_items</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:class_name</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"Transaction"</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:foreign_key</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"lender_id"</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:conditions</span> =&gt; [<span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"state IN (?)"</span>,
                           <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">%w(started lent returned overdue disputed)</span>])

  has_many(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:borrowed_items</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:class_name</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"Transaction"</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:foreign_key</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"borrower_id"</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:conditions</span> =&gt; [<span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"state IN (?)"</span>,
                           <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">%w(started lent returned overdue disputed)</span>])

  has_many(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:completed_items</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:class_name</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"Transaction"</span>,
           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:finder_sql</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'SELECT * '</span> +
           <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'FROM transactions '</span> +
           <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'WHERE state IN (\'aborted\', \'finished\') AND '</span> +
           <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">'(borrower_id = #{id} OR lender_id = #{id})'</span>)
end</span></pre>
However the third relationship requires some custom SQL because we want all records that are in either the "finished" or "aborted" state _and_ where the user is _either_ the lender or the borrower. I looked into doing this with a simple `:conditions` option on the `has_many` relationship, but couldn't figure out how to specify the ID of the user.

One _really important_ thing to recognize here is that the SQL is quoted with single-quotes. If the SQL is specified in double-quotes, the interpolation is evaluated _too early_ and the id value is _not_ the user record. Putting it in single-quotes defers evaluation until the proper time. I wish this were documented a little better because I was completely stuck until I stumbled across [this post](http://railsblaster.wordpress.com/2007/08/27/has_many-finder_sql/ has_finder SQL) on the [RailsBlaster](http://railsblaster.wordpress.com RailsBlaster) blog. I had to enable debug-level logging for ActiveRecord to see that I was getting skooky IDs in my final SQL string.

To add a counter cache to the User record, you declare a `:counter_cache` option on the reciprocal `belongs_to` relationship. This seemed counter-intuitive to me since if I didn't already have one in place, I'd have to add one. It seemed more obvious to me to put it in the `has_many` relationship but that ain't the way ActiveRecord rolls. So the next step was to update the `belongs_to` mappings in the `Transaction` class:
<span class="meta meta_class meta_class_ruby"><span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class Transaction<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt; ActiveRecord::Base</span></span></span>

  belongs_to(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:lender</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:class_name</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"User"</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:foreign_key</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"lender_id"</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:counter_cache</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:lent_items_count</span>)

  belongs_to(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:borrower</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:class_name</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"User"</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:foreign_key</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_string punctuation_definition_string_begin punctuation_definition_string_begin_ruby">"borrower_id"</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:counter_cache</span> =&gt; <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:borrowed_items_count</span>)
end</span></pre>

The final step was to create a migration that would add the counter cache columns to the `USERS` table. Note that not only do we add the columns, but we also update everyone's counters.
<span class="meta meta_class meta_class_ruby"><span class="keyword keyword_control keyword_control_class keyword_control_class_ruby">class AddCounterCacheToUsers<span class="entity entity_other entity_other_inherited-class entity_other_inherited-class_ruby"> <span class="punctuation punctuation_separator punctuation_separator_inheritance punctuation_separator_inheritance_ruby">&lt; ActiveRecord::Migration</span></span></span>
  COLUMNS = [<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:lent_items_count</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:borrowed_items_count</span>,
             <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:completed_items_count</span>]

  <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def self.up</span>
    COLUMNS.each do |c|
      add_column <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:users</span>, c, <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:integer</span>, <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:default</span> =&gt; 0
    end

    User.reset_column_information

    User.find(<span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:all</span>).each do |user|
      User.update_counters(user.id,
                           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:lent_items_count</span> =&gt; user.lent_items.length,
                           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:borrowed_items_count</span> =&gt; user.borrowed_items.length,
                           <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:completed_items_count</span> =&gt; user.completed_items.length)
    end
  end

  <span class="keyword keyword_control keyword_control_def keyword_control_def_ruby">def self.down</span>
    COLUMNS.each do |c|
      remove_column <span class="punctuation punctuation_definition punctuation_definition_constant punctuation_definition_constant_ruby">:users</span>, c
    end
  end
end
</span></pre>
So there it is. Hopefully that helps the next poor sod that runs into that same problem.
