module Showcase
  module Helpers
    class HtmlClassAttribute
      def initialize(value = nil)
        @css_classes = value.to_s.strip.split(/\s+/)
      end

      def <<(value)
        value = value.to_s.strip.split(/\s+/)
        @css_classes += value
      end

      def to_html_attribute
        if @css_classes.any?
          @css_classes.uniq.join(' ')
        else
          nil
        end
      end
    end
  end
end

