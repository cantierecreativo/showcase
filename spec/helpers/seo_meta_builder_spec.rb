require 'spec_helper'

module Showcase::Helpers
  describe SeoMetaBuilder do

    let(:view) { RailsViewContext.new }
    let(:builder) { double('SeoMetaBuilder') }

    subject { SeoMetaBuilder.new(view) }

    describe '#title' do
      it 'produces a <title/> tag' do
        expect(subject.title('foo')).to have_tag(:title, text: 'foo')
      end

      it 'produces a og:title meta tag' do
        expect(subject.title('foo')).to have_tag(:meta, with: { property: 'og:title', content: 'foo' })
      end

      it 'produces a twitter:title meta tag' do
        expect(subject.title('foo')).to have_tag(:meta, with: { name: 'twitter:title', content: 'foo' })
      end

      context 'with multiple values' do
        it 'uses the first non-blank' do
          expect(subject.title(['', nil, 'foo'])).to have_tag(:title, text: 'foo')
        end
      end

      context 'with a :title_suffix option' do
        it 'produces a <title/> tag with the suffix' do
          expect(subject.title('foo', title_suffix: ' - bar')).to have_tag(:title, text: 'foo - bar')
        end
        it 'does not suffix meta tags' do
          expect(subject.title('foo')).to have_tag(:meta, with: { property: 'og:title', content: 'foo' })
          expect(subject.title('foo')).to have_tag(:meta, with: { name: 'twitter:title', content: 'foo' })
        end
      end
    end

    describe '#description' do
      it 'produces a description meta tag' do
        expect(subject.description('foo')).to have_tag(:meta, with: { name: 'description', content: 'foo' })
      end

      it 'produces a og:description meta tag' do
        expect(subject.description('foo')).to have_tag(:meta, with: { property: 'og:description', content: 'foo' })
      end

      it 'produces a twitter:description meta tag' do
        expect(subject.description('foo')).to have_tag(:meta, with: { name: 'twitter:description', content: 'foo' })
      end

      context 'with multiple values' do
        it 'uses the first non-blank' do
          expect(subject.description(['', nil, 'foo'])).to have_tag(:meta, with: { name: 'description', content: 'foo' })
        end
      end
    end

    describe '#image_url' do
      it 'produces a og:image meta tag' do
        expect(subject.image_url('foo')).to have_tag(:meta, with: { property: 'og:image', content: 'foo' })
      end

      it 'produces a twitter:image meta tag' do
        expect(subject.image_url('foo')).to have_tag(:meta, with: { name: 'twitter:image', content: 'foo' })
      end

      context 'with multiple values' do
        it 'uses the first non-blank' do
          expect(subject.image_url(['', nil, 'foo'])).to have_tag(:meta, with: { property: 'og:image', content: 'foo' })
        end
      end
    end

    describe '#canonical_url' do
      it 'produces a og:url meta tag' do
        expect(subject.canonical_url('foo')).to have_tag(:meta, with: { property: 'og:url', content: 'foo' })
      end

      it 'produces a canonical link tag' do
        expect(subject.canonical_url('foo')).to have_tag(:link, with: { rel: 'canonical', href: 'foo' })
      end

      context 'with multiple values' do
        it 'uses the first non-blank' do
          expect(subject.canonical_url(['', nil, 'foo'])).to have_tag(:meta, with: { property: 'og:url', content: 'foo' })
        end
      end
    end

  end
end

