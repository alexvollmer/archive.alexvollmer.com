require "erb"
require "pathname"
require "nanoc3/cli"

layouts = Pathname("layouts")
home_erb = ERB.new(open(layouts + "home.html.erb").readlines[2..-1].join,
                   nil, nil, "@home")

eval <<-EOF
def render_home_template
  #{home_erb.src}
end
EOF

module SiteUtils

  def collect_posts_by_tags_and_year(site)
    by_tag = Hash.new { |h,k| h[k] = [] }
    by_date = Hash.new { |h,k| h[k] = Hash.new { |h1,k1| h1[k1] = [] } }

    # index all the posts
    site.items.select do |i|
      i.attributes[:kind] == "article"
    end.sort_by { |i| i.created_at }.each do |item|
      item.tags.each { |tag| by_tag[tag] << item }
      by_date[item.created_at.year][item.created_at.month] << item
    end
    { :tags => by_tag, :dates => by_date }
  end

  def list_item(href, link, other=nil)
    %Q[<li><a href="#{href}">#{link}</a> #{other}</li>]
  end

  def write_tags_pages(by_tag)
    # write tags
    tag_output = Pathname.new("output/tags")
    tag_output.mkdir unless tag_output.directory?

    tag_content = ["<h1>All Tags</h1>"]
    tag_content << "<ul>"
    tags_start = Time.now

    by_tag.keys.sort_by { |t| t.downcase }.each do |tag|
      tag_start = Time.now
      @posts = by_tag[tag]
      plural = posts.size == 1 ? "post" : "posts"
      @title = "#{@posts.size} #{plural} tagged with  <em>#{tag}</em>"
      @parent_link = %Q{<a href="/tags/">all tags</a>}

      tag_content << list_item("/tags/#{tag}/", tag, "<em>(#{posts.size})</em>")

      tag_page = ["#{posts.size} #{plural} tagged with <em>#{tag}</em> | <a href='/tags/'>all tags</a>"]
      tag_page << "<ul>"
      posts.each do |post|
        tag_page << list_item("/posts/#{post.full_path}/",
                              post.title,
                              " (#{post.display_date})")
      end

      tag_page << "</ul>"
      write_output(tag_output + "#{tag}/index.html",
                   render_home_template { tag_page.join("\n") },
                   tag_start)
    end
    tag_content << "</ul>"
    write_output(tag_output + "index.html",
                 render_home_template { tag_content.join("\n") },
                 tags_start)
  end

  def write_dates_pages(by_date)
    # write year indices
    year_index = ["Posts by year"]
    year_index << "<ul>"
    posts_output = Pathname.new("output/posts")
    years_start = Time.now
    by_date.keys.sort.each do |year|
      count = by_date[year].keys.inject(0) { |m,o|  m += by_date[year][o].size }
      plural = count == 1 ? "post" : "posts"
      posts = "#{count} #{plural}"
      year_index << list_item("/posts/#{year}/", year, "<em>#{posts}</em>")
      content = ["#{count} #{plural} for #{year} | <a href='/posts/'>all posts</a>"]
      year_start = Time.now
      by_date[year].keys.sort.each do |month|
        content << "<h2>#{Date::MONTHNAMES[month]}</h2>"
        content << "<ul>"
        by_date[year][month].each do |post|
          content << list_item("/posts/#{post.full_path}/",
                               post.title,
                               "(#{post.display_date})")
        end
        content << "</ul>"
      end
      write_output(posts_output + "#{year}/index.html",
                   render_home_template { content.join("\n") },
                   year_start)
    end
    year_index << "</ul>"
    write_output(posts_output + "index.html",
                 render_home_template { year_index.join("\n") },
                 years_start)
  end

  def write_output(path, contents, start_time)
    path.parent.mkpath
    path.open("w+") do |f|
      f << contents
    end
    Nanoc3::CLI::Logger.instance.file(:high, :create, path, Time.now - start_time)
  end

  def write(out_path, template)
    out_path = Pathname("output") + out_path unless Pathname === out_path
    start_time = Time.now
    out_path.parent.mkpath

    type = out_path.file? ? :update : :create
    out_path.open("w") do |f|
      f << render_home_template do
        erb = ERB.new(open("templates/" + template).read, nil, nil, "@final_out")
        erb.result(binding)
      end
    end

    Nanoc3::CLI::Logger.instance.file(:high, type, out_path, Time.now - start_time)
  end
end
