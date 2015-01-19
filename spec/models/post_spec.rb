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
end
