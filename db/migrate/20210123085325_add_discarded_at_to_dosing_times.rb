class AddDiscardedAtToDosingTimes < ActiveRecord::Migration[6.0]
  def change
    add_column :dosing_times, :discarded_at, :datetime
    add_index :dosing_times, :discarded_at
  end
end
