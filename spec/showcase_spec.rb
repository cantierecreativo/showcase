require 'showcase'
require_relative './fixtures'

describe Showcase::Presenter do

  let(:context) { stub(:context, foo: 'bar') }
  let(:object) { Project.new('Showcase') }
  let(:subject) { ProjectPresenter.new(object, context) }

  it 'takes the object and a context as parameters' do
    subject.object.should == object
    subject.context.should == context
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
    subject.context_foo.should == 'bar'
  end

  describe '#presents' do
    it 'wraps the specified attributes inside a presenter' do
      subject.owner.sex.should == 'male'
    end
  end

  describe '#presents_collection' do
    it 'wraps the specifieed collection attributes inside a presenter' do
      subject.collaborators.first.sex.should == 'male'
    end
  end
end

describe Showcase::Helpers do
  let(:object) { Person.new('Steve Ballmer') }
  let(:context) { Context.new }

  describe '.present' do
    context 'when the passed object is already a Showcase::Base' do
      it 'returns the object itself' do
        presenter = PersonPresenter.new(object, stub)
        context.present(presenter).should == presenter
      end
    end
    context 'when the object still needs to be presented' do
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
        context.present(object, ProjectPresenter, different_context).context.should == different_context
      end
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
