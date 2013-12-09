require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/hash/keys'

module Showcase
  module Helpers
    module Present
      extend ActiveSupport::Concern

      def presenter_context
        if respond_to? :view_context
          view_context
        else
          self
        end
      end

      def present(obj, klass = nil, context = presenter_context, options = {})
        options.assert_valid_keys(:nil_presenter)

        if obj || options.fetch(:nil_presenter, false)
          klass ||= presenter_class(obj)
          klass.new(obj, context)
        else
          nil
        end
      end

      def present_collection(obj, klass = nil, context = presenter_context, options = {})
        obj.map { |o| present(o, klass, context, options) }
      end

      private

      def presenter_class(obj)
        obj.class.ancestors.each do |k|
          klass = "#{k.name}Presenter".safe_constantize
          return klass if klass
        end
      end
    end
  end
end
