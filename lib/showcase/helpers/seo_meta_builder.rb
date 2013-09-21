module Showcase
  module Helpers
    class SeoMetaBuilder
      attr_reader :context

      def initialize(context)
        @context = context
      end

      def title(values, options = {})
        title = first_nonblank(values)
        title += options[:title_suffix] if options[:title_suffix]

        context.content_tag(:title, title) <<
        seo_meta_tags(:og_title, :twitter_title, values)
      end

      def description(values, options = {})
        seo_meta_tags(:description, :og_description, :twitter_description, values)
      end

      def image_url(image_url, options = {})
        seo_meta_tags(:og_image, :twitter_image, image_url)
      end

      def canonical_url(url, options = {})
        seo_meta_tags(:og_url, url) <<
        context.tag(:link, rel: "canonical", "href" => url)
      end

      private

      def first_nonblank(values)
        Array(values).map(&:presence).compact.first
      end

      def seo_meta_tags(*args)
        value = first_nonblank(args.pop)

        return nil unless value.present?

        args.map do |name|
          name = name.to_s.sub(/_/, ":")
          context.tag(:meta, name: name, content: value)
        end.join.html_safe
      end
    end
  end
end

