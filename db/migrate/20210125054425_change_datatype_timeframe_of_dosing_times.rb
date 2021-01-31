class ChangeDatatypeTimeframeOfDosingTimes < ActiveRecord::Migration[6.0]
  def up
    change_column :dosing_times, :timeframe, :smallint
  end

  def down
    change_column :dosing_times, :timeframe, :string
  end
end
