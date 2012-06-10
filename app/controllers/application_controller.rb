# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  helper_method :user_logged_in?


  def user_login
    session[:logged] = true
  end

  def user_logout
    session[:logged] = nil
  end

  def user_logged_in?
    not session[:logged].nil?
  end


  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def login_required
    redirect_to new_user_session_path, alert: 'Pro tuto akci se musíte přihlásit.' unless session[:logged]
  end
end
