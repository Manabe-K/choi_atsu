class CreateThreadPosts < ActiveRecord::Migration[7.2]
  def change
    create_table :thread_posts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
