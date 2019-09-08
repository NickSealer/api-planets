class Form < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: true
  validates :name, inclusion:{in: %w(Elíptica Espiral Lenticular Irregular Activa Seyfert Starburst Radiogalaxia Cuásar), message: "%Is not a valid galaxy."}
end
