class OstravaPlanner < Planner
  class << self
    def applicable?(date, place)
      place.name == 'ostrava'
    end
  end
end
