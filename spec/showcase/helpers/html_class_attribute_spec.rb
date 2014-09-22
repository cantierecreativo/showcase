require 'spec_helper'

module Showcase
  module Helpers
    describe HtmlClassAttribute do
      let(:attribute) { HtmlClassAttribute.new(string) }
      let(:string) { nil }

      describe '.to_html_attribute' do
        subject { attribute.to_html_attribute }

        context 'nil' do
          let(:string) { nil }
          it { is_expected.to be_nil }
        end

        context 'empty' do
          let(:string) { '' }
          it { is_expected.to be_nil }
        end

        context 'whitespaces only' do
          let(:string) { '  ' }
          it { is_expected.to be_nil }
        end

        context 'with trailing spaces' do
          let(:string) { '  foo  ' }
          it { is_expected.to eq 'foo' }
        end

        context 'with multiple classes' do
          let(:string) { '  foo bar ' }
          it { is_expected.to eq 'foo bar' }
        end
      end

      describe '#<<' do
        before do
          attribute << addition
        end

        subject { attribute.to_html_attribute }

        context 'with no existing class attribute' do
          let(:string) { nil }
          let(:addition) { '  foo  ' }

          it { is_expected.to eq 'foo' }
        end

        context 'with empty class attribute' do
          let(:string) { '' }
          let(:addition) { 'foo' }

          it { is_expected.to eq 'foo' }
        end

        context 'with existing class attribute' do
          let(:string) { 'bar' }
          let(:addition) { 'foo' }

          it { is_expected.to eq 'bar foo' }
        end

        context 'with the same css class' do
          let(:string) { 'foo bar' }
          let(:addition) { 'foo' }

          it { is_expected.to eq 'foo bar' }
        end

        context 'multiple additions' do
          let(:string) { 'foo bar' }
          let(:addition) { 'foo qux' }

          it { is_expected.to eq 'foo bar qux' }
        end
      end
    end
  end
end

