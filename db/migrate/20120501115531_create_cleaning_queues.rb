class CreateCleaningQueues < ActiveRecord::Migration
  def change
    create_table :cleaning_queues do |t|
      t.string :name
      t.string :system_name
      t.integer :last_assigned_position, :default => 0

      t.timestamps
    end
  end
end
