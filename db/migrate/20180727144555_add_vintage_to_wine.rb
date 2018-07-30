class AddVintageToWine < ActiveRecord::Migration[5.2]
  def change
    add_column :wines, :vintage, :string
  end
end
