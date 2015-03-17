class Planner
  class << self
    def applicable?(context)
      false
    end

    def plan(context)
      raise "Have to be implemented"
    end

    def auto_plan(date, place = nil)
      planner = Planner.subclasses.detect {|p| p.applicable?(date, place) }
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
  end
end
