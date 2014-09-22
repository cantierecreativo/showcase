require 'spec_helper'

module Showcase
  module Helpers
    describe Present do
      let(:object) { Person.new('Steve Ballmer') }
      let(:subclass_object) { EnterpriseCustomer.new('Tito Traves') }
      let(:object_with_no_presenter) { Shop.new }
      let(:context) { Context.new }

      describe '.present' do
        it 'instantiates a new presenter, inferring the presenter class' do
          allow(PersonPresenter).to receive(:new).with(object, context).and_return 'Presenter'
          expect(context.present(object)).to eq('Presenter')
        end
        context 'with a superclass presenter' do
          it "instantiates a new presenter, searching presenter class in object ancestors chain" do
            allow(PersonPresenter).to receive(:new).with(subclass_object, context).and_return 'Presenter'
            expect(context.present(subclass_object)).to eq('Presenter')
          end
        end
        context 'with no existing presenter class' do
          it "raises a PresenterClassNotFound error" do
            expect {
              context.present(object_with_no_presenter)
            }.to raise_error(Showcase::PresenterClassNotFound)
          end
        end
        it 'uses the specified presenter class, when passed' do
          allow(ProjectPresenter).to receive(:new).with(object, context).and_return 'Presenter'
          expect(context.present(object, ProjectPresenter)).to eq('Presenter')
        end
        it 'uses the specified context, when passed' do
          different_context = double
          expect(context.present(object, ProjectPresenter, different_context).view_context).to eq(different_context)
        end
      end

      describe '.present_collection' do
        it 'returns a presenter for each object in the collection' do
          collection = [ Person.new('Mark'), Person.new('Luke') ]

          allow(PersonPresenter).to receive(:new).with(collection[0], context).and_return 'foo'
          allow(PersonPresenter).to receive(:new).with(collection[1], context).and_return 'bar'

          presented_collection = context.present_collection(collection)
          expect(presented_collection).to eq([ 'foo', 'bar' ])
        end
      end
    end
  end
end

