class Trip < ApplicationRecord
  has_many :trip_wineries
  has_many :wineries, :through => :trip_wineries

  belongs_to :user
end
