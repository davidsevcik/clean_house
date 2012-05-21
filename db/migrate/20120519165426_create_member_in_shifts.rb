class CreateMemberInShifts < ActiveRecord::Migration
  def change
    create_table :member_in_shifts do |t|
      t.integer :shift_id
      t.integer :member_id
    end
  end
end
