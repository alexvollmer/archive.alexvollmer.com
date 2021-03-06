----- 
sha1: d835972308b3571eeae7284b822d300f74072789
kind: article
permalink: gemdoc-completion-in-zsh
created_at: 2008-06-25 16:30:24 -07:00
title: gemdoc completion in zsh
excerpt: ""
original_post_id: 101
tags: 
- ruby
- zsh
- geekery
toc: true
-----
This week I stumbled upon Stephen Celis' awesome bit of shell-fu, [gemdoc](http://stephencelis.com/archive/2008/6/bashfully-yours-gem-shortcuts gemdoc), which allows you to quickly get to the HTML docs for installed gems via command-line. Unfortunately I abandoned bash years ago for zsh and Stephen's shell bits needed a little porting. For me, zsh, is a bit like swiss-army knife where about 95% of it is a mystery to me, but the 5% I use I couldn't live without. So simply switching back to bash is a no-go.

My setup is little-bit complicated, but I believe the following, stripped-down, recipe should work:

<% highlight :sh do %>
GEMDIR=$(gem env gemdir)
OPEN=$(whence xdg-open || whence open)

gemdoc() {
  ${OPEN} $GEMDIR/doc/`$(which ls) $GEMDIR/doc | grep $1 | sort | tail -1`/rdoc/index.html
}

_gemdocomplete() {
  reply=( `$(which ls) $GEMDIR/doc` )
}

compctl -K _gemdocomplete gemdoc
<% end %>

_Update 6/25/08-10:30_: Updated to work for both Penguins and Macs.
