require "BlueCloth"
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
  html = BlueCloth.new(post.raw_content).to_html
  doc = Nokogiri.HTML(html)
  (doc/"body")
end

def find_text_node(nodes)
  if nodes.empty?
    nil
  elsif text = nodes.find{ |x| x.name == "text" && x.text !~ /^\n+$/ }
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

def blog_tab_link
  link = "<li"
  link << ' class="hal"' if @item.identifier.match(%r[^/($|posts/|tags/)]) rescue ''
  link << "><a href=\"/\">Blog</a></li>"
  link
end

def projects_tab_link
  link = "<li"
  link << ' class="hal"' if @item.identifier.match(%r[^/projects/]) rescue ''
  link << ">"
  link << '<a href="/projects/">Projects</a>'
  link << "</li>"
  link
end

def contact_tab_link
  link = "<li"
  link << ' class="hal"' if @item.identifier.match(%r[^/contact/]) rescue ''
  link << ">"
  link << '<a href="/contact/">Contact</a>'
  link << "</li>"
  link
end
