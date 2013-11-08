require 'showcase/helpers/config_object'
require 'showcase/helpers/html_options'

module Showcase
  module Traits

    module LinkTo
      extend ActiveSupport::Concern
      include Base

      module ClassMethods
        def link_to(name = nil, &block)
          define_module_method [name, :url] do
            Helpers::ConfigObject.new(self, &block).to_struct.url
          end

          define_module_method [name, :link_active?] do
            Helpers::ConfigObject.new(self, &block).to_struct.active
          end

          define_module_method [name, :link] do |*args, &link_block|
            config = Helpers::ConfigObject.new(self, &block).to_struct

            html_options = HtmlOptions.new(config.html_options)
            html_options.merge_attrs!(args.extract_options!)
            html_options.add_class!(config.active_class || 'active') if config.active

            args = Array(config.label) if args.empty? && !link_block
            h.link_to *args, config.url, html_options.to_h, &link_block
          end
        end
      end
    end

  end
end

