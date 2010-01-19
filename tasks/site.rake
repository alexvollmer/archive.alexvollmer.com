require "pathname"
require "pp"
require "lib/utils"

include SiteUtils

namespace :site do

  task :tags_and_dates do
    site = Nanoc3::Site.new('.')
    site.load_data

    posts = collect_posts_by_tags_and_year(site)
    write_tags_pages(posts[:tags])
    write_dates_pages(posts[:dates])
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

  task :build => [ :compile, :copy_assets, :tags_and_dates ]
end

