require 'showcase/helpers/html_class_attribute'

module Showcase
  module Helpers
    class HtmlOptions
      def initialize(options = {})
        @options = (options || {}).symbolize_keys
      end

      def add_class!(css_class)
        merge_attrs!(class: css_class)
      end

      def merge_attrs!(options = {})
        new_options = (options || {}).symbolize_keys

        if new_options[:class]
          class_attr = HtmlClassAttribute.new(@options[:class])
          class_attr << new_options[:class]
          new_options[:class] = class_attr.to_html_attribute
        end

        @options.merge!(new_options)
      end

      def to_h
        @options.dup
      end
    end
  end
end

