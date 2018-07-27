class RenameTypeToWineType < ActiveRecord::Migration[5.2]
  def change
    rename_column :wines, :type, :wine_type
  end
end
