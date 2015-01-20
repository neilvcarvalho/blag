class PostsController < ApplicationController
  def index
    @posts = Post.published
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)

    if @post.persisted?
      @post.publish!
      redirect_to @post
    else
      render action: :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :markdown_text)
  end
end
