class Winery < ApplicationRecord
  has_many :wines
  has_many :trip_wineries
  belongs_to :region
end
