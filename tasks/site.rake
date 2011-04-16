require "erb"
require "nanoc3"
require "ostruct"
require "pathname"
require "pp"
require "lib/utils"

namespace :site do

  task :load_site do
    @site = Nanoc3::Site.new('.')
    @site.load_data
    @indexed_posts = collect_posts_by_tags_and_year(@site)
  end

  task :compile do
    system "nanoc3 co"
  end

  task :clean do
    rm_rf "output"
  end

  desc "Build the whole damn site"
  task :build => :compile
end

