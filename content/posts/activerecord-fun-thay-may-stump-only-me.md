----- 
permalink: activerecord-fun-thay-may-stump-only-me
title: ActiveRecord Fun Thay May Stump Only Me
date: 2008-07-24 04:52:15 -07:00
tags: ""
excerpt: ""
original_post_id: 106
toc: true
-----
I've just spent the last two hours pulling my hair out trying to get Single-Table Inheritance (STI) working with associations in `ActiveRecord`. After essentially walking through all of the possible `ActiveRecord` options in this setup, I finally stumbled upon a configuration that seems to work. So this post is an attempt to help the next poor bastard who is Googling in earnest for a solution to a similar problem.

So let's start with the domain model. I'm too spent at this point in the evening to port this to one of the standard examples. Instead I'll expose you to the domain of my particular problem. The app I'm working on is one that tracks (non-financial) lending transactions between two individuals. The parties involved, the item in question and when it's due are all tracked in the `Transaction` model (and `transactions` table). A `Transaction` has a number of states it walks through, using the [`acts_as_state_machine`](http://elitists.textdriven.com/svn/plugins/acts_as_state_machine/ acts_as_state_machine SVN repository) plugin. These state transitions are triggered by opaque-looking URLs that are sent via email to either party. These are one-time use actions that once consumed are no longer available. When an `Action` instance is created it also has a `before_save` callback that generates a unique ID (used in the URL) using `Digest::SHA1`.

So my plan was to have my `Transaction` class write one or more `Action` records for each possible action based on my state transitions. Take a look at the state diagram below:

![state-transitions.png](http://livollmers.net/wp-content/uploads/2008/07/state-transitions.jpg)

I want to encapsulate the actual work to be performed within the `Action` instance the user invokes by following the link in their email. So my plan is to use STI to have different sub-classes of `Action` that operate on a transaction and march it forward to its next state polymorphically.

Now STI may appear to be total overkill for this problem, but here are my reasons for going this route:

*  I want to have these opaque IDs written down somewhere to associate a specific action with a URL
*  When the action is complete, I want to remove the record so it can't be performed again
*  The state for a given `Transaction` can have more than one possible action. I want a separate for each action.

Whew. Okay, clear so far? So my initial code looked something like this:

      require "digest/sha1"
      
      class Action < ActiveRecord::Base
      
        belongs_to :transaction
        before_save :create_guid
      
        def create_guid
          sha1 = Digest::SHA1.new
          sha1.update transaction_id.to_s
          sha1.update type.downcase
          sha1.update DateTime.to_s
          self.guid = sha1.hexdigest
        end
      end
      
      class ReturnAction < Action
        def execute
          transaction.return!
        end
      end
      
      class AbortAction < Action
        def execute
          transaction.abort!
        end
      end
      
      class DisputeAction < Action
        def execute
          transaction.abort!
        end
      end

It seemed like a good idea at the time, but the strange thing was that no matter which incantation I tried, I simply couldn't create a new `Action` instance and have it write a record to the database. This simply didn't work:

    ReturnAction.create! :transaction_id => 1

There were no errors on the returned object. No exceptions were thrown. No queries to the database and certainly no insert statements executed. Just complete and utter silence. Out of desperation, as much as anything else, I removed the `belongs_to` declaration from the `Action` class and instead declared a `has_many` on the `Transaction` class. Voila! It worked like a champ.

After a bit of thought, the `has_many` association makes complete sense to me in the case where we want to create new `Action` instances for a particular `Transaction`. However, if you look in the code above, the `execute` methods of each sub-class are referring to a `transaction` object/method&mdash;which I no longer have. However I don't necessarily need the full-blown `belongs_to` association here. I can just fake the bits I want in the parent `Action` class like so:

      class Action < ActiveRecord::Base
        def transaction
          @transaction ||= Transaction.find(self.transaction_id)
        end
      end

So none if this is particularly earth-shattering. Sorry folks, no great gems of philosophical wisdom today. Just one man's small accomplishment blown completely out of proportion.
