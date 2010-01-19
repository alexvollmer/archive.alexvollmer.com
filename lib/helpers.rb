require "nokogiri"

module Nanoc3::Helpers::Blogging
  # this is an awful, awful hack because the blogging module assumes
  # that the :created_at attribute is a string and might not already
  # be a valid Time.

  def convert_items(items)
    items.each { |i| i[:created_at] = i[:created_at].to_s }
  end
end

def format_rfc822_date(date)
  date.strftime("%Y-%m-%dT%H:%M:%S%Z")
end

def get_post_body(post)
  doc = Nokogiri(open("output/posts/#{post.full_path}/index.html").read)
  (doc/"body")
end

def find_text_node(nodes)
  if nodes.empty?
    nil
  elsif text = nodes.find{ |x| x.name == "text" && x.text !~ /\n+/ }
    return text
  else
    find_text_node(nodes.children)
  end
end

def include_post_summary(post)
  children = get_post_body(post).children
  find_text_node(children)
end

def include_post_body(post)
  get_post_body(post).children.map{ |x| x.to_s }.join(" ")
end
