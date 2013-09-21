require 'action_view/record_identifier'

module Showcase
  module Traits

    module Record
      extend ActiveSupport::Concern

      def dom_id
        ActionView::RecordIdentifier.dom_id(self)
      end

      def dom_class
        ActiveModel::Naming.param_key(self)
      end

      def box(*args, &block)
        options = args.extract_options!
        options.symbolize_keys!

        tag = args.pop || :div

        options[:class] ||= ""
        css_classes = options[:class].split(/\s+/) << dom_class
        options[:class] = css_classes.join(" ")

        options[:id] = dom_id

        h.content_tag(tag, options) do
          h.capture(self, &block)
        end
      end
    end

  end
end

