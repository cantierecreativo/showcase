require 'showcase/helpers/first_nonblank'

module Showcase
  module Helpers
    class SeoMetaBuilder
      attr_reader :context

      def initialize(context)
        @context = context
      end

      def title(values, options = {})
        title = Helpers::FirstNonBlank.find(values)
        title += options[:title_suffix] if options[:title_suffix]

        context.content_tag(:title, title) <<
        seo_meta_tags('og:title', 'twitter:title', values)
      end

      def description(values, options = {})
        seo_meta_tags('description', 'og:description', 'twitter:description', values)
      end

      def image_url(image_url, options = {})
        seo_meta_tags('og:image', 'twitter:image', image_url)
      end

      def iframe_video_url(video_url, options = {})
        seo_meta_tags('og:video:url', video_url) <<
        seo_meta_tags('og:video:type', 'text/html') <<
        seo_meta_tags('twitter:player', video_url)
      end

      def stream_video_url(video_url, options = {})
        seo_meta_tags('og:video:url', video_url) <<
        seo_meta_tags('og:video:type', 'video/mp4') <<
        seo_meta_tags('twitter:player:stream', video_url)
      end

      def card_type(type, options = {})
        seo_meta_tags('twitter:card', type)
      end

      def video_size(size, options = {})
        seo_meta_tags('twitter:player:width', size.first) <<
        seo_meta_tags('twitter:player:height', size.last) <<
        seo_meta_tags('og:video:width', size.first) <<
        seo_meta_tags('og:video:height', size.last)
      end

      def site_name(name, options = {})
        seo_meta_tags('og:site_name', name)
      end

      def canonical_url(url, options = {})
        seo_meta_tags('og:url', 'twitter:url', url) <<
        context.tag(:link, rel: "canonical", "href" => url)
      end

      private

      def seo_meta_tags(*args)
        value = Helpers::FirstNonBlank.find(args.pop)

        return nil unless value.present?

        args.map do |name|
          chunks = name.to_s.split(":")
          attr_name = if chunks.first == 'og'
            'property'
          else
            'name'
          end
          name = chunks.join(':')
          context.tag(:meta, attr_name => name, content: value)
        end.join.html_safe
      end
    end
  end
end

