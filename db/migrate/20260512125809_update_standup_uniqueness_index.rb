class UpdateStandupUniquenessIndex < ActiveRecord::Migration[8.0]
  def change
    # 1. Remove the old strict index 
    remove_index :standups, [:user_id, :created_at_date]
    
    # 2. Add a "Partial Index"
    # This only checks uniqueness for records where discarded_at is NULL
    add_index :standups, [:user_id, :created_at_date], 
              unique: true, 
              where: "discarded_at IS NULL", 
              name: "index_standups_on_user_and_date_uniqueness"
  end
end