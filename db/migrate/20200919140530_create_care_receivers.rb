class CreateCareReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :care_receivers do |t|

      t.timestamps
    end
  end
end
