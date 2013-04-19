require 'showcase'
require_relative './fixtures'

describe Showcase::Presenter do
  let(:context) { Context.new }
  let(:object) { Project.new('Showcase') }
  let(:subject) { ProjectPresenter.new(object, context) }

  it 'takes the object and a context as parameters' do
    subject.object.should == object
    subject.view_context.should == context
  end

  it 'preserves original .class' do
    subject.class.should == Project
  end

  it 'delegates methods to object' do
    subject.dummy.should == 'foobar'
  end

  it 'allows overriding of methods' do
    subject.name.should == 'Presented Showcase'
  end

  it 'allows .h as shortcut to access the context' do
    subject.bold_name.should == '**Showcase**'
  end

  describe '.present' do
    it 'passes the context' do
      subject.first_collaborator.bold_name.should == '**Ju Liu**'
    end
  end

  describe '#presents' do
    it 'wraps the specified attributes inside a presenter' do
      subject.owner.sex.should == 'male'
    end
    it 'passes the context' do
      subject.owner.bold_name.should == '**Stefano Verna**'
    end
  end

  describe '#presents_collection' do
    it 'wraps the specified collection attributes inside a presenter' do
      subject.collaborators.first.sex.should == 'male'
    end
    it 'passes the context' do
      subject.collaborators.first.bold_name.should == '**Ju Liu**'
    end
  end
end

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
      different_context = stub
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

