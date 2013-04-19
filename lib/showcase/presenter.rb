require 'delegate'
require 'showcase/helpers'

module Showcase
  class Presenter < BasicObject
    attr_reader :view_context
    attr_reader :object
    alias_method :h, :view_context

    include Helpers

    def initialize(object, context)
      @object = object
      @view_context = context
    end

    def respond_to?(name)
      if [:view_context, :h, :object].include? name
        true
      else
        object.respond_to?(name)
      end
    end

    def method_missing(name, *args, &block)
      object.__send__(name, *args, &block)
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

