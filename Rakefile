require "nanoc3/tasks"

task :copy_assets do
  system "rsync -gprt --partial --exclude='.svn' assets/ output"
end

task :compile do
  system "nanoc3 co"
end

task :build => [ :compile, :copy_assets ]

task :default => :build

