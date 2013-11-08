require 'spec_helper'

module Showcase::Traits
  describe Share do

    let(:view) { RailsViewContext.new }
    let(:record) { Model.new }
    subject { presenter.new(record, view) }

    let(:presenter) {
      Class.new(Showcase::Presenter) do
        include Share

        share do |c|
          c.url = 'url'
          c.text = 'text'
          c.twitter_text = 'twitter text'
          c.image_url = 'image'
          c.html_options = { role: 'share' }
        end

        share :foo do |c|
          c.url = 'url'
          c.text = 'text'
          c.image_url = 'image'
        end

      end
    }

    describe '#social_share' do
      expected_urls = {
        twitter: "https://twitter.com/intent/tweet?text=twitter+text&url=url",
        facebook: "http://www.facebook.com/sharer/sharer.php?u=url",
        gplus: "https://plus.google.com/share?url=url",
        pinterest: "http://www.pinterest.com/pin/create/button/?media=image&title=text&url=url",
        linkedin: "http://www.linkedin.com/shareArticle?title=text&url=url",
      }

      expected_urls.each do |provider, url|
        it "produces a #{provider} share link" do
          expect(subject.send("#{provider}_share_link")).to have_tag(:a)
        end

        it "produces a #{provider} share url" do
          expect(subject.send("#{provider}_share_url")).to eq url
        end

        it "adds a target :blank to the link" do
          expect(subject.send("#{provider}_share_link")).to have_tag(:a, with: { target: '_blank' })
        end

        it "merges additional html_options" do
          expect(subject.send("#{provider}_share_link")).to have_tag(:a, with: { role: 'share' })
        end

        context 'with prefix' do
          it 'prefixes link method' do
            expect(subject).to respond_to "foo_#{provider}_share_link"
          end

          it 'prefixes link_active? method' do
            expect(subject).to respond_to "foo_#{provider}_share_url"
          end
        end
      end
    end

  end
end

