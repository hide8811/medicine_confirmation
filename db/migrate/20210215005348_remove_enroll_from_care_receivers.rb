class RemoveEnrollFromCareReceivers < ActiveRecord::Migration[6.0]
  def change
    remove_column :care_receivers, :enroll, :boolean
  end
end
