class AddUniqueIndexToStandups < ActiveRecord::Migration[8.1]
  def change
    add_index :standups, [:user_id, :created_at_date], unique: true
  end
end
