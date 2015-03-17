class BrnoWorkdayPlanner < Planner
  def self.applicable?(date)
    place.name == 'brno' && (1..4).include? date.wday
  end

  def self.plan(date)
    shift = Shift.create(name: 'workday', start_at: date, end_at: date)
    last_weekends_ids = WeekendQueue.first.member_ids.last(20)
    plan_shift_and_update_queue(shift, WorkdayQueue.first, 2, last_weekends_ids)
  end
end
