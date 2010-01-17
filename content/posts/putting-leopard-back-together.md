----- 
permalink: putting-leopard-back-together
title: Putting Leopard Back Together
date: 2007-12-15 05:50:01 -08:00
tags: ""
excerpt: ""
original_post_id: 38
toc: true
-----
## RSpec and TextMate


Ever since I upgraded to Leopard my wonderful RSpec TextMate bundle simply stopped working. This may not have been a result of the Leopard upgrade per se, but things went seriously south about the same time. Between the day after Leopard was released and now I&#8217;ve been tearing my hair out trying to figure just what went wrong. Finally, last night, I capped off several weeks of frustrating exploration by getting the damn bundle working again.


My big &#8220;A-Ha&#8221; moment was figuring out that there are, apparently, _two_ RSpec bundles for TextMate. One is hosted at RubyForge by the rspec guys and another that is hosted at Macromates. I had installed the one from RubyForge which gave me a host of odd errors. When I finally realized that there were two parallel projects and I installed the Macromates one, I was back in business. Also, another problem that I think I had was upgrading to the latest rspec version (1.0.8), though downgrading didn&#8217;t seem to help.


So to get this working I first had to troll around for any existing RSpec bundles that I had installed. All of the HOWTOs I read had me install the bundle (via subversion) into `~/Library/Application Support/TextMate/Bundles`. My original RSpec bundle wasn&#8217;t there but was installed in `~/Library/Application Support/TextMate/Pristine Copy/Bundles`. Another location to check for is `/Library/Application Support/TextMate/Bundles` (note the lack of &#8216;~&#8217;).


## RubyGems and RDoc


My other outstanding irritant in the post-Leopard world was the sudden disappearance of the RDoc of the gems I&#8217;ve installed from my beloved `gem_server`. I love the `ri` command and use it extensively, but being able to search around and expand the source from within a browser is _extremely_ useful for me. For example, I&#8217;m still in the process of gaining fluency with RSpec and to be able to browse around to see what&#8217;s available is absolutely crucial to any kind of productivity while I&#8217;m still in a steep learning curve.


After trolling around it appears that once you&#8217;ve taken the step to upgrade RubyGems (the dreaded `sudo gem update --system`) it&#8217;s all about setting up the `GEM_HOME` and `GEM_PATH` variables. There seem to be a couple of ways to do this: you can set this up in the shell configuration file of your choice (e.g. `~/.bashrc` for bash users, `~/.zshrc` for zsh users, etc.) _and/or_ you can do this (on Mac) by entering these in the `~/.MacOSX/environment.plist`.


My `environment.plist` looks like this:


    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <dict>
        ...
        <string>/opt/local/lib/libtidy</string>
        <key>GEM_HOME</key>
        <string>/Library/Ruby/Gems/1.8</string>
        <key>GEM_PATH</key>
        <string>/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8</string>
      </dict>
    </plist>
