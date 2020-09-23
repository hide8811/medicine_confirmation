class CreateTakes < ActiveRecord::Migration[6.0]
  def change
    create_table :takes do |t|
      t.boolean :execute
      t.string :dosing_timeframe
      t.time :dosing_time
      t.references :user, null: false, foreign_key: true
      t.references :care_receiver, null: false, foreign_key: true

      t.timestamps
    end
  end
end
