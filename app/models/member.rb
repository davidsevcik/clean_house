class Member < ActiveRecord::Base
  attr_accessible :active, :name, :woman, :email, :phone, :resident
  has_many :member_in_queues
end
