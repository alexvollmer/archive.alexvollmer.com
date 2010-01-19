
class Nanoc3::Item
  def name
    identifier.split("/").last
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

  def full_path
    [self.date_str, sprintf("%02d", self.day), self.permalink].join("/")
  end

  # normally we'd implement respond_to?, but we want missing
  # attributes to just fallback to whatever is in the attributes

  def method_missing(msg, *args, &block)
    attributes[msg.to_sym] || super
  end
end
