# encoding: utf-8
class ShiftsController < ApplicationController
  before_filter :login_required, except: [:index]

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
    # MemberInShift.delete_all
    MemberInQueue.delete_all

    workday_queue = CleaningQueue.find_by_system_name 'workday'
    Member.regulars.shuffle.each do |member|
      workday_queue.add_member member
    end

    weekend_queue = CleaningQueue.find_by_system_name 'weekend'
    Member.regulars.shuffle.each do |member|
      weekend_queue.add_member member
    end

    residents_queue = CleaningQueue.find_by_system_name 'residents'
    Member.residents.shuffle.each do |member|
      residents_queue.add_member member
    end

    from = Date.new(params[:from][:year].to_i, params[:from][:month].to_i, params[:from][:day].to_i)
    to = Date.new(params[:to][:year].to_i, params[:to][:month].to_i, params[:to][:day].to_i)
    Shift.destroy_all(["start_at >= ? AND end_at <= ?", from, to])

    (from..to).each do |date|
      Shift.auto_plan(date)
    end
    redirect_to shifts_path
  end


end

