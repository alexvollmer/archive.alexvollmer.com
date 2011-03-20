--- 
sha1: ae9318e9300b3398c5b2daeb76bbaaa39d719b01
permalink: rvm-meets-zsh
title: RVM meets zsh
kind: article
tags: 
- zsh
- ruby
created_at: 2010-02-27 17:19:45.322657 -08:00
---
[RVM](http://rvm.beginrescueend.com/) is a nifty tool for managing
multiple ruby installations. Not only does it make it easy to install
and switch between multiple rubies, but you can also install
gems without `sudo` access. But, as great as RVM is, I still have to
remember to switch between rubies and often I don't remember to do it
until I see some weird behavior or a test breaks. I'm very lazy and
I want even _more_. 

So I've setup a tiny bit of zsh-fu to automatically switch which ruby
implementation to use based on the directory that I'm in. To do this, one
needs to take advantage of [zsh's
hooks](http://zsh.sourceforge.net/Doc/Release/Functions.html#SEC45),
particular the one invoked when you change directories. By default,
you can simply declare a function named `chdir()` and it will
automatically be invoked whenever you change directories. Mine looks
like this:

<% highlight :sh do %>
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
      sun-cmd) print -Pn "\e]l%~\e\\"
        ;;
      *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%3~\a"
        ;;
    esac
}
<% end %>

This function just prints out the name of the directory I've change
into and it's found in a lot of zsh distributions. To keep things clean
I want to have a separate function that just manages the RVM
updating. For the moment, let's ignore the fact that I already have an
existing `chdir()` function, and look at the hook function I created
to invoke RVM:

<% highlight :sh do %>
chpwd_check_rvm() {
    current_version=$(rvm info | grep " version:" | cut -d '"' -f2)
    dir=$(pwd)
    while [ "${dir}" != "" ]; do
        cfg="${dir}/.rvminfo"
        if [ -f ${cfg} ]; then
            want_version=$(cat ${cfg})
            if [ "${want_version}" != "${current_version}" ]; then
                rvm use ${want_version}
            fi
            break
        else
            dir=${dir%/*}
        fi
    done
}
<% end %>

This function looks for a file named `.rvminfo` in the current
directory (this function is invoked _after_ we've changed
directories). If the file isn't found in the new directory, it searches
upward through each parent directory to see if it can find one. If
it's found, the function invokes `rvm use` with the version string
found in that file.

<% highlight :sh do %>
$ cat .rvminfo
1.8.6
<% end %>

There's also some additional checking to avoid extra `rvm` invocations
if we're already set to the desired version. This is done more to
reduce the chatter in the shell than for performance reasons.

Now let's get back to invoking multiple hook functions.
If you have more than one function you'd like to have called when
you change directories, you can declare these in an array named
`chpwd_functions`. After declaring the `chpwd_check_rvm()` function
above, having two functions for the `cd` hook is trivial. I just add
this declaration to my `~/.zshrc` file:

<% highlight :sh do %>
#--- chpwd_functions
chpwd_functions=( chpwd_check_rvm chpwd )
<% end %>

Now, whenever I change into a directory with a `.rvminfo` file, my
hooks are automatically executed and I get the right ruby version:

<% highlight :sh do %>
[island] ~/Development: cd alexvollmer.com 
<i> Now using ruby 1.8.6 p383 </i>
<% end %>

One final note is that I put all of my specific functions in the
`~/.zsh/functions` directory, and automatically load all of them in my
`~/.zshrc` file with the snippet below. I do all of this _before_ I
declare the `chpwd_functions` array.

<% highlight :sh do %>
#--- Shell Functions ---
#
fpath+=(
  ${HOME}/.zsh/functions
)

autoload -U ~/.zsh/functions/*(:t)
<% end %>

You may want to organize your functions differently. Just be aware
that zsh needs to know about your functions before you can put them in
the `chpwd_functions` array.

_UPDATE (3/1/2010):_ Per comments below from RVM's creator, Wayne Seguin, RVM
actually comes with it's own built-in way of handling this. Somehow I
completely missed [the rvmrc
documentation](http://rvm.beginrescueend.com/workflow/rvmrc/) for this
feature (how embarassing!). I'm usually inclined to avoid re-inventing
the wheel, but there are two small things I like about the way I
implemented this. First, the solution proposed here doesn't redefine
the `cd` command, which feels a bit like duck-punching the shell to
me. I don't know if bash has the same kind of hooks that zsh does, so
the implementation is understandable. As for me, I like the hooks
better.  Second, the solution I show here works for any sub-directory
within a project that has a specific RVM setting. That said, I'll
probably just use what's already been implemented in RVM.
