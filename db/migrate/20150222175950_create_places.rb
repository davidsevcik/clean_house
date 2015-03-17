class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :title
      t.string :login
      t.string :password

      t.timestamps
    end
  end
end
