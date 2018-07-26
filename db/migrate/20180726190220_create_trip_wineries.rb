class CreateTripWineries < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_wineries do |t|
      t.integer :trip_id
      t.integer :winery_id

      t.timestamps
    end
  end
end
