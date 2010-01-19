----- 
kind: article
permalink: the-great-git-setup
created_at: 2009-05-08 04:17:14 -07:00
title: The Great Git Setup
excerpt: ""
original_post_id: 323
tags: 
- git
- ruby
toc: true
-----
One of the best ways to really learn the ins and outs of anything is to immerse yourself in all the gory details. Not only do you learn what works, what doesn't, what's elegant and what sucks, but you also start to grok the inner-workings. I just spent the last two weeks getting our own internal Git infrastructure up and running at work and I feel like Git and I have a new level of intimacy that we previously lacked. What follows is a review of the process and the solution that we've implemented.

For most of us at work, our primary Git experience is with GitHub. This is a good way to learn how Git's distributed model works, but GitHub provides some nice infrastructure that you simply don't have with a stock Git install. You have to cobble-together the rest from a variety of sources. <strike>So GitHub guys&mdash;if you're listening&mdash;it would be _fantastic_ if you provided real white-label GitHub solution for organizations to install locally. You guys have really spoiled us.</strike> (oops, nevermind. Checkout [GitHub:fi](http://fi.github.com/tour.html)). But until then, we have to roll our own&hellip;

# The Goals

First, let's review what exactly we were trying to accomplish. We wanted a solution that:
*  easily converted existing Subversion repositories to Git
*  provided a usable web view over all repos that was equal to, or exceeded, the stock SVN/DAV model
*  allowed us to designate a set of "authoritative" repositories
*  provided for "developer" repositories to allow developers to publish their changes
*  allowed for patch reviews (if teams decide to do that)


# The Solution

Right away we knew that we wanted two different types of repositories: authoritative and developer. Authoritative repos are ones that host the "official" source code and from which we create release builds from. When a developer wants to start working on a project, these are the repos they clone to get started.

The other type of repository belongs to an individual developer. Developers have read/write access to their own repos, but others only have read-only access. This allows developers to share changes in a pull-request model similar to how GitHub works.

## Permissions & Connectivity

Developers connect to these repositories in two different ways. We use the built-in `git://` protocol (with `git-daemon`) for read-only access and `ssh://` for read-write access. Developers clone authoritative repos and other developers' repos using the read-only `git://` protocol. Developers have a remote reference to their developer repository using ssh.

