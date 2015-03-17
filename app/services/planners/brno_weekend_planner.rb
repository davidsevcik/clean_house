class BrnoWeekendPlanner < Planner
  def self.applicable?(date, place)
    place.name == 'brno' && date.wday == 5
  end

  def self.plan(date)
    shift = Shift.create(name: 'weekend', start_at: date, end_at: date + 2)
    resident_queue = ResidentQueue.first
    shift.members << Member.find(resident_queue.member_ids.first)
    resident_queue.member_ids.rotate!
    resident_queue.save!

    last_workdays_ids = WorkdayQueue.first.member_ids.last(32)
    plan_shift_and_update_queue(shift, WeekendQueue.first, 5, last_workdays_ids)
  end
end
