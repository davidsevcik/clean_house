# encoding: utf-8
class UserSessionsController < ApplicationController

  def new
    @session = UserSession.new
  end


  def create
    @session = UserSession.new(params[:user_session])
    if @session.valid?
      user_login(@session.place)
      redirect_to members_path, notice: 'Přihlášení bylo úspěšné.'
    else
      render action: "new"
    end
  end

  def destroy
    place = current_place
    user_logout
    redirect_to calendar_path(place: place.name)
  end
end
