class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.timestamp :start_time, null: false
      t.timestamp :end_time, null: false
      t.timestamp :deadline
      t.string :location
      t.text :description
      t.integer :capacity, comment: 'Maximum number of participants'
      t.integer :host_user_id, null: false

      t.timestamps
    end
  end
end
