require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
  describe 'GET index' do
    let(:posts) { [double, double] }

    before do
      allow(Post).to receive(:published).and_return(posts)
      get :index
    end

    it 'assigns all published posts to @posts' do
      get :index
      expect(assigns(:posts)).to eq posts
    end

    it { should render_template(:index) }
    it { should respond_with :ok }
  end

  describe 'GET show' do
    let(:post) { build_stubbed(:post, :published) }

    before do
      allow(Post).to receive(:find).with(post.to_param).and_return(post)
      get :show, id: post
    end

    it 'assigns the the post record to @post' do
      expect(assigns(:post)).to eq post
    end

    it { should render_template(:show) }
    it { should respond_with :ok }
  end

  describe 'GET new' do
    before do
      get :new
    end

    it 'assigns a new post to @post' do
      expect(assigns(:post)).to be_a_new(Post)
    end

    it { should render_template(:new) }
    it { should respond_with :ok }
  end

  describe 'POST create' do
    let(:my_post) { build_stubbed(:post) }

    before do
      allow(Post).to receive(:create).and_return(my_post)
      allow(my_post).to receive(:publish!).and_return(my_post)
    end

    context 'when the post persisted (is valid)' do
      before do
        allow(my_post).to receive(:persisted?).and_return(true)
        post :create, post: attributes_for(:post)
      end

      it { should redirect_to my_post }
    end

    context 'when the post did not persist (is invalid)' do
      before do
        allow(my_post).to receive(:persisted?).and_return(false)
        post :create, post: attributes_for(:post)
      end

      it { should render_template(:new) }
    end
  end
end
