require 'spec_helper'

module Showcase::Traits
  describe Seo do

    let(:view) { RailsViewContext.new }
    let(:record) { Model.new }
    let(:builder) { double('SeoMetaBuilder') }
    subject { presenter.new(record, view) }

    let(:presenter) {
      Class.new(Showcase::Presenter) do
        include Seo

        default_seo_options do |c|
          c.title_suffix = ' - qux'
        end

        seo do |c|
          c.title = ['', 'foo']
          c.description = ['', 'bar']
        end
      end
    }

    describe '.seo' do
      let(:expected_options) { { title_suffix: ' - qux' } }
      let(:expected_description) { ['', 'bar'] }
      let(:expected_title) { ['', 'foo'] }

      before do
        Showcase::Helpers::SeoMetaBuilder.stub(:new).with(view).and_return(builder)
        builder.stub(:title).with(expected_title, expected_options).and_return('<title>')
        builder.stub(:description).with(expected_description, expected_options).and_return('<description>')
      end

      it 'defines a seo_tags method that ouputs seo meta tags' do
        expect(subject.seo_tags).to eq '<title><description>'
      end

      describe '#seo_tags' do
        let(:expected_title) { 'other' }

        it 'allows to override options' do
          expect(subject.seo_tags(title: 'other')).to eq '<title><description>'
        end
      end
    end

  end
end

