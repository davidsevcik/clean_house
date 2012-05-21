class CreateMemberInQueues < ActiveRecord::Migration
  def change
    create_table :member_in_queues do |t|
      t.integer :member_id
      t.integer :queue_id
      t.integer :position

      t.timestamps
    end
  end
end
