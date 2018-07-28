class RemoveVarietalFromWine < ActiveRecord::Migration[5.2]
  def change
    remove_column :wines, :varietal, :string
  end
end
