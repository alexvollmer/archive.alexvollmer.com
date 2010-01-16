----- 
permalink: rewriting-history-with-git
layout: post
filters_pre: markdown
title: Rewriting History with Git
comments: 
- :author: Janos
  :date: 2009-02-12 23:11:49 -08:00
  :body: |-
    I've seen a <a href="http://www.newartisans.com/blog/2008/04/diving-into-git.html" rel="nofollow">nice example</a> for when you want to rewrite history: just imagine committing something you never wanted to -- a temp file with sensitive/unrelated stuff, or as simple as just mistakenly importing a tar.gz file you don't want to carry on in the repo.
    
    And rewriting history is not black magic -- you could do it by hand saving patches and re-importing them.  But, by making it a standard, and painless feature, it's there whenever you use git.  I like it.
  :url: http://farkas.ch/
  :id: 
- :author: Ted Naleid
  :date: 2009-02-02 03:57:00 -08:00
  :body: |-
    I like the ability to squash merges and rewrite history in principal, but I'm not sure that I'm fully grokking the value in day-to-day usage.
    
    In most situations, taking the time to rewrite history feels like a violation of YAGNI, and kind of a pre-optimization for something I'm not really that likely to ever look at again.  The percentage of commits that I look back in history at has to be less than 10%, and I do that without any real problem now even though they haven't been cleaned up.
    
    I also worry about removing something out of history that might actually be useful some day.   A failed experiment, or one that I timeboxed and had to bail on because I didn't quite get it done.
    
    I've run into a couple of situations where I needed it and it was very valuable (on OSX, file getting checked in different cases causing cloned repos to choke, and a server password that I didn't want in history).
    
    In an open source model, where you're trying to get your changes pulled by a "lieutenant" or "dictator", you want your commits to be as clean as possible.  That makes sense, as at least one and possibly a lot of people will be looking at your commit/patchfile.
    
    For smaller teams, working with a subversion style workflow (a "blessed" central repo that all of the devs are pushing into, rather than some gatekeeper that's pulling stuff in), do you find yourself doing this a lot.  Or is it more of a special case situation like the one you outline above where two pieces of work are tangled up, but you want to be able to work on them seperately?
  :url: http://naleid.com/blog
  :id: 
- :author: alex
  :date: 2009-02-02 04:43:32 -08:00
  :body: "@Ted, this technique is really more the exception than the rule for me. Though even in a smaller team I think there are times when it's worth doing this kind of cleanup. On my little two-man team at work we often email patchsets to each other for review which works pretty well for us. It doesn't replace a real face-to-face conversation, but it gives us code-review and it's relatively convenient and lightweight. \r\n\
    \r\n\
    My point here is about having the ability to rewrite your history when you need it. I feel like having that capability frees up my mind to focus on solving the problem first, then cleaning up the implementation. If I have to simultaneously juggle getting a <i>good</i> solution with a <i>readable</i> solution all in one go, it's less likely I'll get either.\r\n\
    \r\n\
    This isn't something I do all the time, but is very handy for work that involved a lot of churn. I wouldn't make a regular habit of always going back and rewriting history as some checkbox to be marked in the release process\xE2\x80\x94that's just silly\xE2\x80\x94but there are times when it's handy. Plus, if you understand how git works, it's relatively simple to do.\r\n\
    \r\n\
    Cheers, Alex"
  :url: http://livollmers.net
  :id: 
- :author: Ted Naleid
  :date: 2009-02-02 05:10:14 -08:00
  :body: |-
    That makes sense, thanks Alex.  Actually, the more I typed my comment above, the more situations I was thinking of where being able to rebase my stuff would actually be nice :).  
    
    It's not something I'd do every day, but it does seem like one of those tasks that's useful to know well enough to not have to reach for the manual every time you want to do it.
  :url: http://naleid.com/blog
  :id: 
excerpt: ""
date: 2009-01-31 20:04:13 -08:00
tags: Git
toc: true
-----
This past week I spent some quality time with git's history-rewriting capabilities. Over the past few weeks I had been working on a rather long-lived branch full of JRuby and Merb patches. Some of the fixes and changes were ready to go in the next release, others were still a wee bit experimental and so my plan was to split the patches in two. The ones that were ready would get pushed upstream while the not-ready-for-primetime stuff stayed on a local branch.

That seemed like a great plan until I realized just how tangled some of the patches were. It isn't difficult for this to happen. As you extend the functionality of a system, you often refine earlier work. This was especially true in my case since we were introducing JRuby to a previously Java-only project and so there was a lot of experimentation and refinement. What I was really trying to do was re-write my commit history to separate the changes. Small cleanup commits could be collapsed with others to make the entire commit-set something that my teammates could easily understand.
# Getting Started
The most basic kind of re-writing you can do is simply amending your last commit. On the command line this is accomplished with <tt>git commit --amend</tt>. The bigger rewrite-hammer is <tt>git rebase -i &lt;ref&gt;</tt>. This command will pop off all of your commits to the point specified by <tt>&lt;ref&gt;</tt>, provide you with a control file to edit and then re-apply your patches as directed.

