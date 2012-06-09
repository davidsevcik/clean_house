class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.string :name
      t.date :start_at
      t.date :end_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :shifts
  end
end
