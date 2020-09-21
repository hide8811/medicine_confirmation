class CreateMedicines < ActiveRecord::Migration[6.0]
  def change
    create_table :medicines do |t|
      t.string :name, null: false, unique: true
      t.string :image
      t.string :url

      t.timestamps
    end
  end
end
