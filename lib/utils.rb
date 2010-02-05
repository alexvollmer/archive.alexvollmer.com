require "erb"
require "pathname"
require "nanoc3/cli"

def posts_by_date(items=@items)
  by_date = Hash.new { |h,k| h[k] = Hash.new { |h1,k1| h1[k1] = [] } }

  items.select do |i|
    i.attributes[:kind] == "article"
  end.sort_by { |i| i.created_at }.each do |item|
    by_date[item.created_at.year][item.created_at.month] << item
  end
  by_date
end

def post_years(items=@items)
  items.select do |i|
    i.attributes[:kind] == "article"
  end.map do |i|
    i.created_at.year
  end.uniq
end


def posts_by_month(year, items=@items)
  posts = Hash.new { |h,k| h[k] = [] }
  items.each do |i|
    if i.article? && i.created_at.year == year
      posts[i.created_at.month] << i
    end
  end
  posts
end


def posts_by_date(year, month, items=@items)
  items.select do |i|
    i.article? && i.created_at.year == year && i.created_at.month == month
  end
end
