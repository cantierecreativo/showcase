require 'delegate'
require 'showcase/helpers/present'
require 'showcase/helpers/module_method_builder'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/keys'

module Showcase
  class Presenter < SimpleDelegator
    include Helpers::Present
    extend Helpers::ModuleMethodBuilder

    attr_reader :view_context

    alias_method :object, :__getobj__
    alias_method :h, :view_context
    alias_method :try, :__send__
    alias_method :__decorator_class__, :class

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
      wrap_methods(args, :present)
    end

    def self.presents_collection(*args)
      wrap_methods(args, :present_collection)
    end

    private

    def self.wrap_methods(args, method)
      options = args.extract_options!
      options.assert_valid_keys(:with, :nil_presenter)
      presenter_klass = options.fetch(:with, nil)

      args.each do |attr|
        define_module_method attr do
          send(method,
               object.send(attr),
               presenter_klass,
               view_context,
               options.slice(:nil_presenter))
        end
      end
    end
  end
end

