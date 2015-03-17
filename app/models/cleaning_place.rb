class CleaningPlace
  extend Enumerable

  class << self
    def each
      return enum_for(:each) unless block_given?
      all.each { |item| yield item }
    end

    def all
      ITEMS
    end
  end

  private

  Item = Struct.new(:id, :key, :name, :queues)

  ITEMS = [
    Item.new(1, 'brno', 'Brno', %w[ResidentQueue WeekendQueue WorkdayQueue]),
    Item.new(2, 'ostrava', 'Ostrava', %w[]),
  ].freeze
end
