class RemoveUnusedColumnsFromEvents < ActiveRecord::Migration[7.2]
  def change
    remove_column :events, :is_sample, :boolean
    remove_column :events, :demo_user_id, :integer
  end
end
