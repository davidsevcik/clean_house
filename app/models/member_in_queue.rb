class MemberInQueue < ActiveRecord::Base
  attr_accessible :cleaning_queue_id, :member_id, :position
  belongs_to :member
  belongs_to :queue, :class_name => "CleaningQueue", :foreign_key => "cleaning_queue_id"
end
