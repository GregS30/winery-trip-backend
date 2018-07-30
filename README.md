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

rails generate migration add_area_to_wineries area
rails g migration rename_type_to_wine_type
rails generate migration add_vintage_to_wine vintage
rails generate migration add_region_to_wine_from_apis region

rails g resource Grape name
rails g migration RemoveVarietalFromWine varietal
rails g migration add_grape_to_wine grape_id:integer
