# encoding: utf-8
class UserSessionsController < ApplicationController

  def new
    @session = UserSession.new
  end


  def create
    @session = UserSession.new(params[:user_session])
      if @session.valid?
        user_login
        redirect_to members_path, notice: 'Přihlášení bylo úspěšné.'
      else
        render action: "new"
      end
  end

  def destroy
    user_logout
    redirect_to root_path
  end
end
