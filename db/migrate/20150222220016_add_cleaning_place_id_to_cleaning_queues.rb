class AddCleaningPlaceIdToCleaningQueues < ActiveRecord::Migration
  def change
    add_column :cleaning_queues, :place_id, :integer
    add_index :cleaning_queues, :place_id
    CleaningQueue.reset_column_information
    CleaningQueue.update_all('place_id = 1')
  end
end
