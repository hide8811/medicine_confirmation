class CreateMedicineDosingTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :medicine_dosing_times do |t|
      t.references :medicine, null: false, foreign_key: true
      t.references :dosing_time, null: false, foreign_key: true

      t.timestamps
    end
  end
end
