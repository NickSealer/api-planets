class Galaxy < ApplicationRecord
  belongs_to :form
  belongs_to :user
  validates :name, uniqueness: true
  validates :name, length:{minimum: 2}
end
