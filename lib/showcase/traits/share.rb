require 'showcase/helpers/config_object'
require 'active_support/core_ext/object/to_query'

module Showcase
  module Traits
    module Share
      extend ActiveSupport::Concern
      include LinkTo

      PROVIDERS = {
        twitter: {
          url: "https://twitter.com/intent/tweet",
          params: { url: :url, text: :text },
          label: 'Tweet it!'
        },
        gplus: {
          url: "https://plus.google.com/share",
          params: { url: :url },
          label: 'Share it on Google Plus!'
        },
        facebook: {
          url: "http://www.facebook.com/sharer/sharer.php",
          params: { u: :url },
          label: 'Share it on Facebook!'
        },
        linkedin: {
          url: "http://www.linkedin.com/shareArticle",
          params: { url: :url, title: :text },
          label: 'Share it on LinkedIn!'
        },
        pinterest: {
          url: "http://www.pinterest.com/pin/create/button/",
          params: { url: :url, media: :image_url, title: :text },
          label: 'Pin it!'
        }
      }

      module ClassMethods
        def share(name = nil, &block)
          PROVIDERS.each do |social, settings|
            link_name = [ name, social, "share" ].map(&:presence).compact.join("_")

            link_to link_name do |c|
              meta = Helpers::ConfigObject.new(self, &block).to_struct
              html_options = meta.html_options || {}
              params = Hash[
                settings[:params].map do |param, meta_key|
                  values = [:"#{social}_#{meta_key}", meta_key].map { |key| meta[key] }
                  [ param, values.find(&:presence) ]
                end
              ]

              c.url "#{settings[:url]}?#{params.to_query}"
              c.label settings[:label]
              c.html_options = html_options.reverse_merge(target: '_blank')
            end
          end
        end
      end

    end
  end
end

