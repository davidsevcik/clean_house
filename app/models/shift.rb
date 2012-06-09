class Shift < ActiveRecord::Base
  attr_accessible :name, :start_at, :end_at

  has_many :member_join, :class_name => "MemberInShift", :foreign_key => "shift_id"
  has_many :members, :through => :member_join

  scope :for_month, lambda { |year, month|
    where(:start_at => Date.new(year, month)..Date.new(year, month, -1))
  }

  scope :around_month, lambda { |year, month|
    where :start_at => (Date.new(year, month) - 6)..(Date.new(year, month, -1) + 6)
  }

  def self.plan(date)
    planner = Planner.subclasses.detect {|p| p.applicable?(date) }
    planner.plan(date) if planner
  end

end


class Planner
  class << self
    def applicable?(context)
      false
    end

    def plan(context)
      raise "Have to be implemented"
    end
  end
end


class WorkdayPlanner < Planner
  def self.applicable?(date)
    (1..4).include? date.wday
  end

  def self.plan(date)
    queue = CleaningQueue.find_by_system_name('workday')
    shift = Shift.create(:name => queue.name, :start_at => date, :end_at => date)
    shift.members = queue.cycle_members(2)
  end
end


class WeekendPlanner < Planner
  def self.applicable?(date)
    date.wday == 5
  end

  def self.plan(date)
    queue = CleaningQueue.find_by_system_name('weekend')
    shift = Shift.create(:name => queue.name, :start_at => date, :end_at => date + 2)
    shift.members = queue.cycle_members(5)
    shift.members << CleaningQueue.find_by_system_name('residents').cycle_members(1)
  end
end