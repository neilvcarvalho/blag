class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :markdown_text, presence: true, if: :published_at

  scope :published, -> { where('posts.published_at <= ?', Time.zone.now).references(:posts) }
  scope :scheduled, -> { where('posts.published_at > ?', Time.zone.now).references(:posts) }

  def published?
    published_at >= Time.zone.now if published_at
  end

  def to_param
    [id, title.parameterize].join('-')
  end

  def parse_markdown!
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    self.html_text = markdown.render(markdown_text)
  end
end
