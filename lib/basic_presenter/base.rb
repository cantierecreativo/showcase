require 'delegate'
require 'active_support/inflector'
require 'basic_presenter/helpers'

module BasicPresenter
  class Base < SimpleDelegator
    include Helpers

    attr_reader :context

    alias :object :__getobj__
    alias :h :context

    def class
      object.class
    end

    def initialize(obj, context)
      super(obj)
      @context = context
    end

    def self.presents(*attrs)
      attrs.each do |attr|
        define_method attr do
          present(object.send(attr), nil, context)
        end
      end
    end

    def self.presents_collection(*attrs)
      attrs.each do |attr|
        define_method attr do
          present_collection(object.send(attr), nil, context)
        end
      end
    end
  end
end
