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

        seo do |c|
          c.title = 'foo'
          c.description 'bar'
          c.title_suffix = ' - qux'
        end
      end
    }

    describe '#seo' do
      let(:options) { { title_suffix: ' - qux' } }

      before do
        Showcase::Helpers::SeoMetaBuilder.stub(:new).with(view).and_return(builder)
        builder.stub(:title).with('foo', options).and_return('<title>')
        builder.stub(:description).with('bar', options).and_return('<description>')
      end

      it 'defines a seo_tags method that ouputs seo meta tags' do
        expect(subject.seo_tags(options)).to eq '<title><description>'
      end
    end

  end
end

