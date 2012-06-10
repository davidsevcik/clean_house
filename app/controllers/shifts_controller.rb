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
    session[:return_url] = request.referer
  end


  def edit
    @shift = Shift.find(params[:id])
    session[:return_url] = request.referer
  end


  def create
    @shift = Shift.new(params[:shift])

    if @shift.save
      redirect_to session.delete(:return_url) || shifts_path, notice: "Směna přidána."
    else
      render action: "new"
    end
  end


  def update
    @shift = Shift.find(params[:id])

    if @shift.update_attributes(params[:shift])
      redirect_to session.delete(:return_url) || shifts_path, notice: "Směna upravena."
    else
      render action: "edit"
    end
  end


  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy

    redirect_to shifts_url, notice: "Směna smazána."
  end
end

