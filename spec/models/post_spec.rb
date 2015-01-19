require 'rails_helper'

RSpec.describe Post, :type => :model do
  subject(:post) { Post.new }

  describe 'validations' do
    it { should validate_presence_of :title }

    context 'when published_at is present' do
      before { post.published_at = Time.zone.now }

      it { should validate_presence_of :markdown_text }
    end
  end

  describe 'scopes' do
    before do
      now = Time.zone.local(2014, 10, 1, 15, 30, 45)
      travel_to(now)
    end

    let!(:old_post) { create(:post, :published, published_at: Time.zone.now - 1.year) }
    let!(:recent_post) { create(:post, :published, published_at: Time.zone.now)}
    let!(:unpublished_post) { create(:post, :published, published_at: Time.zone.now + 1.day)}

    after { travel_back }

    describe '.published' do
      it 'returns posts published before now' do
        expect(Post.published).to include(old_post)
      end

      it 'returns posts published right now' do
        expect(Post.published).to include(recent_post)
      end

      it 'does not return posts scheduled to the future' do
        expect(Post.published).to_not include(unpublished_post)
      end
    end

    describe '.scheduled' do
      it 'does not return posts published before now' do
        expect(Post.scheduled).to_not include(old_post)
      end

      it 'does not return posts published right now' do
        expect(Post.scheduled).to_not include(recent_post)
      end

      it 'returns posts scheduled to the future' do
        expect(Post.scheduled).to include(unpublished_post)
      end
    end
  end

  describe '#published?' do
    before do
      now = Time.zone.local(2014, 10, 1, 15, 30, 45)
      travel_to(now)
    end

    after { travel_back }

    context 'published_at is after than the current time' do
      before { post.published_at = Time.zone.now + 1.hour }
      it { should be_published }
    end

    context 'published_at is equal to the current time' do
      before { post.published_at = Time.zone.now }
      it { should be_published }
    end

    context 'published_at is before than current time' do
      before { post.published_at = Time.zone.now - 1.hour }
      it { should_not be_published }
    end

    context 'published_at is nil' do
      before { post.published_at = nil }
      it { should_not be_published }
    end
  end

  describe '#to_param' do
    subject(:post) { create(:post, title: 'A day in my life')}

    it 'returns its internal id and a parameterized title' do
      expect(post.to_param).to eq "#{post.id}-a-day-in-my-life"
    end
  end

  describe '#parse_markdown!' do
    subject(:post) { create(:post, markdown_text: File.read(Rails.root.join('spec/fixtures/markdown_post.md'))) }

    before { post.parse_markdown! }

    it 'renders a Markdown template into HTML' do
      expect(post.html_text).to include('<h1>This is a sample post</h1>')
      expect(post.html_text).to include('<p>This section is expected to render a paragraph</p>')
      expect(post.html_text).to include('<li>First list item</li>')
    end
  end
end
