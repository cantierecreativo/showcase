require 'delegate'
require 'showcase/helpers'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/keys'

module Showcase
  class Presenter < SimpleDelegator
    include Helpers

    attr_reader :view_context

    alias_method :object, :__getobj__
    alias_method :h, :view_context

    def initialize(obj, context)
      super(obj)
      @view_context = context
    end

    def class
      object.class
    end

    def kind_of?(klass)
      object.kind_of?(klass)
    end
    alias_method :is_a?, :kind_of?

    def instance_of?(klass)
      object.instance_of?(klass)
    end

    def self.presents(*args)
      options = args.extract_options!
      options.assert_valid_keys(:with)
      presenter_klass = options.fetch(:with, nil)

      args.each do |attr|
        define_method attr do
          present(object.send(attr), presenter_klass, view_context)
        end
      end
    end

    def self.presents_collection(*args)
      options = args.extract_options!
      options.assert_valid_keys(:with)
      presenter_klass = options.fetch(:with, nil)

      args.each do |attr|
        define_method attr do
          present_collection(object.send(attr), presenter_klass, view_context)
        end
      end
    end
  end
end

