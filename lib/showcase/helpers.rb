require 'active_support/concern'
require 'active_support/inflector'

module Showcase
  module Helpers
    extend ActiveSupport::Concern

    def presenter_context
      if respond_to? :view_context
        view_context
      else
        self
      end
    end

    def present(obj, klass = nil, context = presenter_context)
      klass ||= "#{obj.class.name}Presenter".constantize
      klass.new(obj, context)
    end

    def present_collection(obj, klass = nil, context = presenter_context)
      obj.map { |o| present(o, klass, context) }
    end
  end
end

