class Member < ActiveRecord::Base
  attr_accessible :active, :name, :woman, :email, :phone, :resident
  has_many :member_in_queues
  belongs_to :place
  acts_as_list

  SCOPES = [:actives, :regulars, :residents]

  scope :actives, where(:active => true)
  scope :regulars, where(:active => true, :resident => false).order(:position)
  scope :residents, where(:active => true, :resident => true).order(:position)
  scope :men, where(:woman => false)
  scope :women, where(:woman => true)
  scope :of_place, lambda { |place| where(place_id: place) }


  after_create do
    CleaningQueue.all.each {|q| q.member_created(self) }
  end

  after_update do
    CleaningQueue.all.each {|q| q.member_updated(self) }
  end

  before_destroy do
    CleaningQueue.all.each {|q| q.member_destroyed(self) }
  end

  def self.in_scope(name)
    send name if SCOPES.include?(name.to_sym)
  end
end
