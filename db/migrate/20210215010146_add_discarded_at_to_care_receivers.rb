class AddDiscardedAtToCareReceivers < ActiveRecord::Migration[6.0]
  def change
    add_column :care_receivers, :discarded_at, :datetime
    add_index :care_receivers, :discarded_at
  end
end
