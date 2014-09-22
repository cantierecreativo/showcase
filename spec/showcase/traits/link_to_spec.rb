require 'spec_helper'

module Showcase::Traits
  describe LinkTo do

    let(:view) { RailsViewContext.new }
    let(:record) { Model.new }
    subject { presenter.new(record, view) }

    let(:active) { false }
    before do
      allow(record).to receive(:active).and_return(active)
    end

    let(:presenter) {
      Class.new(Showcase::Presenter) do
        include LinkTo

        link_to do |c|
          c.url = url
          c.label = 'Label'
          c.active = active
          c.html_options role: 'label'
        end

        link_to :foo do |c|
          c.url = '#foo'
          c.active_class = 'current'
          c.active = active
        end

        def url
          '#bar'
        end
      end
    }

    describe '#link_to' do

      context 'defines a link method' do
        it 'pointing to the specified url' do
          expect(subject.link).to have_tag(:a, with: { href: '#bar' })
        end

        it 'with the specified label' do
          expect(subject.link).to have_tag(:a, text: 'Label')
        end

        it 'with the specified html attributes' do
          expect(subject.link).to have_tag(:a, with: { role: 'label' })
        end

        context 'with a different label as parameter' do
          it 'uses it' do
            expect(subject.link('Foo')).to have_tag(:a, text: 'Foo')
          end
        end

        context 'with additional options' do
          it 'uses them as html options' do
          end
        end

        context 'with a block' do
          it 'uses it instead of the label' do
            result = subject.link { 'Foo' }
            expect(result).to have_tag(:a, text: 'Foo')
          end
        end

        context 'if active' do
          let(:active) { true }

          it 'adds an active class to the link' do
            expect(subject.link('label')).to have_tag(:a, with: { class: 'active' })
          end

          context 'with additional classes' do
            it 'it sums them' do
              expect(subject.link('label', class: 'extra')).to have_tag(:a, with: { class: 'extra active' })
            end
          end

          context 'if a different CSS class was specified at DSL level' do
            it 'adds it to the link' do
              expect(subject.foo_link('label')).to have_tag(:a, with: { class: 'current' })
            end
          end

          context 'if a different CSS class was specified at method-call level' do
            it 'adds it to the link' do
              expect(subject.link('label', active_class: 'current')).to have_tag(:a, with: { class: 'current' })
            end
          end
        end
      end

      context 'defines an link_active? method' do
        let(:active) { double }

        it 'returns the active flag' do
          expect(subject.link_active?).to eq active
        end
      end

      context 'defines an url method' do
        it 'returns the url' do
          expect(subject.url).to eq '#bar'
        end
      end

      context 'with prefix' do
        it 'prefixes link method' do
          expect(subject).to respond_to :foo_link
        end

        it 'prefixes link_active? method' do
          expect(subject).to respond_to :foo_link_active?
        end

        it 'prefixes url method' do
          expect(subject).to respond_to :foo_url
        end
      end
    end

  end
end

