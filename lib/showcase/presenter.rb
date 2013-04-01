require 'delegate'
require 'showcase/helpers'

module Showcase
  class Presenter < SimpleDelegator
    include Helpers

    attr_reader :view_context

    alias_method :object, :__getobj__
    alias_method :h, :view_context

    def class
      object.class
    end

    def initialize(obj, context)
      super(obj)
      @view_context = context
    end

    def self.presents(*attrs)
      attrs.each do |attr|
        define_method attr do
          present(object.send(attr), nil, view_context)
        end
      end
    end

    def self.presents_collection(*attrs)
      attrs.each do |attr|
        define_method attr do
          present_collection(object.send(attr), nil, view_context)
        end
      end
    end
  end
end

