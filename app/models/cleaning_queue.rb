class CleaningQueue < ActiveRecord::Base
  attr_accessible :name, :system_name
  has_many :member_join, :class_name => "MemberInQueue", :foreign_key => "queue_id",
    :order => 'position'    
  
  def add_member(member)
    member_in_queue = member_join.build(:member_id => member.id)
    placed = member_join.all(:include => :member)
    position = nil
    
    for i in 0..(placed.size - 2)
      member_1 = placed[i].member
      member_2 = placed[i+1].member
      if member_1.woman? == member_2.woman? && member_1.woman? != member.woman?
        position = placed[i+1].position
        break
      end
    end
    
    if position.nil?
      member_in_queue.save
    else
      member_in_queue.insert_at position
    end
  end
  
end
