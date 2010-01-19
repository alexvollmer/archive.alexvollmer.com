#!/usr/bin/env ruby

require "yaml"

Dir["content/posts/**/*.md"].each do |post|
  content = open(post).read
  m = content.match(/-----\s+(.*?)\s+-----\s+(.*)$/m)
  attributes, body = YAML.load(m[1]), m[2]
  attributes["kind"] = 'article'
  attributes["created_at"] = attributes.delete("date")

  open(post, "w") do |f|
    f.print "--"
    f.print attributes.to_yaml
    f.puts "-----"
    f.puts body
  end
  puts "Wrote #{post}"
end
