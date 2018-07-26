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

rake db:create
rake db:migrate