For each project, we designated one or more maintainers that have write-access to the authoritative repositories. These folks accept patches from other developers, test and integrate them on their local machines, and push final changes to the authoritative repositories. We manage the authoritative repos using [gitosis](http://eagain.net/gitweb/?p=gitosis.git). Check out [this great tutorial](http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way) for details on setting up gitosis.

## gitosis

On our central "git box" we create a "git" user which owns both the `gitosis-admin` repository as well as all the authoritative repositories. Gitosis is bootstrapped  with a single SSH public key that gives the associated user the ability to write to that Git repo over SSH. That user can then add more keys and configuration allowing other users to manage projects. Gitosis works a bit like the CVSROOT project in CVS&mdash;it is a special Git repo that allows us to configure other Git repositories. We use gitosis to configure our designated maintainers for each project.

Our authoritative repos are housed in `/home/git/repositories`. Our developer repositories are located in `/opt/repos`, where each developer has their own directory to put Git repos in.

## git daemon

We run `git daemon` to allow for anonymous read-only access. We configured `git daemon` to serve up all Git repositories found in the `/opt/repos` directory with read-only access. We also symlink the authoritative repositories (`/home/git/repositories`) into this directory so that we can serve up read-only access to authoritative repositories also.

## gitweb

For all the power Git has, there sure are a lot of half-baked web interfaces for it. We did our best to vet the tools listed on the [Git site](http://git.or.cz/gitwiki/InterfacesFrontendsAndTools). A good number of the them were either abandoned or simply didn't work. In the end we went with the venerable old [gitweb](http://git.or.cz/gitwiki/Gitweb).

Gitweb has a ton of functionality&mdash;including all kinds of search capability, different views (by tag, by commit, by tree) and even serves up an Atom feed of changes&mdash;but it is definitely a designed-by-developers-for-developers</code>. (NB: In case you missed the markup, that is considered an epithet on my team). 

Frankly I was amazed that somebody hadn't built a Rails app to manage this stuff. Yes, we  looked at [gitorious](http://gitorious.org/projects/gitorious) and even tried to set it up. After three hours I still didn't have a working installation and my patience had run out. While gitorious appears to be a nice turn-key solution, I don't think it's actually that great of a fit for us. So gitweb it is. Sigh.

## The Flow

With me so far? Maybe not. Let's look at a picture then&hellip;

![98EE3AE7-C4F4-4D1D-B49B-DCC230EA7459.jpg](/images/2009/05/98ee3ae7-c4f4-4d1d-b49b-dcc230ea7459.jpg)

In this picture the authoritative and developer repos are drawn in separate boxes (since they're logically separate), but they are located on the same machine in reality. Let's cover a couple of common scenarios:

## New Developer, Old Project

A developer starts by cloning an authoritative repo using the `git://` protocol (remember, read-only). This will create, by default, a remote reference named `origin` that points back to the authoritative repo.

The next step is for them to create a developer repo in their directory for the same project on the central git machine. They also want to a remote reference to their developer repo so that they can push changes to that. That would looks something like:

<% highlight :sh do %>
git remote add alex ssh://git/opt/repos/alex/circus/clown-car
<% end %>

If this user is also a maintainer, they need to add a _third_ remote reference which gives them read/write access to the authoritative repository. The way that gitosis works is by accepting SSH keys on behalf of the git user. So if you're properly configured, you can push changes over SSH by logging in as the `git` user. A maintainer would add a read/write reference like so:

<% highlight :sh do %>
git remote add main ssh://git@git/home/git/repositories/circus/clown-car
<% end %>

Because of the way gitosis configures the SSH keys in `/home/git/.ssh/authorized_keys` and the fact that the default protocol is ssh, this remote reference could also be added like this:

<% highlight :sh do %>
git remote add main git@git:circus/clown-car
<% end %>

Now because there are number of steps involved here, we wrote a little command-line tool (as a RubyGem) that takes care of these steps all in one go. Right now, it's _very_ specific to our setup at Evri, but I can see how we might extract a common tool (oh boy&hellip;another side-project&hellip;)

## Old Developer, New Project

When it's time to create a new project, a developer usually starts out by creating a new Git repo on their local box while they're building out the initial version. Once it's time to share, that developer can create a new developer repo on our central Git machine just by SSH'ing in and making the appropriate directory, adding the remote ref to their local repo and pushing changes. Again, our internal tools sets this up all in one go.

Once that project is ready to have an authoritative repo, a gitosis-enabled user will pull the latest changes for the `gitosis-admin` project. They'll edit the `gitosis.conf` file to add the new project (and members) and commit the changes. Then the developer adds a new remote ref (a read/write one as the `git` user) and pushes changes out to the main repo.

## Sharing Patches

The most common flow is when developers share patches with each other. There are a couple of ways to do it. Developers keep their developer repository up-to-date and email requests to their teammates to pull changes from their repo (a la GitHub). Developers may also choose to share patches via email using `git format-patch`, `git send-mail` and `git am`.

Ultimately the maintainers are responsible for gathering patches from developers and integrating them back into the authoritative repositories.

![git-cycle.png](/images/2009/05/git-cycle.png)

For folks used to version control systems like CVS or Subversion this feels like an awful lot of hoop-jumping. One part that I can't diagram or explain as a series of technical bullet-points is the stewardship the pro-Git folks have to take on. People who are switching to Git get frustrated by the byzantine nomenclature and steep learning curve, so a big part of the change and setup is simply helping people out when they get stuck.
