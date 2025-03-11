class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uid
      t.string :profile_picture

      t.timestamps
    end
    add_index :users, :uid, unique: true
  end
end
