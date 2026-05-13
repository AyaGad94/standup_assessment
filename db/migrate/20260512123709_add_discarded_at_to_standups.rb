class AddDiscardedAtToStandups < ActiveRecord::Migration[8.1]
  def change
    add_column :standups, :discarded_at, :datetime
    add_index :standups, :discarded_at
  end
end
