module Liquid

  module ExtendedFilters

    def preview(text, delimiter = '<!--more-->')
      if text.index(delimiter) != nil
        text.split(delimiter)[0]
      else
        text
      end
    end

  end

  Liquid::Template.register_filter(ExtendedFilters)

end
