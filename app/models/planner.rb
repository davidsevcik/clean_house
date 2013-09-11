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

    def plan_shift_and_update_queue(shift, queue, number_of_people, skip_ids)
      selected_ids = queue.member_ids.shift(number_of_people)
      members = Member.find(selected_ids)
      skipped_ids = []
      begin
        previous_selected_ids = selected_ids.clone
        unless (selected_ids & skip_ids).empty?
          skipped_ids += selected_ids & skip_ids
          selected_ids -= skipped_ids
          if selected_ids.size < number_of_people
            selected_ids += queue.member_ids.shift(number_of_people - selected_ids.size)
          end
        end
        members = Member.find(selected_ids)

        unless (0.3..0.7).cover?(members.select(&:woman).size.to_f / members.size)
          skipped_ids << selected_ids.slice!(-1)
          selected_ids << queue.member_ids.shift
        end
        members = Member.find(selected_ids)
      end while previous_selected_ids != selected_ids

      shift.members += members
      queue.member_ids += selected_ids
      queue.member_ids.unshift(skipped_ids).flatten!
      queue.save!
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
