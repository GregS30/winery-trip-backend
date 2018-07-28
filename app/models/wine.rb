class Wine < ApplicationRecord
  belongs_to :grape
  belongs_to :winery
end
