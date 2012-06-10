class Member < ActiveRecord::Base
  attr_accessible :active, :name, :woman, :email, :phone, :resident
  has_many :member_in_queues

  SCOPES = [:actives, :regulars, :residents]

  scope :actives, where(:active => true)
  scope :regulars, where(:active => true, :resident => false)
  scope :residents, where(:active => true, :resident => true)

  def self.in_scope(name)
    send name if SCOPES.include?(name.to_sym)
  end
end
