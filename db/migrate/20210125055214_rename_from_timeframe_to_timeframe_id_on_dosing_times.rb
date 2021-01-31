class RenameFromTimeframeToTimeframeIdOnDosingTimes < ActiveRecord::Migration[6.0]
  def change
    rename_column :dosing_times, :timeframe, :timeframe_id
  end
end
