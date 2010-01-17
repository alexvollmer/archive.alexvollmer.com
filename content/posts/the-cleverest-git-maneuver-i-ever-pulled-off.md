----- 
permalink: the-cleverest-git-maneuver-i-ever-pulled-off
title: The Cleverest Git Maneuver I Ever Pulled Off
excerpt: ""
date: 2009-10-09 15:44:04 -07:00
tags: ""
toc: true
-----
So there I was, reviewing a series of commits, sucking air between my teeth and cringing when I came upon one of those lazy commits that has way too much stuff in it to reasonably digest. I needed a way to go back and split that commit into two or three separate commits. This is pretty easy to do with `git rebase`. You can just do a mixed reset of the last commit, stage the bits you want in one commit, stage the next bits and put that in a separate commit.

This all works great—until it doesn't. The ability to stage parts of a file is one of my favorite features of `git`, but there are times when you have changes that `git` won't let you split apart. Usually I give up at this point and just abort the rebase. 

But yesterday I must have had too much coffee because I was _determined_ to figure out how to do this. The changes that I wanted to split out were pretty easy to find. It was easy to remove them by hand and commit those. But I didn't want to have to manually add them _back_—that was too mistake-prone. What I needed was a way to invert the commit that removed those lines. What I needed was `git revert`. If I could revert my subtractions (in effect, _adding_ the changes back), then I could squash the commits and rewrite history.

So here's what I did:
<ol>
*  Started an interactive rebase session (`git rebase -i`)
*  Marked the commit I wanted to split as an "edit"
*  Manually removed the code I didn't want in the first commit, staged the changes and made a new commit
*  Revert the subtraction with `git revert HEAD`
*  Complete that rebase with `git rebase --continue`
*  Start a new rebase and squash the original commit with the manual changes one
</ol>

Note that I didn't use `git reset` after step 2. It wouldn't have helped me because interactive staging wasn't working for me. I also marked all the commits in the second rebase as "edits", so I could fix the commit messages.

Put another way, the commits transformed like this, from left to right:

![git revert.png](/images/2009/10/git-revert.png)

Maybe I'm overly fussy about clean commits. I'll admit that at times that my attention to cleanliness borders on the obsessive, but having the ability to go back and clean things up is one of my favorite things about `git`. Maybe I'm just not smart enough, but I usually don't know nearly as much at the beginning of a commit as I do at the end. With `git`, I can make it look like I do.
