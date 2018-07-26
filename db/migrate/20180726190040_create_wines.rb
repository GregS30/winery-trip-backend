class CreateWines < ActiveRecord::Migration[5.2]
  def change
    create_table :wines do |t|
      t.string :name
      t.string :varietal
      t.string :type
      t.string :style
      t.string :api_id
      t.integer :winery_id

      t.timestamps
    end
  end
end
