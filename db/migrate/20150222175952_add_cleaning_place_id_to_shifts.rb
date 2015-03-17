class AddCleaningPlaceIdToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :place_id, :integer
    add_index :shifts, :place_id
    Shift.reset_column_information
    Shift.update_all('place_id = 1')
  end
end
