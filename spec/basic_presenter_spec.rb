require 'basic_presenter'

class Person < Struct.new(:name)
end

class Project < Struct.new(:name)
  def owner
    Person.new("Stefano Verna")
  end

  def collaborators
    [ Person.new("Ju Liu") ]
  end

  def dummy
    "foobar"
  end
end

class PersonPresenter < BasicPresenter::Base
  def sex
    'male'
  end
end

class ProjectPresenter < BasicPresenter::Base
  presents :owner
  presents_collection :collaborators

  def name
    "Presented #{object.name}"
  end

  def context_foo
    h.foo
  end
end

describe BasicPresenter::Base do

  let(:context) { stub(:context, foo: 'bar') }
  let(:object) { Project.new('BasicPresenter') }
  let(:subject) { ProjectPresenter.new(object, context) }

  it 'takes object and a context as parameters' do
    subject.object.should == object
    subject.context.should == context
  end

  it 'preserves class' do
    subject.class.should == Project
  end

  it 'delegates methods to object' do
    subject.dummy.should == 'foobar'
  end

  it 'can override methods' do
    subject.name.should == 'Presented BasicPresenter'
  end

  it 'can use .h as shorthand for context' do
    subject.context_foo.should == 'bar'
  end

  describe '#present' do
    it 'is a shortcut to present associated attribute' do
      subject.owner.sex.should == 'male'
    end
  end

  describe '#presents' do
    it 'is a shortcut to present associated attribute' do
      subject.owner.sex.should == 'male'
    end
  end

  describe '#presents_collection' do
    it 'is a shortcut to present associated collections' do
      subject.collaborators.first.sex.should == 'male'
    end
  end
end

class Context
  include BasicPresenter::Helpers
end

describe BasicPresenter::Helpers do

  let(:object) { Person.new('Steve Ballmer') }
  let(:context) { Context.new }

  describe '.present' do
    context 'when object is already a BasicPresenter' do
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
      it 'accepts the presenter class to use as second optional parameter' do
        ProjectPresenter.stub(:new).with(object, context).and_return 'Presenter'
        context.present(object, ProjectPresenter).should == 'Presenter'
      end
      it 'accepts the context to use as third option parameter' do
        different_context = stub
        context.present(object, ProjectPresenter, different_context).context.should == different_context
      end
    end
  end

end
