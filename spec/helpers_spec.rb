require 'spec_helper'

describe Showcase::Helpers do
  let(:object) { Person.new('Steve Ballmer') }
  let(:context) { Context.new }

  describe '.present' do
    it 'instanciate a new presenter, inferring the class' do
      PersonPresenter.stub(:new).with(object, context).and_return 'Presenter'
      context.present(object, PersonPresenter).should == 'Presenter'
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

