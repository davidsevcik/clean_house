class CleaningQueue < ActiveRecord::Base
  attr_accessible :name, :member_ids
  serialize :member_ids, Array

  def add_member?(member)
    true
  end

  def remove_member?(member)
    true
  end


  def member_created(member)
    if add_member? member
      last_two = Member.find(member_ids.last(2))
      if last_two[0].woman? == last_two[1].woman? && last_two[1] != member.woman?
        members_id.insert -2, member.id
      else
        member_ids << member.id
      end
      save!
    end
  end

  def member_updated(member)
    binding.pry
    if remove_member?(member) && member_ids.include?(member.id)
      member_ids.delete member.id
      save!
    end
  end

  def member_destroyed(member)
    if member_ids.include?(member.id)
      member_ids.delete member.id
      save!
    end
  end

end
