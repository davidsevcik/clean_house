class UserSessionsController < ApplicationController

  def new
    @session = UserSession.new
  end


  def create
    @session = UserSession.new(params[:user_session])
      if @session.valid?
        redirect_to @member, notice: 'Member was successfully created.'
      else
        render action: "new"
      end
  end
end
