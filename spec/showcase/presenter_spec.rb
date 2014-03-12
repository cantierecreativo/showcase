require 'spec_helper'

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

  it 'should be kind of original class' do
    subject.should be_kind_of Project
  end

  it 'should be instance of original class' do
    subject.should be_instance_of Project
  end

  it 'delegates methods to object' do
    subject.dummy.should == 'foobar'
  end

  it 'allows overriding of methods' do
    subject.name.should == 'Presented Showcase'
  end

  it 'implements :try method the right way' do
    subject.try(:name).should == 'Presented Showcase'
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
      subject.owner.bold_name.should == '**Admin Stefano Verna**'
    end
    it 'returns null if nil_presenter is false or undefined' do
      subject.owner_child.should be_nil
    end
    it 'returns a null presenter if nil_presenter is true' do
      subject.foobar.hi.should eq "hi!"
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

