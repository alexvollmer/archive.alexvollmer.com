--- 
permalink: scripting-build-selection-in-xcode
title: Scripting Build Selection in Xcode
kind: article
tags: 
- iphone
- xcode
- applescript
created_at: 2010-03-06 00:20:30 -08:00
---
When I'm doing iPhone development, I constantly 
switch between running on the device and the simulator. As far
as I can tell, Xcode doesn't provide an easily-accessible keyboard
shortcuts for switching between SDKs. Since I _hate_ breaking up my flow by
having to reach for the mouse, I put together a couple of
AppleScripts that bind hot-keys to switching between SDKs. Download
these two scripts to wherever you like to store your AppleScripts.
I like to put mine in `~/Library/Scripts`.

First, is the script that selects the SDK for the device:

<div>
<a href="/files/SwitchToDevice.scpt" class="attachment">
  SwitchToDevice.scpt
</a>

<% highlight :applescript do %>
tell application "Xcode"
  set myProject to active project document
  set active SDK of myProject to "iphoneos3.1.3"
end tell
<% end %>
</div>

Next up, the script that selects the simulator SDK:

<div> 
<a href="/files/SwitchToSimulator.scpt" class="attachment">
  SwitchToSimulator.scpt
</a>

<% highlight :applescript do %>
tell application "Xcode"
  set myProject to active project document
  set active SDK of myProject to "iphonesimulator3.1.3"
end tell
<% end %>
</div>

Now, open up Xcode and and select "Edit User Scripts..." in the
scripts menu:

<img src="/images/2010/02/xcode-script-menu.png" class="plain"/>

This opens the script organizer. In the left-hand pane is a list of
all the script groups. Which group you put a script in effects what
submenu they are available from in the main scripts menu. But we like
shortcut keys so who cares where it goes? I put these in the "Build"
group, but feel free to put them wherever makes the most sense to
you. Select the group you want to add these scripts to and click the "+"
button and choose "Add Script File&hellip;":

<img src="/images/2010/02/edit-user-scripts-dropdown.png" class="plain"/>

Use the standard Finder dialog to find the scripts you just downloaded
and select one of them. To set the shortcut key for the script,
double-click the right-hand column of the newly-added script. For the
simulator script I use `⌃⌘⎇S` and `⌃⌘⎇D` for the device script. You
can try out different combinations. If you come up with a key-chord
that clobbers an existing key-binding Xcode will give you a warning at
the bottom of the window.

<img src="/images/2010/02/edit-user-scripts-warning.png" class="plain"/>

One thing to be aware of is that while you're setting the shortcut
key for the script _all_ of your keyboard input is directed to that
field. So you can't use ESC to cancel or Enter to set the value. You
need to grab that infernal mouse and click somewhere else.

Before you close the dialog, be sure to set the "Output" drop-down
menu to "Discard Output" otherwise Xcode will paste some odd gibberish
into your current file. And, just in case there's some kind of
unforseeable error, set "Errors" drop down to "Display in Alert". Once
you have both scripts configured you can close the dialog and try your
new hot-keys out.

I don't claim to have any proficiency with AppleScript, so there
may very well be a better way to do this. Certainly one thing that is
brittle about these scripts is how they are hard-coded to a particular
version of the SDK. Whenever a new SDK is released I'll have to update
the strings in the script. Oh well, it beats having to reach for the
mouse several more times a day.
