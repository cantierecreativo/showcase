require 'ostruct'

module Showcase
  module Helpers
    class ConfigObject
      def initialize(context, &block)
        @config_block = block
        @context = context
      end

      def to_struct
        OpenStruct.new(to_hash)
      end

      def to_hash
        @result = {}
        @context.instance_exec(self, &@config_block)
        @result.symbolize_keys
      end

      def method_missing(name, *args, &block)
        name = name.to_s.gsub(/=$/, '')
        @result[name.to_sym] = args.first
      end
    end
  end
end

