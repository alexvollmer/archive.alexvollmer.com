#!/usr/bin/env ruby

require "rubygems"
require "httparty"

class Disqus
  include HTTParty

  base_uri "disqus.com/api/"
  format :json

  attr_accessor :api_key, :forum_id

  def initialize(api_key)
    @api_key = api_key
  end

  def forum_list
    @forum_list ||= self.class.get("/get_forum_list", :query => {
                                     :user_api_key => @api_key
                                   })["message"]
  end

  def forum_api_key(forum_id)
    if forum_id != self.forum_id || !@forum_api_key
      @forum_api_key = self.class.get("/get_forum_api_key", :query => {
                                          :user_api_key => @api_key,
                                          :forum_id => forum_id
                                        })["message"]
      self.forum_id = forum_id
    end
    @forum_api_key
  end

  def forum_posts(forum_id=self.forum_id)
    self.class.get("/get_forum_posts", :query => {
                     :forum_id => forum_id,
                     :forum_api_key => self.forum_api_key(forum_id)
                   })["message"]
  end

  def thread_list(forum_id=self.forum_id, limit=25)
    self.class.get("/get_thread_list", :query => {
                     :forum_id => forum_id,
                     :forum_api_key => self.forum_api_key(forum_id),
                     :limit => limit
                   })["message"]
  end

  def thread_by_url(url, forum_id=self.forum_id)
    self.class.get("/get_thread_by_url", :query => {
                     :forum_api_key => self.forum_api_key(forum_id),
                     :url => url
                   })["message"]
  end

  def post_count_for_threads(forum_id=self.forum_id, *thread_ids)
    self.class.get("/get_num_posts", :query => {
                     :thread_ids => thread_ids.join(','),
                     :forum_api_key => self.forum_api_key(forum_id),
                   })["message"]
  end

  def get_thread_posts(thread_id, forum_id=self.forum_id)
    self.class.get("/get_thread_posts", :query => {
                     :forum_api_key => self.forum_api_key(forum_id),
                     :thread_id => thread_id
                   })
  end

  def update_thread(thread_id, forum_id=self.forum_id, opts={})
    body = opts.merge({
                        :forum_api_key => self.forum_api_key(forum_id),
                        :thread_id => thread_id
                      })
    self.class.post("/update_thread/", :body => body)["message"]
  end

  def thread_by_identifier(identifier, title, forum_id=self.forum_id)
    self.class.post("/thread_by_identifier/", :query => {
                      :identifier => identifier,
                      :title => title,
                      :forum_api_key => self.forum_api_key(forum_id)
                    })["message"]
  end


  def reset!
    @forum_list = @threads = @forum_api_key = nil
  end
end
