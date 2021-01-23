class AddDiscardedAtToMedicineDosingTimes < ActiveRecord::Migration[6.0]
  def change
    add_column :medicine_dosing_times, :discarded_at, :datetime
    add_index :medicine_dosing_times, :discarded_at
  end
end
