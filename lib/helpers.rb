module Nanoc3::Helpers::Blogging
  # this is an awful, awful hack because the blogging module assumes
  # that the :created_at attribute is a string and might not already
  # be a valid Time.

  def convert_items(items)
    items.each { |i| i[:created_at] = i[:created_at].to_s }
  end
end
