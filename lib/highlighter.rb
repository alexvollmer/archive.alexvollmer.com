module Nanoc3::Helpers::Filtering

  def highlight(syntax, &block)
    # Seamlessly ripped off from the filter method...
    # Capture block
    data = capture(&block)
    # Reconvert
    data.gsub! /<%/, ''
    # Filter captured data
    filtered_data = "\n" + Albino.colorize(data, syntax) +
      "\n" rescue data
    # Append filtered data to buffer
    buffer = eval('_erbout', block.binding)
    buffer << filtered_data
  end

end

include Nanoc3::Helpers::Filtering

