class Vehicle < ApplicationRecord
  belongs_to :user

  validates :license_plate, presence: true, uniqueness: true
  validates :brand, :model, :year, presence: true
end
