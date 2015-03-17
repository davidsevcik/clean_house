class Place < ActiveRecord::Base
  attr_accessible :name, :title

  has_many :members
  has_many :shifts
  has_many :cleaning_queues
end
