require 'spec_helper'

module Showcase::Helpers
  describe ConfigObject do

    let(:context_class) {
      Class.new do
        def foo
          'foo'
        end

        def bar
          'bar'
        end
      end
    }
    let(:context) { context_class.new }

    describe 'to_hash' do
      it 'accepts attr=() notation' do
        result = ConfigObject.new(context) do |c|
          c.first = foo
          c.second = bar
          c.third = '3rd'
        end.to_hash

        hash = { first: 'foo', second: 'bar', third: '3rd' }
        expect(result).to eq hash
      end

      it 'accepts attr() notation' do
        result = ConfigObject.new(context) do |c|
          c.first foo
          c.second bar
          c.third '3rd'
        end.to_hash

        hash = { first: 'foo', second: 'bar', third: '3rd' }
        expect(result).to eq hash
      end
    end

  end
end

