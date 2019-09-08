class CreatePlanets < ActiveRecord::Migration[5.2]
  def change
    create_table :planets do |t|
      t.string :name
      t.text :description
      t.decimal :orbital_period
      t.decimal :rotation_period
      t.decimal :mass
      t.decimal :volume
      t.decimal :density
      t.decimal :diameter
      t.decimal :gravity
      t.references :galaxy, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
