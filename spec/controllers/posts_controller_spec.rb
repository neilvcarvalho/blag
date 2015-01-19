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
end
