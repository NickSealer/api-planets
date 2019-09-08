class CreateGalaxies < ActiveRecord::Migration[5.2]
  def change
    create_table :galaxies do |t|
      t.string :name
      t.text :description
      t.decimal :right_ascension
      t.decimal :declination
      t.decimal :distance
      t.references :form, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
