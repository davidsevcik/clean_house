class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, :default => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :shifts
  end
end
