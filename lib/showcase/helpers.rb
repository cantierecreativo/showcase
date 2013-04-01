require 'active_support/concern'
require 'active_support/inflector'

module Showcase
  module Helpers
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :present
        helper_method :present_collection
      end
      if respond_to?(:hide_action)
        hide_action :presenter_context
      end
    end

    def presenter_context
      if respond_to? :view_context
        view_context
      else
        self
      end
    end

    def present(obj, klass = nil, context = presenter_context)
      if obj.is_a? ::Showcase::Presenter
        obj
      else
        klass ||= "#{obj.class.name}Presenter".constantize
        klass.new(obj, context)
      end
    end

    def present_collection(obj, klass = nil, context = presenter_context)
      obj.map { |o| present(o, klass, context) }
    end
  end
end

