#!/usr/bin/env ruby

require "base64"
require "digest/sha1"
require "fileutils"
require "logger"
require "pathname"
require "time"
require "rexml/source"
require "xmlrpc/marshal"
require "xmlrpc/server"

require "rubygems"
require "haml"
require "nanoc3"
require "sinatra"

include FileUtils

LOCAL_SERVER_NAME = "alexvollmer.local"
ROOT_DIR = Pathname.new(File.dirname(__FILE__)).realpath

ALL_POSTS = Hash.new do |hash, sha1|
  begin
    post = BLOG_SITE.article_by_sha1(sha1)
    rep = post.rep_named(:default)
    BLOG_SITE.compiler.run(post, :force => true)
    content = rep.compiled_content
    hash[sha1] = content
  rescue => e
    LOGGER.error("Error compiling '#{post.identifier}': #{e.message}")
    raise e
  end
end

class Nanoc3::Site
  attr_accessor :rules_file

  def article_by_sha1(sha1)
    self.items.find {|x| x.article? && x[:sha1] == sha1}
  end

  def load_rules(rules_file=nil)
    # Get rule data
    @rules       = File.read(@rules_file)
    @rules_mtime = File.stat(@rules_file).mtime

    # Load DSL
    dsl.instance_eval(@rules, "./#{@rules_file}")
  end
end

class Nanoc3::Item
  def wordpress_post_status
    case self.identifier
    when /^\/posts\//
      "publish"
    when /^\/drafts\//
      "draft"
    end
  end

  def xmlrpc_hash
    {
      :dateCreated       => self.created_at,
      :userid            => "1",
      :postid            => self[:sha1],
      :description       => ALL_POSTS[self[:sha1]],
      :title             => self.title,
      :link              => "http://#{LOCAL_SERVER_NAME}#{self.path}",
      :permaLink         => "http://#{LOCAL_SERVER_NAME}#{self.path}",
      :categories        => ["Uncategorized"],
      :mt_excerpt        => "",
      :mt_text_more      => "",
      :mt_allow_comments => 1,
      :mt_allow_pings    => 0,
      :mt_keywords       => Array(self.tags).join(', '),
      :wp_slug           => self.permalink,
      :wp_password       => "",
      :wp_author_id      => "alexvollmer",
      :wp_author_display => "Alex Vollmer",
      :date_created_gmt  => self.created_at,
      :post_status       => self.wordpress_post_status,
      :custom_fields     => [],
      :wp_post_format    => "standard"
    }
  end
end

class Hash
  def symbolize_keys
    self.inject({}) {|h,kv| h[kv[0].to_sym] = kv[1]; h}
  end
end

