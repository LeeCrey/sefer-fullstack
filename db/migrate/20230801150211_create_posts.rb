class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :thread_id
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :comments_count, null: false, default: 0
      t.integer :cached_votes_up, null: false, default: 0
      t.integer :photos_count, null: false, default: t.timestamps
    end
  end
end
