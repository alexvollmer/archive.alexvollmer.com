#!/usr/bin/env ruby

require "fileutils"
require "pathname"
require "yaml"

include FileUtils

Dir["content/posts/*"].each do |post|
  open(post) do |f|
    f.readline                  # discard first YAML separator
    lines = ""
    while (line = f.readline) != "-----\n"
      lines << line
    end
    metadata = YAML.load(lines)
    d = metadata["date"]
    new_dir = sprintf("content/posts/%04d/%02d/%02d",
                      d.year, d.month, d.day)
    mkdir_p(new_dir) unless File.directory?(new_dir)
    new_path = Pathname(new_dir) + File.basename(post)
    mv post, new_path
  end
end
