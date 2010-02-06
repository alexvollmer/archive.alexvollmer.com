require "BlueCloth"
require "nokogiri"


def format_rfc822_date(date)
  date.strftime("%Y-%m-%dT%H:%M:%S%Z")
end

def get_post_body(post)
  doc = Nokogiri.HTML(post.content)
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

def create_tag_pages
  tags = []
  tag_set(items).each do |tag|
    items << Nanoc3::Item.new("= render('_tag_page', :tag => '#{tag}')",
                              { :title => "Category: #{tag}" },
                              "/tags/#{tag}/")
  end

  items << Nanoc3::Item.new("= render('_all_tags')",
                            { :title => "All tags" },
                            "/tags/")
end

def create_date_pages
  post_years(items).each do |year|
    items << Nanoc3::Item.new("= render('_posts_by_year', :year => #{year})",
                              { :title => "All posts for #{year}" }, "/posts/#{year}/")

    (1..12).each do |month|
      title = "All posts for #{Date::MONTHNAMES[month]}"
      backlink = "<a href='/posts/#{year}/'>all for #{year}</a>"
      full_path = sprintf("/posts/%04d/%02d/", year, month)

      items << Nanoc3::Item.new("= render('_posts_by_month', :year => #{year}, :month => #{month})",
                                {
                                  :title => title,
                                  :backlink => backlink
                                },
                                full_path)
    end
  end
end
