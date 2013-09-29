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
              params = Hash[
                settings[:params].map do |param, meta_key|
                  [ param, meta.send(meta_key) ]
                end
              ]
              c.url "#{settings[:url]}?#{params.to_query}"
              c.label settings[:label]
              c.html_options = { target: :blank }
            end
          end
        end
      end

    end
  end
end

