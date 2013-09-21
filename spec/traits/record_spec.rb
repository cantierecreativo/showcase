require 'spec_helper'

module Showcase::Traits
  describe Record do

    let(:view) { RailsViewContext.new }
    let(:record) { Model.new }
    let(:presenter) {
      Class.new(Showcase::Presenter) do
        include Record
      end
    }
    subject { presenter.new(record, view) }

    describe '#dom_id' do
      it 'returns a CSS ID for the model' do
        expect(subject.dom_id).to eq 'model_1'
      end
    end

    describe '#dom_class' do
      it 'returns a CSS class for model' do
        expect(subject.dom_class).to eq 'model'
      end
    end

    describe '#box' do
      it 'wraps content inside an element that uniquely identifies the record' do
        result = subject.box { "foo" }
        expect(result).to have_tag(:div, with: { class: 'model', id: 'model_1' })
      end

      context 'with a specified tag' do
        it 'uses it' do
          result = subject.box(:span) { "foo" }
          expect(result).to have_tag(:span)
        end
      end

      context 'with some class' do
        it 'uses it' do
          result = subject.box(class: 'bar') { "foo" }
          expect(result).to have_tag(:div, with: { class: 'model bar'})
        end
      end
    end

  end
end

