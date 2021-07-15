class CreateLocationLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :location_labels do |t|
      t.references :location, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end
