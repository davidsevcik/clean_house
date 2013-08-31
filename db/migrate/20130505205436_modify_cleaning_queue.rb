class ModifyCleaningQueue < ActiveRecord::Migration
  def change
    add_column :cleaning_queues, :type, :string
    add_column :cleaning_queues, :member_ids, :text

    workday_queue = CleaningQueue.find_by_system_name('workday')
    workday_queue.update_attribute 'type', 'WorkdayQueue'
    weekend_queue = CleaningQueue.find_by_system_name('weekend')
    weekend_queue.update_attribute 'type', 'WeekendQueue'
    resident_queue = CleaningQueue.find_by_system_name('residents')
    resident_queue.update_attribute 'type', 'ResidentQueue'

    CleaningQueue.find_by_system_name('mens').destroy
    CleaningQueue.find_by_system_name('womens').destroy

    workday_queue = WorkdayQueue.first
    weekend_queue = WeekendQueue.first
    resident_queue = ResidentQueue.first

    divider = Member.find_by_position workday_queue.last_assigned_position
    divided = Member.all.split divider
    (divided[1] + [divider] + divided[0]).each do |m|
      workday_queue.member_ids << m.id if workday_queue.add_member?(m)
    end
    workday_queue.save!

    Member.all.shuffle.each do |m|
      weekend_queue.member_ids << m.id if weekend_queue.add_member?(m)
      resident_queue.member_ids << m.id if resident_queue.add_member?(m)
    end
    weekend_queue.save!
    resident_queue.save!

    remove_column :cleaning_queues, :system_name
    remove_column :cleaning_queues, :last_assigned_position
  end
end
