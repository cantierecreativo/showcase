module Showcase
  module Helpers
    class HtmlOptions
      def initialize(options = {})
        @options = (options || {}).symbolize_keys
      end

      def add_class!(css_class)
        @options[:class] ||= ""
        css_classes = @options[:class].split(/\s+/)
        css_classes << css_class
        @options[:class] = css_classes.join(" ")
      end

      def merge_attrs!(options = {})
        options = (options || {}).symbolize_keys
        @options.merge!(options)
      end

      def to_h
        @options.dup
      end
    end
  end
end

