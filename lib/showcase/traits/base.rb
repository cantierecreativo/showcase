module Showcase
  module Traits
    module Base
      extend ActiveSupport::Concern

      module ClassMethods
        private

        def define_method?(name_chunks, &block)
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
end

