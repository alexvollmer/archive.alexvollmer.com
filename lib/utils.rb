module SiteUtils

  def collect_posts_by_tags_and_year(site)
    by_tag = Hash.new { |h,k| h[k] = [] }
    by_date = Hash.new { |h,k| h[k] = Hash.new { |h1,k1| h1[k1] = [] } }

    # index all the posts
    site.items.select do |i|
      i.identifier =~ /^\/posts\//
    end.sort_by { |i| i.date }.each do |item|
      item.tags.each { |tag| by_tag[tag] << item }
      by_date[item.date.year][item.date.month] << item
    end
    { :tags => by_tag, :dates => by_date }
  end

  def list_item(href, link, other=nil)
    %Q[<li><a href="#{href}">#{link}</a> #{other}</li>]
  end

  def write_tags_pages(by_tag)
    # write tags
    tag_output = Pathname.new("output/tags")
    if tag_output.directory?
      rm_rf tag_output
      mkdir_p tag_output
    end

    tag_content = ["<h1>All Tags</h1>"]
    tag_content << "<ul>"
    by_tag.keys.sort_by { |t| t.downcase }.each do |tag|
      posts = by_tag[tag]
      tag_content << list_item("/tags/#{tag}/", tag, "<em>(#{posts.size})</em>")

      plural = posts.size == 1 ? "post" : "posts"
      tag_page = ["#{posts.size} #{plural} tagged with <em>#{tag}</em> | <a href='/tags/'>all tags</a>"]
      tag_page << "<ul>"
      posts.each do |post|
        tag_page << list_item("/posts/#{post.full_path}/",
                              post.title,
                              " (#{post.display_date})")
      end
      tag_page << "</ul>"
      write_output(tag_output + "#{tag}/index.html", tag_page.join("\n"))
    end
    tag_content << "</ul>"
    write_output(tag_output + "index.html", tag_content.join("\n"))
  end

  def write_dates_pages(by_date)
    # write year indices
    year_index = ["Posts by year"]
    year_index << "<ul>"
    posts_output = Pathname.new("output/posts")
    by_date.keys.sort.each do |year|
      count = by_date[year].keys.inject(0) { |m,o|  m += by_date[year][o].size }
      plural = count == 1 ? "post" : "posts"
      posts = "#{count} #{plural}"
      year_index << list_item("/posts/#{year}/", year, "<em>#{posts}</em>")
      content = ["#{count} #{plural} for #{year} | <a href='/posts/'>all posts</a>"]
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
      write_output(posts_output + "#{year}/index.html", content.join("\n"))
    end
    year_index << "</ul>"
    write_output(posts_output + "index.html", year_index.join("\n"))
  end

  def write_output(path, contents)
    path.parent.mkpath
    path.open("w+") do |f|
      f << contents
    end
  end

end
