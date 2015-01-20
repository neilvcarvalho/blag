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

    it 'renders a Markdown template into HTML' do
      post.parse_markdown!
      expect(post.html_text).to include('<h1>This is a sample post</h1>')
    end

    it 'returns self' do
      expect(post.parse_markdown!).to eq post
    end
  end

  describe '#publish!(DateTime.now)' do
    subject(:post) { create(:post, markdown_text: File.read(Rails.root.join('spec/fixtures/markdown_post.md'))) }

    before do
      now = Time.zone.local(2014, 10, 1, 15, 30, 45)
      travel_to(now)

      allow(post).to receive(:parse_markdown!).and_return(post)
    end

    after { travel_back }

    it 'returns self' do
      expect(post.publish!).to eq post
    end

    context 'when an argument is passed' do
      it 'sets the publishing date to the argument' do
        yesterday = Time.zone.now - 1.day

        expect { post.publish!(yesterday) }.to change { post.published_at }.
          to(yesterday)
      end
    end

    context 'when an argument is not passed' do
      it 'sets the publishing date to the current DateTime' do
        expect { post.publish! }.to change { post.published_at }.
          to(Time.zone.now)
      end
    end
  end
end
