class Shift < ActiveRecord::Base
  attr_accessible :name, :start_at, :end_at
  
  has_many :member_join, :class_name => "MemberInShift", :foreign_key => "shift_id"
  has_many :members, :through => :member_join
  has_event_calendar
  
  def self.plan(date)
    case date.wday
      when 1..4 #workday cleaning
        queue = CleaningQueue.find_by_system_name('workday')
        members_in_queue = queue.member_join.where("position > ?", queue.last_assigned_position)
                                .order(:position).limit(2)
        shift = create(:name => queue.name, :start_at => date, :end_at => date)
        
        members_in_queue.each do |member_in_queue|
          shift.members << member_in_queue.member
        end
        
        queue.update_attribute(:last_assigned_position, members_in_queue.last.position)
      when 5 #weekend cleaning
        queue = CleaningQueue.find_by_system_name('weekend')
      
    end
  end
  
  

end
