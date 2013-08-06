module Pluct
  class LinkDescriptionObject
    def initialize(raw_link)
      @href = raw_link["href"]
    end

    def expand_href(mapping)
      template.expand(mapping).to_s
    end

    def unused_mapping(orig_mapping)
      mapping = orig_mapping.dup
      expanded_href = self.expand_href(mapping)
      used_mapping = template.extract(expanded_href)
      mapping.delete_if { |key, value| used_mapping.include?(key.to_s) }
    end

  private

    def template
      @template ||= Addressable::Template.new(@href)
    end
  end
end
