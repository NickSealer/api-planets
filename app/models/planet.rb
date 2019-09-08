class Planet < ApplicationRecord
  belongs_to :galaxy
  belongs_to :user
  validates :name, uniqueness: true
  validates :name, length:{minimum: 2}
end
