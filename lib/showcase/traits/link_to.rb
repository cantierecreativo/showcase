require 'showcase/helpers/config_object'

module Showcase
  module Traits

    module LinkTo
      extend ActiveSupport::Concern
      include Base

      module ClassMethods
        def link_to(name = nil, &block)

          define_method? [name, :url] do
            Helpers::ConfigObject.new(self, &block).to_struct.url
          end

          define_method? [name, :link_active?] do
            Helpers::ConfigObject.new(self, &block).to_struct.active
          end

          define_method? [name, :link] do |*args, &link_block|
            config = Helpers::ConfigObject.new(self, &block).to_struct
            options = args.extract_options!.symbolize_keys
            options.reverse_merge!(config.html_options) if config.html_options

            if config.active
              options[:class] ||= ""
              css_classes = options[:class].split(/\s+/)
              css_classes << "active"
              options[:class] = css_classes.join(" ")
            end

            args = Array(config.label) if args.empty? && !link_block
            h.link_to *args, config.url, options, &link_block
          end

        end
      end
    end

  end
end

