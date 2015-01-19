require 'rails_helper'

describe 'posts/show.html.erb' do
  let(:post) { build_stubbed(:post, html_text: '<p>A day in my life</p>') }

  before do
    assign(:post, post)
    render
  end

  it 'sets content_for(:title) as "Neil Carvalho - Post title' do
    expect(view.content_for(:title)).to eq "Neil Carvalho - #{post.title}"
  end

  it 'renders the unescaped HTML text' do
    expect(rendered).to include post.html_text
  end
end