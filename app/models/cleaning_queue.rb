class CleaningQueue < ActiveRecord::Base
  attr_accessible :name, :member_ids
  serialize :member_ids, Array
  belongs_to :place

  def add_member?(member)
    true
  end

  def remove_member?(member)
    true
  end


  def member_created(member)
    if member.cleaning_place_id == self.cleaning_place_id && add_member?(member)
      member_ids << member.id
      save!
    end
  end

  def member_updated(member)
    if member.cleaning_place_id == self.cleaning_place_id && remove_member?(member) && member_ids.include?(member.id)
      member_ids.delete member.id
      save!
    end
  end

  def member_destroyed(member)
    if member.cleaning_place_id == self.cleaning_place_id && member_ids.include?(member.id)
      member_ids.delete member.id
      save!
    end
  end

end
