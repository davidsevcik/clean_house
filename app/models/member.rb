class Member < ActiveRecord::Base
  attr_accessible :active, :name, :woman, :email, :phone, :resident
  has_many :member_in_queues
  acts_as_list

  SCOPES = [:actives, :regulars, :residents]

  scope :actives, where(:active => true)
  scope :regulars, where(:active => true, :resident => false).order(:position)
  scope :residents, where(:active => true, :resident => true).order(:position)
  scope :men, where(:woman => false)
  scope :women, where(:woman => true)

  def self.in_scope(name)
    send name if SCOPES.include?(name.to_sym)
  end
end
