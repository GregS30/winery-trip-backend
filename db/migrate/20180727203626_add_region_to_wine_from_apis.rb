class AddRegionToWineFromApis < ActiveRecord::Migration[5.2]
  def change
    add_column :wine_from_apis, :region, :string
  end
end
