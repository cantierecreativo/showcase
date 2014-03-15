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
          PersonPresenter.stub(:new).with(object, context).and_return 'Presenter'
          context.present(object).should == 'Presenter'
        end
        context 'with a superclass presenter' do
          it "instantiates a new presenter, searching presenter class in object ancestors chain" do
            PersonPresenter.stub(:new).with(subclass_object, context).and_return 'Presenter'
            context.present(subclass_object).should == 'Presenter'
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
          ProjectPresenter.stub(:new).with(object, context).and_return 'Presenter'
          context.present(object, ProjectPresenter).should == 'Presenter'
        end
        it 'uses the specified context, when passed' do
          different_context = double
          context.present(object, ProjectPresenter, different_context).view_context.should == different_context
        end
      end

      describe '.present_collection' do
        it 'returns a presenter for each object in the collection' do
          collection = [ Person.new('Mark'), Person.new('Luke') ]

          PersonPresenter.stub(:new).with(collection[0], context).and_return 'foo'
          PersonPresenter.stub(:new).with(collection[1], context).and_return 'bar'

          presented_collection = context.present_collection(collection)
          presented_collection.should == [ 'foo', 'bar' ]
        end
      end
    end
  end
end

