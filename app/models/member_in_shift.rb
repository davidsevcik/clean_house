class MemberInShift < ActiveRecord::Base
  attr_accessible :cleaning_queue_id, :member_id
  belongs_to :member
  belongs_to :shift
end
