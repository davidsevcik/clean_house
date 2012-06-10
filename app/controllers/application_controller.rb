# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :set_return_url
  helper_method :user_logged_in?, :return_or


  def user_login
    session[:logged] = true
  end

  def user_logout
    session[:logged] = nil
  end

  def user_logged_in?
    not session[:logged].nil?
  end

  def login_required
    redirect_to new_user_session_path, alert: 'Pro tuto akci se musíte přihlásit.' unless session[:logged]
  end

  def return_or(path)
    session[:return_path] || path
  end


  protected

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_return_url
    if !request.xhr? && %w{index show}.include?(params[:action])
      session[:return_path] = request.fullpath
    end
  end
end
