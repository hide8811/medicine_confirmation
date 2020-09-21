class CreateDosingTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :dosing_times do |t|

      t.timestamps
    end
  end
end
