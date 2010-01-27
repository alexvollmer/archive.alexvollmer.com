require "erb"
require "pathname"
require "pp"
require "lib/utils"

include SiteUtils

namespace :site do

  task :load_site do
    @site = Nanoc3::Site.new('.')
    @site.load_data
  end

  desc "Generate index pages by tag and date"
  task :tags_and_dates => :load_site do
    @site.load_data
    posts = collect_posts_by_tags_and_year(@site)
    write_tags_pages(posts[:tags])
    write_dates_pages(posts[:dates])
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
  task :build => [ :compile, :copy_assets, :tags_and_dates ]
end

