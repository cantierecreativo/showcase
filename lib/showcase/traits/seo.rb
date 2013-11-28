require 'showcase/helpers/config_object'
require 'showcase/helpers/seo_meta_builder'

module Showcase
  module Traits
    module Seo
      extend ActiveSupport::Concern
      include Base

      module ClassMethods

        def default_seo_options(&block)
          define_module_method :default_seo_options do
            Helpers::ConfigObject.new(self, &block).to_hash
          end
        end

        def seo(name = nil, options = {}, &block)
          define_module_method [name, :seo_tags] do |options = {}|
            meta = respond_to?(:default_seo_options) ? default_seo_options : {}
            meta.merge!(Helpers::ConfigObject.new(self, &block).to_hash)
            meta.merge!(options.symbolize_keys) if options

            builder = Helpers::SeoMetaBuilder.new(view_context)
            parts = %w(
              title description site_name
              canonical_url
              image_url iframe_video_url stream_video_url
            ).map(&:to_sym)

            parts.map do |tag|
              builder.send(tag, meta[tag], meta.except(*parts)) if meta[tag]
            end.compact.join.html_safe
          end
        end

      end
    end
  end
end

