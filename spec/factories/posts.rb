FactoryGirl.define do
  factory :post do
    title 'A day in my life'

    trait :published do
      published_at Time.zone.local(2010, 12, 31, 10, 30, 0)
      markdown_text 'This is a post'
    end
  end
end