class Nanoc3Server < XMLRPC::BasicServer
  attr_accessor :site

  def initialize(site)
    super

    self.site = site

    add_handler("wp.getCategories") do |blog_id, username, password|
      [
        {
          :categoryId  => 1,
          :parentId    => 0,
          :description => "Uncategorized",
          :htmlUrl     => "http://#{LOCAL_SERVER_NAME}/category/uncategorized/",
          :rssUrl      => "http://#{LOCAL_SERVER_NAME}/category/uncategorized/feed/"
        }
      ]
    end

    add_handler("blogger.deletePost") do |app_key, post_id, username, password, publish|
      delete_post(post_id)
      1
    end

    add_handler("mt.supportedTextFilters") do
      []
    end

    add_handler("metaWeblog.editPost") do |post_id, username, password, struct, publish|
      edit_post(post_id, struct.symbolize_keys, publish)
      1
    end

    add_handler("metaWeblog.getPost") do |post_id, username, password|
      BLOG_SITE.articles(true).find {|x| x[:sha1] == post_id}.xmlrpc_hash
    end

    add_handler("metaWeblog.getRecentPosts") do |blog_id, username, password, max|
      BLOG_SITE.articles(true)[0..max].map {|i| i.xmlrpc_hash}
    end

    add_handler("metaWeblog.newMediaObject") do |blog_id, username, password, struct|
      new_media_object(struct["name"], struct["type"], struct["bits"])
    end

    add_handler("metaWeblog.newPost") do |blog_id, username, password, struct, publish|
      add_post(struct.symbolize_keys, publish)
    end

    add_handler("mt.getPostCategories") do
      []
    end

    add_handler("wp.getPages") do |blog_id, username, password, max|
      []
    end

    add_handler("wp.getTags") do |blog_id, username, password|
      count_tags(BLOG_SITE.articles(true)).map do |tag, count|
        {
          :tag_id   => tag,
          :name     => tag,
          :count    => count,
          :slug     => tag,
          :html_url => "http://alexvollmer.com/tags/#{tag}/"
          #:rss_url?
        }
      end
    end
  end

  def compile_and_sync
    system("touch content/index.haml")
    system("rake clean deploy[true]")
  end

  def add_post(new_post, publish)
    LOGGER.debug("new post: #{new_post.inspect} publish? #{publish}")
    title = new_post[:title]
    body = new_post[:description];
    sha1 = new_post[:sha1] || Digest::SHA1.hexdigest(body)
    created_at = Time.now
    permalink = title.gsub(" ", "-").downcase.gsub(".", "")
    identifier = sprintf("/#{publish ? "posts" : "drafts"}/%04d/%02d/%02d/%s/",
                         created_at.year,
                         created_at.month,
                         created_at.day,
                         permalink)
    attrs = {
      :kind       => "article",
      :permalink  => permalink,
      :title      => title,
      :created_at => created_at,
      :tags       => Array(new_post[:mt_keywords].split(",")),
      :sha1       => sha1
    }

    site.data_sources.first.create_item(body, attrs, identifier)
    site.load_data(true)
    item = site.article_by_sha1(sha1)
    site.compiler.run(item)

    compile_and_sync
    system(%[git add '#{ROOT_DIR + "content"}' '#{ROOT_DIR + "public"}'])
    system(%[git commit -m "Added post '#{title}'"])

    sha1
  end

  def edit_post(post_id, struct, publish)
    original_item = site.article_by_sha1(post_id)
    # TODO: handle title changes
    title = struct[:title]
    body = struct[:description];
    created_at = Time.now
    attrs = original_item.attributes.merge({
      :title      => title,
      :created_at => created_at,
      :tags       => Array(struct[:mt_keywords].split(",")),
    })
    attrs.delete(:file)  # avoid a warning from nanoc3

    path = original_item.filename

    LOGGER.debug("publish? #{publish} status: #{original_item.wordpress_post_status}")
    if (publish && original_item.wordpress_post_status == "draft") ||
       (!publish && original_item.wordpress_post_status == "publish")
      file_path = (ROOT_DIR + original_item.filename)
      rm(file_path)
      system(%[git rm -f #{file_path}])
      struct[:sha1] = attrs[:sha1]
      add_post(struct, publish)
      site.load_data(true)
    else
      File.open(path, 'w') do |io|
        io.write(YAML.dump(attrs).strip + "\n")
        io.write("---\n\n")
        io.write(body)
      end

      compile_and_sync
      system(%[git add '#{ROOT_DIR + "content"}' '#{ROOT_DIR + "public"}'])
      system(%[git commit -m "Updated post '#{title}'"])
    end

    BLOG_SITE.load_data(true)
    ALL_POSTS.delete(post_id)
  end

  def delete_post(post_id)
    item = site.article_by_sha1(post_id)
    ALL_POSTS.delete(post_id)
    site.items.delete(item)
    filename = item.filename
    path = (ROOT_DIR + filename.sub(/^\//, "")).realpath
    rm_f(path)

    compile_and_sync
    system(%[git rm -f '#{path}'])
    system(%[git commit -m "Removed post '#{item[:title]}'"])
  end

  def new_media_object(name, file_type, bits)
    now = Date.today
    path = now.strftime("public/images/%Y/%m/#{name}").gsub("//", "/")
    url = path.sub(/^public/, '')
    final_path = ROOT_DIR + path
    mkdir_p(final_path.parent) unless final_path.parent.directory?
    open(final_path, "w") {|f| f.write(bits) }

    # need to sync our public directory to the output directory where we serve
    # static content from
    system "rsync -gprt --partial public/ output"

    {
      :file => final_path.to_s,
      :url  => url,
      :type => file_type
    }
  end
end

configure do
  LOGGER = Logger.new(STDOUT)

  BLOG_SITE = Nanoc3::Site.new('.')
  BLOG_SITE.rules_file = "server-Rules"
  BLOG_SITE.load_data

  set :static
  # set :public, File.join(File.dirname(__FILE__), "output")
  set :views, File.join(File.dirname(__FILE__), "server", "views")

  SERVER = Nanoc3Server.new(BLOG_SITE)
end

helpers do
  def logger
    LOGGER
  end
end

get "/" do
  html = File.read(File.join(settings.public, "index.html"))
  # TODO: figure out our listener port dynamically
  html.sub("</head>", 
           %Q[<link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://#{LOCAL_SERVER_NAME}/xmlrpc.php?rsd" />
<link rel="pingback" href="http://#{LOCAL_SERVER_NAME}/xmlrpc.php" /></head>]).gsub('alexvollmer.com', LOCAL_SERVER_NAME)
end

get "/xmlrpc.php" do
  haml :rsd
end

post "/xmlrpc.php" do
  response["Content-Type"] = "text/xml"
  SERVER.process(request.body.read())
end

