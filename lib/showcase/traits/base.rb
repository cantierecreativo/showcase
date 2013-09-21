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
            define_method(method_name, &block)
            true
          end
        end
      end

    end
  end
end

