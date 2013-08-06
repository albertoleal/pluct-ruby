module Pluct
  class LinkDescriptionObject
    def initialize(raw_link)
      @href = raw_link["href"]
    end

    def expand_href(mapping)
      template = Addressable::Template.new(@href)
      Addressable::URI.parse(template.expand(mapping)).to_s
    end
  end
end
