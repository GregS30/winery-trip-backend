class CreateGrapes < ActiveRecord::Migration[5.2]
  def change
    create_table :grapes do |t|
      t.string :name

      t.timestamps
    end
  end
end
