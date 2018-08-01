class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_wineries

end
