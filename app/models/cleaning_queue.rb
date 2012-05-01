class CleaningQueue < ActiveRecord::Base
  attr_accessible :friday, :monday, :name, :saturday, :sunday, :thursday, :tuesday, :wednesday
  has_many :members_in_queue, :class_name => "MemberInQueue", :foreign_key => "cleaning_queue_id"
end
