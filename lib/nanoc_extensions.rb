class Nanoc3::Site
  def articles
    self.items.select { |i| i.article? }.sort_by { |a| a.created_at }.reverse
  end

  def time
    self.articles.sort_by { |a| a.created_at }.last.created_at
  end

  def article_count_for_year(year)
    self.items.select { |i| i.article? && i.created_at.year == year }.size
  end
end

class Nanoc3::Item
  def name
    self.identifier.split("/").last
  end

  def date_str
    if self.created_at
      d = self.created_at
      sprintf("%4d/%02d", d.year, d.month)
    end
  end

  def year
    self.created_at.year
  end

  def month
    self.created_at.month
  end

  def day
    self.created_at.day
  end

  def display_date
    self.created_at.strftime("%A, %d %B %Y")
  end

  def short_date
    self.created_at.strftime("%d %B %Y")
  end

  def full_path
    [self.date_str, sprintf("%02d", self.day), self.permalink.split("/").last].join("/")
  end

  def parent_path
    self.full_path.split("/")[0..-3].join("/")
  end

  def extension
    self[:extension] ||= (File.extname(self[:file].path) rescue nil)
  end

  def article?
    "article" == attributes[:kind]
  end

  def tags
    attributes[:tags] || []
  end

  def content
    self.reps[0].content_at_snapshot(:pre)
  end

  # normally we'd implement respond_to?, but we want missing
  # attributes to just fallback to whatever is in the attributes

  def method_missing(msg, *args, &block)
    attributes[msg.to_sym] || super
  end
end
