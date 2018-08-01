class Winery < ApplicationRecord
  has_many :wines
  has_many :trip_wineries
  has_many :trips, :through => :trip_wineries

  belongs_to :region
end
