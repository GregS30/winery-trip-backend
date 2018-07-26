class CreateQuiniWines < ActiveRecord::Migration[5.2]
  def change
    create_table :quini_wines do |t|
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
