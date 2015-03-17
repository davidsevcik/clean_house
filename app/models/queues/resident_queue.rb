class ResidentQueue < CleaningQueue

  def add_member?(member)
    member.active? && member.resident?
  end

  def remove_member?(member)
    !member.active? || !member.resident?
  end
end
