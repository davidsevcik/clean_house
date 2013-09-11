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
      member_ids << member.id
      save!
    end
  end

  def member_updated(member)
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
