module Showcase
  module Traits
    module Base
      extend ActiveSupport::Concern

      included do
        extend Helpers::ModuleMethodBuilder
      end
    end
  end
end

