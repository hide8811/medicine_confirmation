class AddIndexStatusTimeToDosingTimes < ActiveRecord::Migration[6.0]
  def change
    add_index :dosing_times, %i[time care_receiver_id discarded_at], unique: true, name: 'index_dosing_time_time_care_receiver_discard'
  end
end