The control file (a term I just made up) looks kinda like this:
`pick 1cea777 Initial introduction of Merb.
pick 5fe7a19 Favor XML over HTML as the "default" content-type.
pick 6791134 Cleaned up the 'views' directory, out with the old, in with the new.
pick ae6adac Put lots of back-navigation links to make it nice 'n' easy to use.
pick 1da31ca Removed last vestiges of the RestServlet-related configuration and code.
pick b9fe3b9 Added error views, updated error-handling and improvised content dispatch.
pick bf92292 Routing cleanup. This is much more pleasant to read.
pick ec74c63 An attempt to get RSpec working with Maven and JRuby.

# Rebase 92ddc87..ec74c63 onto 92ddc87
#
# Commands:
#  p, pick = use commit
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#
# If you remove a line here THAT COMMIT WILL BE LOST.
# However, if you remove everything, the rebase will be aborted.
#`</pre>
The top section lists all of your patches, one per line. You can edit this section to do any of the following:
*  Reorder the commits (just move lines up or down)
*  Edit a commit (replace “pick” with “edit” or simply “e”)
*  Remove a commit (just remove the line)
*  Merge with a previous commit (replace “pick” with “squash” or “s”)

Think of this list like a program of execution. Once you save the file and return control to git, it will attempt to execute this program. I say _attempt_ here because sometimes git runs into conflicts when it comes to re-ordering patches.
# Editing Commits
When you mark a commit for editing (with “edit” or “e”) git will attempt to apply all patches up to, and including that commit, and stop. This threw me at first because for some reason I had the unreasonable expectation that somehow the changes in the last commit would only be applied to the working tree and, perhaps, the index. Instead, that commit is fully applied, but all commits past that are pending. To add to my confusion, there isn't an easily accessible marker to indicate that you are in the middle of rebase (unless you frequently scan the <tt>.git</tt> directory as a matter of habit). At this point you could _amend_ the commit (with <tt>git commit --amend</tt>) or insert other commits.

Sometimes I use this just to fix up the commit message. When I'm working on a new feature that has a lot of trial-and-error I tend to mark the first commit message with “WIP” to remind myself to review that patch and the ones following to see if I can clean them up. This is an area where git really shines. In a system like Subversion your audience (other coders who look at your changes) end up walking through whatever little mini-epic you've composed as you try things out, add things and remove things. This makes for some difficult reading for consumers of those patches and so a lot of folks tend to stack up big changes and then send in the big über-commit.

The problem with building the mega-patch is that you don't have a lot of scaffolding under you while you are building it. If you go off and explore something that doesn't turn out right, you generally have to do a lot of manual reverting. This simply sucks and is a waste of time. With git I can work in lots of incremental commits, then go back and edit them into something sensible once I'm ready to push changes.

Once you've finished doing whatever edit you want to do for that commit, simply type <tt>git rebase --continue</tt> and the remainder of the “script” will execute. If any other “edits” are in the pipeline, the process will repeat itself until the rebase is completed.
# Squashing Commits
I _looooove_ squashing commits in git. For any moderately complicated work, it's rare that I get it right the first time. Usually as I go along I find some mistake I made or find a refinement that cleans up the original work. As often as not, it's usually a couple of commits away so amending the last commit isn't going to help me. But hey, no worries! I simply commit the change and leave a log message for myself to merge it with another commit. Then, when I run the interactive rebase, I can simply move this commit up the list and change it from “pick” to “squash” (or “s”) and let git merge the two commits.

When rebasing encounters a "squash" it will apply the changes in both commits. If successful, git will prompt you with a commit message file that includes the original commit messages of _both_ commits. You can choose either, both or neither of these and save the file to continue.
# Resolving Conflicts
Sometimes when applying a commit, git will run into conflicts and bail out on a merge. Whenever this happens to me I always have a little moment of panic as if I've broken something, but fear not—you can fix this. When this happens git tries to stage as many of the changes as it can. Any conflicts are left unstaged and need to be edited (look for the standard conflict markers), and then re-staged into the index. When you commit, git should show you the original commit message of the patch it was attempting to apply, which you can edit or keep. Once the commit succeeds, rebasing should automatically continue.
# The Big Red Button
Sometimes you may just give up on a rebase. Either you can't commit the time to it, you don't really want to go through with it, or your patience has reached its limit. At any point, before the rebase has completed, you can execute <tt>git rebase --abort</tt> and your working tree, index and commit-log will all be returned to the state prior to starting the rebase. Think of this as the big red “stop” button for rebasing.
# Playing Fast and Loose with Branches
If you come from other <span class="caps"><span class="caps"><span class="caps">SCM</span></span></span> systems like Subversion, you tend to treat branches as expensive and something you only use on occasion. With git, branches are cheap and easy like drinks in Tijuana. Be fearless! Not sure about some exploration? Make a branch!

If rebasing makes you nervous, and you're not entirely confident that aborting will save you, I suggest creating a branch on which to rebase. Simply create a new branch from where you're at with <tt>git checkout -b &lt;branch&gt;</tt>. You'll be immediately switched to that branch with your commit log looking exactly like the branch you came from. Here you can rebase, edit, remove, add and generally go crazy with your commits.

Once you've got your commits where you want them it's simply a matter of getting them back into whatever you consider your “main” branch to be and pushing any changes upstream. This works really well when you have rendez-vous point like a Github repo or an <span class="caps"><span class="caps"><span class="caps">SVN</span></span></span> server (we do a lot of git on top of Subversion at work). Assuming that you've been adding changes on your master branch, you might create a new branch off of <tt>master</tt> that you might call <tt>exp</tt>. On the <tt>exp</tt> branch you might rebase and wreak all sorts of havoc on the commit log. Once you have your commits where you want them, switch back to your <tt>master</tt> branch and reset it to point to the head of your upstream repo. If you're using git all the way, simply merge your <tt>exp</tt> branch over. If you're running git on top of Subversion, simply cherry-pick the commits on the <tt>exp</tt> branch (in order!!!) and push the changes upstream.

It's hard to stress how important it is to shift your mindset into thinking in terms of sharing patches. Treat your commits like individual, digestible changes. Even if you're working by yourself or in a small team, I still think there's value in being disciplined with your commits.
