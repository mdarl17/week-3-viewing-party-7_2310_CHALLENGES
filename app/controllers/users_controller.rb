require 'uri'

class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
    @location = JSON.parse(cookies.signed[:form_data], symbolize_names: true)[:location] if cookies.signed[:form_data]
  end 

  def create 
    user = User.create(user_params)
    session[:user_id] = user.id

    if user.save
      store_form_data(email: user.email, location: params[:location])
      redirect_to user_path(user)
    else  
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  def login_form
    @location = JSON.parse(cookies.signed[:form_data], symbolize_names: true)[:location] if cookies.signed[:form_data]
    @email = JSON.parse(cookies.signed[:form_data], symbolize_names: true)[:email] if cookies.signed[:form_data]
  end

  def login
    user = User.find_by(email: params[:email])
    session[:user_id] = user.id
    if !user
      flash[:error] = "Sorry, we could't find an account with the email you entered."
      render :login_form
    elsif !user.authorized(params)
      flash[:error] = "Sorry, the password entered does not match the one we have on file. Please try logging in again."
      render :login_form
    else
      store_form_data(email: user.email, location: params[:location])
      flash[:message] = "Welcome back, #{user.name}!"
      redirect_to user_path(user.id)
    end
  end

  def logout
    reset_session

    redirect_to root_path, notice: "You have been logged out."
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 

  def store_form_data(data)
    cookies.signed[:form_data] = {
        value: {
          email: data[:email],
          location: data[:location]
        }.to_json,
      expires: 1.week.from_now
    }
  end
end 