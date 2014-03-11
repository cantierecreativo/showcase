module Showcase
  module Helpers
    class FirstNonBlank
      def self.find(values)
        Array(values).find(&:presence)
      end
    end
  end
end

