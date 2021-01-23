class AddDiscardedAtToMedicines < ActiveRecord::Migration[6.0]
  def change
    add_column :medicines, :discarded_at, :datetime
    add_index :medicines, :discarded_at
  end
end
