require 'uri'

class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
    email = @user.email
    @cookies = JSON.parse(cookies[@user.encode(email)], symbolize_names: true) if cookies[@user.encode(email)]
  end 

  def create 
    user = User.create(user_params)

    if user.save
      session[:user_id] = user.id
      @cookies = JSON.parse(bake_cookies, symbolize_names: true)
      redirect_to user_path(user)
    else  
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if !user
      flash[:error] = "Sorry, we could't find an account with the email you entered."
      render :login_form
    elsif !user.authorized(params)
      flash[:error] = "Sorry, the password entered does not match the one we have on file. Please try logging in again."
      render :login_form
    else
      session[:user_id] = user.id
      @cookies = JSON.parse(bake_cookies, symbolize_names: true)
      flash[:message] = "Welcome back, #{user.name}!"
      redirect_to user_path(user.id)
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end 