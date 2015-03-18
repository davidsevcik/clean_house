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
            # binding.pry if queue.member_ids.include?(nil)
          end
        end
        members = Member.find(selected_ids)

        unless (0.3..0.7).cover?(members.select(&:woman).size.to_f / members.size)
          skip_woman = members.select(&:woman).size > members.reject(&:woman).size
          skipped_ids << selected_ids.delete(members.reverse.find {|m| m.woman == skip_woman }.id)
          selected_ids << queue.member_ids.shift
          # binding.pry if queue.member_ids.include?(nil)
        end

        selected_ids = selected_ids.compact.uniq

        if previous_selected_ids == selected_ids && selected_ids.size < number_of_people
          selected_ids += skipped_ids.shift(number_of_people - selected_ids.size)
          binding.pry if queue.member_ids.include?(nil)
        end
        # binding.pry if queue.member_ids.include?(nil)
        members = Member.find(selected_ids)
      end while previous_selected_ids != selected_ids

      shift.members += members

      # binding.pry if shift.members.size < number_of_people

      queue.member_ids = (skipped_ids + queue.member_ids + selected_ids).compact.uniq
      queue.member_ids = (Member.regulars.map(&:id) - queue.member_ids) + queue.member_ids
      queue.save!
    end

    def last_member_ids_in_queue(queue_name, shifts_count)
      Shift.joins(:member_join).where(name: queue_name).last(shifts_count).inject([]) do |sum, s|
        sum += s.member_ids
      end.uniq
    end
  end
end


class WorkdayPlanner < Planner
  def self.applicable?(date)
    (1..4).include? date.wday
  end

  def self.plan(date)
    shift = Shift.create(name: 'workday', start_at: date, end_at: date)
    last_weekends_ids = last_member_ids_in_queue('weekend', 4)
    plan_shift_and_update_queue(shift, WorkdayQueue.first, 2, last_weekends_ids)
  end
end


class WeekendPlanner < Planner
  def self.applicable?(date)
    date.wday == 5
  end

  def self.plan(date)
    shift = Shift.create(name: 'weekend', start_at: date, end_at: date + 2)
    resident_queue = ResidentQueue.first
    shift.members << Member.find(resident_queue.member_ids.first)
    resident_queue.member_ids.rotate!
    resident_queue.save!

    last_workdays_ids = last_member_ids_in_queue('workday', 16)
    plan_shift_and_update_queue(shift, WeekendQueue.first, 5, last_workdays_ids)
  end
end
