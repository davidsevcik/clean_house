class CleaningQueue < ActiveRecord::Base
  attr_accessible :name, :system_name
  has_many :member_join, :class_name => "MemberInQueue", :foreign_key => "queue_id",
    :order => 'position'
  has_many :members, :through => :member_join

  # def add_member(member)
  #   member_in_queue = member_join.build(:member_id => member.id)
  #   placed = member_join.includes :member
  #   position = nil

  #   for i in 0..(placed.size - 2)
  #     member_1 = placed[i].member
  #     member_2 = placed[i+1].member
  #     if member_1.woman? == member_2.woman? && member_1.woman? != member.woman?
  #       position = placed[i+1].position
  #       break
  #     end
  #   end

  #   if position.nil?
  #     member_in_queue.save
  #   else
  #     member_in_queue.insert_at position
  #   end
  # end


  def next_member(members)
    member = members[self.last_assigned_position + 1]
    if member.nil?
      member = members[0]
      self.update_attribute(:last_assigned_position, 0)
    else
      self.update_attribute(:last_assigned_position, self.last_assigned_position + 1)
    end
    puts "#{self.last_assigned_position}: #{member.name}"
    member
  end

  # def cycle_members(count)
  #   members_in_queue = member_join.where("position > ?", last_assigned_position)
  #     .order(:position).limit(count).includes(:member)

  #   if members_in_queue.size < count #preklopeni queue
  #     members_in_queue += member_join.order(:position).limit(count - members_in_queue.size)
  #       .includes(:member)
  #   end

  #   update_attribute(:last_assigned_position, members_in_queue.last.position)

  #   members_in_queue.map(&:member)
  # end

end
