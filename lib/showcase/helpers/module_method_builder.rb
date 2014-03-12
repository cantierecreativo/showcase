require 'active_support/core_ext/object/blank'

module Showcase
  module Helpers
    module ModuleMethodBuilder
      def define_module_method(name_chunks, &block)
        method_name = Array(name_chunks).map(&:to_s).map(&:presence).compact.join("_")
        if method_defined?(method_name)
          false
        else
          method_module = Module.new do
            define_method(method_name, &block)
          end
          include(method_module)
          true
        end
      end
    end
  end
end

