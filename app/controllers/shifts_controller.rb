# encoding: utf-8

MemberStatistics = Struct.new(:name, :workday_count, :weekend_count)

class ShiftsController < ApplicationController
  before_filter :login_required

  def index
    month = (params[:month] || (Time.zone || Time).now.month).to_i
    year = (params[:year] || (Time.zone || Time).now.year).to_i

    @date = Date.new(year, month)
    @prev_date = @date.prev_month
    @next_date = @date.next_month

    @shifts = Shift.around_month(year, month).includes(:members)
  end


  def new
    @shift = Shift.new
    @shift.start_at = @shift.end_at = params[:start_at] if params[:start_at]
  end


  def edit
    @shift = Shift.find(params[:id])
  end


  def create
    @shift = Shift.new(params[:shift])

    if @shift.save
      redirect_to return_or(shifts_path), notice: "Směna přidána."
    else
      render action: "new"
    end
  end


  def update
    @shift = Shift.find(params[:id])

    if @shift.update_attributes(params[:shift])
      redirect_to return_or(shifts_path), notice: "Směna upravena."
    else
      render action: "edit"
    end
  end


  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy

    redirect_to return_or(shifts_path), notice: "Směna smazána."
  end


  def regenerate
    from = Date.new(params[:from][:year].to_i, params[:from][:month].to_i, params[:from][:day].to_i)
    to = Date.new(params[:to][:year].to_i, params[:to][:month].to_i, params[:to][:day].to_i)

    Shift.where('start_at >= ?', from).delete_all

    (from..to).each do |date|
      # puts "Plannning #{date.to_s}"
      Planner.auto_plan(date)
    end
    redirect_to shifts_path
  end


  def print
    month = (params[:month] || (Time.zone || Time).now.month).to_i
    year = (params[:year] || (Time.zone || Time).now.year).to_i
    @date = Date.new(year, month)
  end


  def statistics
    workday_shift = Shift.where(name: 'workday')
    weekend_shift = Shift.where(name: 'weekend')
    @statistics = Member.regulars.map do |member|
      workday_num = workday_shift.select {|shift| shift.member_ids.include?(member.id) }.size
      weekend_num = weekend_shift.select {|shift| shift.member_ids.include?(member.id) }.size
      MemberStatistics.new member.name, workday_num, weekend_num
    end
    @statistics.sort_by! &:name
  end

end
