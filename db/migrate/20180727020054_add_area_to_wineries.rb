class AddAreaToWineries < ActiveRecord::Migration[5.2]
  def change
    add_column :wineries, :area, :string
    add_column :wineries, :country, :string
    add_column :wineries, :province, :string
    add_column :wineries, :api_sequence, :integer
  end
end
