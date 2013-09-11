require 'spec_helper'
require 'ostruct'

describe Planner do
  let(:shift) { OpenStruct.new(members: []) }
  let(:queue) { OpenStruct.new(member_ids: []) }

  before(:each) do
    Member.stub(:find) do |ids|
      ids.map {|id| OpenStruct.new(id: id, woman: id.last == 'w', name: id) }
    end
  end

  describe ".plan_shift_and_update_queue" do
    context "without skipped ids" do
      it "plans the shift and circle the queue" do
        queue.member_ids = %w(1m 2m 3w 4w)
        Planner.plan_shift_and_update_queue(shift, queue, 4, [])
        expect(shift.members.map(&:id)).to eql(%w(1m 2m 3w 4w))
        expect(queue.member_ids).to eql(%w(1m 2m 3w 4w))
      end
    end

    context "with skipped ids" do
      it "plans the shift and circle the queue" do
        queue.member_ids = %w(1m 2m 3w 4w)
        Planner.plan_shift_and_update_queue(shift, queue, 3, %w(2m))
        expect(shift.members.map(&:id)).to eql(%w(1m 3w 4w))
        expect(queue.member_ids).to eql(%w(2m 1m 3w 4w))
      end
    end

    context "with bad sex ratio" do
      it "harmonizes sexes" do
        queue.member_ids = %w(1m 2m 3w 4w)
        Planner.plan_shift_and_update_queue(shift, queue, 2, [])
        expect(shift.members.map(&:id)).to eql(%w(1m 3w))
        expect(queue.member_ids).to eql(%w(2m 4w 1m 3w))
      end
    end

    context "with skipped ids that leads to bad sex ratio" do
      it "plans the shift and circle the queue" do
        queue.member_ids = %w(1m 2w 3w 4m)
        Planner.plan_shift_and_update_queue(shift, queue, 2, %w(1m))
        expect(shift.members.map(&:id)).to eql(%w(2w 4m))
        expect(queue.member_ids).to eql(%w(1m 3w 2w 4m))
      end
    end

    context "with reparing sex ratio leads to skipping ids" do
      it "plans the shift and circle the queue" do
        queue.member_ids = %w(1w 2w 3m 4m)
        Planner.plan_shift_and_update_queue(shift, queue, 2, %w(3m))
        expect(shift.members.map(&:id)).to eql(%w(1w 4m))
        expect(queue.member_ids).to eql(%w(2w 3m 1w 4m))
      end
    end
  end
end
