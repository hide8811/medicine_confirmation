class CreateCareReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :care_receivers do |t|
      t.string  :last_name,        null: false
      t.string  :first_name,       null: false
      t.string  :last_name_kana,   null: false
      t.string  :first_name_kana,  null: false
      t.date    :birthday,         null: false
      t.boolean :enroll,           null: false, default: true

      t.timestamps
    end
  end
end
