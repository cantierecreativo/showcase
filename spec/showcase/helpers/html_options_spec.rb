require 'spec_helper'

module Showcase
  module Helpers
    describe HtmlOptions do
      let(:options) { HtmlOptions.new(attributes) }
      let(:attributes) { {} }

      it 'takes a hash of attributes' do
        expect(options.to_h).to eq attributes
      end

      describe '#merge_attrs!' do
        let(:attributes) { { 'id' => 'bar', 'data-alert' => 'true' } }

        it 'merges attributes with the passed ones' do
          options.merge_attrs!('data-method' => 'post', 'id' => 'foo')
          expect(options.to_h).to eq({
            :'data-alert' => 'true',
            :'data-method' => 'post',
            :'id' => 'foo'
          })
        end

        context 'css classes' do
          let(:attributes) { { 'class' => 'foo bar' } }

          it 'merges them appropriately' do
            options.merge_attrs!('class' => 'foo qux')
            expect(options.to_h).to eq(class: 'foo bar qux')
          end
        end
      end
    end
  end
end

