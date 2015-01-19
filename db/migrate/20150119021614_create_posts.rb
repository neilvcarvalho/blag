class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :published_at
      t.text :markdown_text
      t.text :html_text
      t.string :title

      t.timestamps null: false
    end
  end
end
