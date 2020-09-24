class CreateDosingTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :dosing_times do |t|
      t.time       :time,          null: false
      t.string     :timeframe,     null: false

      t.references :care_receiver, null: false, foreign_key: true

      t.timestamps
    end
  end
end
