class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :markdown_text, presence: true, if: :published_at

  def published?
    published_at >= Time.zone.now if published_at
  end
end
