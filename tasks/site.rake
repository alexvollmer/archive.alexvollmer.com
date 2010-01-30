require "erb"
require "ostruct"
require "pathname"
require "pp"
require "lib/utils"

include SiteUtils

namespace :site do

  task :load_site do
    @site = Nanoc3::Site.new('.')
    @site.load_data
    @indexed_posts = collect_posts_by_tags_and_year(@site)
  end

  desc "Generate index pages by tag"
  task :tags => :load_site do
    @site.load_data

    @items = @indexed_posts[:tags].keys.sort_by { |x| x.downcase }.map do |tag|
      OpenStruct.new(:full_path => "/tags/#{tag}/",
                     :title => tag,
                     :size => @indexed_posts[:tags][tag].size)
    end
    @title = "All tags"
    write("tags/index.html", "items.html.erb")

    @indexed_posts[:tags].each do |@tag, @posts|
      plural = @posts.size == 1 ? "post" : "posts"
      @title = "#{@posts.size} #{plural} tagged with  <em>#{@tag}</em>"
      @parent_link = %Q{<a href="/tags/">all tags</a>}
      write("tags/#{@tag}/index.html", "posts.html.erb")
    end
  end

  desc "Generate index pages by year and year/month"
  task :dates => :load_site do
    @items = @indexed_posts[:dates].keys.sort_by { |x| x.to_i }.map do |year|
      OpenStruct.new(:full_path => "/posts/#{year}/",
                     :title => year,
                     :size => @indexed_posts[:dates][year].values.inject(0) { |m,o| m += o.size })
    end
    @title = "All Years"
    @parent_link = %Q[<a href="/posts/">all years</a>]
    write("posts/index.html", "items.html.erb")

    @indexed_posts[:dates].each do |year, by_month|
      @items = by_month.keys.sort_by { |x| x.to_i }.map do |month|
        @title = "Posts for #{Date::MONTHNAMES[month]}, #{year}"
        @parent_link = %Q[<a href="/posts/#{year}/">all posts for #{year}</a>]
        @posts = by_month[month]
        write(sprintf("posts/%04d/%02d/index.html", year, month), "posts.html.erb")

        OpenStruct.new(:full_path => sprintf("/posts/%04d/%02d/", year, month),
                       :title => Date::MONTHNAMES[month],
                       :size => by_month[month].size)
      end
      @title = "Posts for #{year}"
      @parent_link = %Q[<a href="/posts/">posts for all years</a>]
      write("posts/#{year}/index.html", "items.html.erb")
    end
  end

  desc "Generate Atom and RSS feeds"
  task :create_feeds => [:load_site, :compile] do
    outdir = Pathname("output/feeds")
    outdir.mkpath unless outdir.directory?
    Dir["feeds/*.erb"].each do |file|
      template = open(file).read
      site = @site
      articles = site.articles
      file_name = outdir + file.split("/").last.sub(".erb", "")
      open(file_name, "w") { |f| f << ERB.new(template).result(binding) }
      puts "Wrote #{file_name}"
    end
  end

  task :copy_assets do
    system "rsync -gprt --partial assets/ output"
  end

  task :compile do
    system "nanoc3 co"
  end

  task :clean do
    rm_rf "output"
  end

  desc "Build the whole damn site"
  task :build => [ :compile, :copy_assets, :tags, :dates ]
end

