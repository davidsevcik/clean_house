class MemberInQueue < ActiveRecord::Base
  attr_accessible :cleaning_queue_id, :member_id, :position
  belongs_to :member
  belongs_to :queue, :class_name => "CleaningQueue", :foreign_key => "queue_id"
  acts_as_list :scope => :queue
end
