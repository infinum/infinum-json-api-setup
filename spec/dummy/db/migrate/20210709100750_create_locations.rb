class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.decimal :latitude, precision: 10, scale: 8, null: false
      t.decimal :longitude, precision: 11, scale: 8, null: false

      t.timestamps
    end
  end
end
