require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
  describe 'GET index' do
    let(:posts) { [double, double] }

    before do
      allow(Post).to receive(:published).and_return(posts)
    end

    it 'assigns all published posts to @posts' do
      expect(Post).to receive(:published).and_return(posts)
      get :index
      expect(assigns(:posts)).to eq posts
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns HTTP code 200' do
      get :index
      expect(response).to be_ok
    end
  end

  describe 'GET show' do
    let(:post) { build_stubbed(:post, :published) }

    before do
      allow(Post).to receive(:find).with(post.id.to_s).and_return(post)
    end

    it 'assigns the the post record as @post' do
      expect(Post).to receive(:find).with(post.id.to_s).and_return(post)
      get :show, id: post.id
      expect(assigns(:post)).to eq post
    end

    it 'renders the show template' do
      get :show, id: post.id
      expect(response).to render_template(:show)
    end

    it 'returns HTTP code 200' do
      get :show, id: post.id
      expect(response).to be_ok
    end
  end
end
