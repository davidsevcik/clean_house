class Member < ActiveRecord::Base
  attr_accessible :active, :name, :woman, :email, :phone, :resident
  has_many :member_in_queues

  scope :regulars, where(:active => true, :resident => false)
  scope :residents, where(:active => true, :resident => true)
end
