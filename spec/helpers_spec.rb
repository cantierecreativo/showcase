require 'spec_helper'

describe Showcase::Helpers do
  let(:object) { Person.new('Steve Ballmer') }
  let(:derived_object) { EnterpriseCustomer.new('Tito Traves') }
  let(:context) { Context.new }

  describe '.present' do
    it 'instantiates a new presenter, inferring the class' do
      PersonPresenter.stub(:new).with(object, context).and_return 'Presenter'
      context.present(object).should == 'Presenter'
    end
    it "instantiates a new presenter, searching presenter class in object ancestors chain" do
      PersonPresenter.stub(:new).with(derived_object, context).and_return 'Presenter'
      context.present(derived_object).should == 'Presenter'
    end
    it 'the presenter class to use can be specified as the second parameter' do
      ProjectPresenter.stub(:new).with(object, context).and_return 'Presenter'
      context.present(object, ProjectPresenter).should == 'Presenter'
    end
    it 'the context to use can be specified as third parameter' do
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
