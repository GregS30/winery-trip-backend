class Trip < ApplicationRecord
  has_many :trip_wineries
  belongs_to :user
end
