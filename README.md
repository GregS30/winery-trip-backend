# winery-trip-backend
Mod 4 Project (backend)

rails g resource Region name
rails g resource TripWinery trip_id:integer winery_id:integer
rails g resource Wine name varietal type style id
rails g resource Winery name region_id:integer
rails g resource Trip name user_id:integer start_date:date end_date:d
ate
rails g resource User name

setup cors gem

rails db:create
rails db:migrate

rails g migration create_wine_from_apis name

class CreateWineFromApis < ActiveRecord::Migration[5.2]
  def change
    create_table :wine_from_apis do |t|
      t.integer :sequence
      t.string :area
      t.string :country
      t.string :name
      t.string :province
      t.string :style
      t.string :wine_type
      t.string :varietal
      t.string :winery
      t.string :api_id
      t.string :vintage
    end
  end
end
