require "BlueCloth"
require "nokogiri"


def format_rfc822_date(date)
  date.strftime("%a, %d %b %Y %H:%M:%S %Z")
end

def format_rfc3339_date(date)
  first = date.strftime("%Y-%m-%dT%H:%M:%S")
  last = date.strftime("%z")
  "#{first}#{last[0..2]}:#{last[3..4]}"
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
  get_post_body(post).css("body p").find do |elem|
    child = elem.children.first
    grandchild = child.children.first
    child.inner_html.strip !~ /\<img/
  end.inner_html
end

def include_post_body(post)
  get_post_body(post).children.map{ |x| x.to_s }.join(" ")
end

def blog_tab_link
  link = "<li"
  link << ' class="hal"' if @item.identifier.match(%r[^/($|posts/|tags/)]) rescue ''
  link << "><a href=\"/\">Writing</a></li>"
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
  link << ' class="hal"' if @item.identifier.match(%r[^/about/]) rescue ''
  link << ">"
  link << '<a href="/about/">About</a>'
  link << "</li>"
  link
end

def create_tag_pages
  tags = []
  tag_set(@site.articles).each do |tag|
    items << Nanoc3::Item.new("= render('_tag_page', :tag => '#{tag}')",
                              { :title => "Category: #{tag}" },
                              "/tags/#{tag}/")
  end

  items << Nanoc3::Item.new("= render('_all_tags')",
                            { :title => "All tags" },
                            "/tags/")
end

def create_date_pages
  years = post_years(@site.articles)
  items << Nanoc3::Item.new("= render('_all_post_years', :years => #{years.inspect})",
                            { :title => "All years" }, "/posts/")

  years.each do |year|
    items << Nanoc3::Item.new("= render('_posts_by_year', :year => #{year})",
                              { :title => "All posts for #{year}" }, "/posts/#{year}/")

    posts = posts_by_month(year, @site.articles)
    (1..12).each do |month|
      title = "All posts for #{Date::MONTHNAMES[month]}"
      backlink = "<a href='/posts/#{year}/'>all for #{year}</a>"
      full_path = sprintf("/posts/%04d/%02d/", year, month)

      unless posts[month].empty?
        items << Nanoc3::Item.new("= render('_posts_by_month', :year => #{year}, :month => #{month})",
                                  {
                                    :title => title,
                                    :backlink => backlink
                                  },
                                  full_path)
      end
    end
  end
end
