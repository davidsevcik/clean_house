class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.boolean :woman, :default => false
      t.boolean :resident, :default => false
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
