module Showcase
  module Traits

    module Record
      extend ActiveSupport::Concern

      module ClassMethods
        def box(&block)
          @box_config_block = block
        end

        def __box_config_block__
          @box_config_block
        end
      end

      def dom_id
        record_identifier.dom_id(self)
      end

      def dom_class
        record_identifier.dom_class(self)
      end

      def box(*args, &block)
        options = args.extract_options!
        tag = args.pop || :div

        config_block = self.__decorator_class__.__box_config_block__
        config_options = if config_block
                           Helpers::ConfigObject.new(self, &config_block).to_struct.html_options
                         else
                           {}
                         end

        html_options = HtmlOptions.new(config_options)
        html_options.merge_attrs!(options)
        html_options.add_class!(dom_class)
        html_options.merge_attrs!(id: dom_id)

        h.content_tag(tag, html_options.to_h) do
          h.capture(self, &block)
        end
      end

      private

      def record_identifier
        if defined?(ActionView::RecordIdentifier)
          ActionView::RecordIdentifier
        elsif defined?(ActionController::RecordIdentifier)
          ActionController::RecordIdentifier
        else
          raise 'No RecordIdentifier found!'
        end
      end
    end

  end
end

