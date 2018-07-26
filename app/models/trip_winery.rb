class TripWinery < ApplicationRecord
  belongs_to :trip
  belongs_to :winery
end
