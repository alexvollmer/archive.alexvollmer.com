# Stolen from h3rald's setup: git://github.com/h3rald/h3rald.git

require 'bluecloth'

module Nanoc3::Helpers::Tagging

  def site_tags
    ts = {}
    @items.each do |p|
      next unless p[:tags]
      p[:tags].each do |t|
        if ts[t]
          ts[t] = ts[t]+1
        else
          ts[t] = 1
        end
      end
    end
    ts
  end

  def tags_for(article)
    article.attributes[:tags].map{|t| %{<a class="tag" href="/tags/#{t}/">#{t}</a>}}.join " &middot; "
  end

  def link_for_tag(tag, base_url)
    %[<a href="#{base_url}#{tag}/" rel="tag">#{tag}</a>]
  end

  def tag_link_with_count(tag, count)
    %{#{link_for_tag(tag, '/tags/')} (#{count})}
  end

  def sorted_site_tags
    site_tags.sort{|a, b| a[1] <=> b[1]}.reverse
  end

  def articles_tagged_with(tag)
    @site.items.select do
      |p| p.attributes[:tags] && p.attributes[:tags].include?(tag)
    end.sort_by { |x| x.attributes[:date] }.reverse
  end

  def articles_dated_with(date_str)
    @site.items.select do |p|
      p.date_str == date_str
    end.sort_by { |x| x.date_str }.reverse
  end

end

module Nanoc3::Helpers::Blogging
  # this is an awful, awful hack because the blogging module assumes
  # that the :created_at attribute is a string and might not already
  # be a valid Time.

  def convert_items(items)
    items.each { |i| i[:created_at] = i[:created_at].to_s }
  end
end
