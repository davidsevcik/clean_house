class Shift < ActiveRecord::Base
  attr_accessible :name, :start_at, :end_at, :member_token_ids

  has_many :member_join, :class_name => "MemberInShift", :foreign_key => "shift_id", :dependent => :delete_all
  has_many :members, :through => :member_join

  scope :for_month, lambda { |year, month|
    where(:start_at => Date.new(year, month)..Date.new(year, month, -1))
  }

  scope :around_month, lambda { |year, month|
    where :start_at => (Date.new(year, month) - 6)..(Date.new(year, month, -1) + 6)
  }

  after_save :save_members


  def member_token_ids
    member_ids.join(',')
  end

  def member_token_ids=(str)
    @member_ids = str.split(',').map(&:to_i)
  end


  private

  def save_members
    self.member_ids = @member_ids unless @member_ids.nil?
  end

end
