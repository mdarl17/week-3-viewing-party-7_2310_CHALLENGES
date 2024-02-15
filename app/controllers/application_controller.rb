class ApplicationController < ActionController::Base
  helper_method :current_user

  def bake_cookies
    user = current_user
    cookies[user.email] = JSON.generate({
        location: params[:location],
        expires: 1.week.from_now
      })
  end

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private
end
