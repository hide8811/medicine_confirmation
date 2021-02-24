class AddIndexToNameOfMedicines < ActiveRecord::Migration[6.0]
  def change
    add_index :medicines, %i[name discarded_at], unique: true
  end
end
