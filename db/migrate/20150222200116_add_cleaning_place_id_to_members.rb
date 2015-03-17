class AddCleaningPlaceIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :place_id, :integer
    add_index :members, :place_id
    Member.reset_column_information
    Member.update_all('place_id = 1')
  end
end
