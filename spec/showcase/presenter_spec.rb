require 'spec_helper'

describe Showcase::Presenter do
  let(:context) { Context.new }
  let(:object) { Project.new('Showcase') }
  let(:subject) { ProjectPresenter.new(object, context) }

  it 'takes the object and a context as parameters' do
    expect(subject.object).to eq(object)
    expect(subject.view_context).to eq(context)
  end

  it 'preserves original .class' do
    expect(subject.class).to eq(Project)
  end

  it 'should be kind of original class' do
    expect(subject).to be_kind_of Project
  end

  it 'should be instance of original class' do
    expect(subject).to be_instance_of Project
  end

  it 'delegates methods to object' do
    expect(subject.dummy).to eq('foobar')
  end

  it 'allows overriding of methods' do
    expect(subject.name).to eq('Presented Showcase')
  end

  it 'implements :try method the right way' do
    expect(subject.try(:name)).to eq('Presented Showcase')
  end

  it 'allows .h as shortcut to access the context' do
    expect(subject.bold_name).to eq('**Showcase**')
  end

  describe '.present' do
    it 'passes the context' do
      expect(subject.first_collaborator.bold_name).to eq('**Ju Liu**')
    end
  end

  describe '#presents' do
    it 'wraps the specified attributes inside a presenter' do
      expect(subject.owner.sex).to eq('male')
    end
    it 'passes the context' do
      expect(subject.owner.bold_name).to eq('**Admin Stefano Verna**')
    end
    it 'returns null if nil_presenter is false or undefined' do
      expect(subject.owner_child).to be_nil
    end
    it 'returns a null presenter if nil_presenter is true' do
      expect(subject.foobar.hi).to eq "hi!"
    end
  end

  describe '#presents_collection' do
    it 'wraps the specified collection attributes inside a presenter' do
      expect(subject.collaborators.first.sex).to eq('male')
    end
    it 'passes the context' do
      expect(subject.collaborators.first.bold_name).to eq('**Ju Liu**')
    end
  end
end

