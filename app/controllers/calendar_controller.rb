class CalendarController < ApplicationController

  def index
    month = (params[:month] || (Time.zone || Time).now.month).to_i
    year = (params[:year] || (Time.zone || Time).now.year).to_i

    @date = Date.new(year, month)
    @prev_date = @date.prev_month
    @next_date = @date.next_month

    @shifts = Shift.around_month(year, month).includes(:members)
  end

end
