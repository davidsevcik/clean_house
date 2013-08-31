class Planner
  class << self
    def applicable?(context)
      false
    end

    def plan(context)
      raise "Have to be implemented"
    end

    def auto_plan(date)
      planner = Planner.subclasses.detect {|p| p.applicable?(date) }
      planner.plan(date) if planner
    end

    def plan_shift_and_update_queue(shift, queue, number_of_peple, skip_ids)
      selected_ids = queue.member_ids.shift(number_of_peple)
      skipped_ids = []
      sex_harmonized = false
      until (selected_ids & skip_ids).empty? do
        skipped_ids += selected_ids & skip_ids
        selected_ids -= skipped_ids
        if selected_ids.size < number_of_peple
          selected_ids << queue.member_ids.shift(number_of_peple - selected_ids.size)
        end
        harmonize_sex(selected_ids, skipped_ids, queue)
        sex_harmonized = true
      end

      harmonize_sex(selected_ids, skipped_ids, queue) unless sex_harmonized

      shift.members << Member.find(selected_ids)
      queue.member_ids << selected_ids
      queue.member_ids.unshift(skipped_ids).flatten!
      queue.save!
    end

    def harmonize_sex(selected_ids, skipped_ids, queue)
      members = Member.find(selected_ids)
      unless (0.3..0.7).cover?(members.count(&:woman?).to_f / members.count)
        skipped_ids << selected_ids.slice!(-1)
        selected_ids << queue.member_ids.shift
        members = Member.find(selected_ids)
      end
    end
  end
end


class WorkdayPlanner < Planner
  def self.applicable?(date)
    (1..4).include? date.wday
  end

  def self.plan(date)
    shift = Shift.create(start_at: date, end_at: date)
    last_weekends_ids = WorkdayQueue.first.member_ids.last(12)
    plan_shift_and_update_queue(shift, WorkdayQueue.first, 2, last_weekends_ids)
  end
end


class WeekendPlanner < Planner
  def self.applicable?(date)
    date.wday == 5
  end

  def self.plan(date)
    shift = Shift.create(start_at: date, end_at: date + 2)
    resident_queue = ResidentQueue.first
    shift.members << Member.find(resident_queue.member_ids.first)
    resident_queue.member_ids.rotate!
    resident_queue.save!

    last_workdays_ids = WorkdayQueue.first.member_ids.last(16)
    plan_shift_and_update_queue(shift, WeekendQueue.first, 5, last_workdays_ids)
  end
end
