require "rails_helper"

RSpec.describe "logging out", type: :feature do 
  before :each do 
    @user1 = User.create!(name: "User One", email: "user1@test.com", password: "gobrowns", password_confirmation: "gobrowns")
    visit '/'
  end 

  it "logs a user out by deleting the session cookie and redirecting users to the login page" do 
    click_link 'Sign In'
    expect(current_path).to eq(login_path)

    fill_in :email, with: @user1.email
    fill_in :password, with: @user1.password
    fill_in :location, with: "Denver, CO"

    click_button 'Log In'

    expect(current_path).to eq(user_path(@user1.id))

    click_link 'Logout'

    visit login_path
    expect(current_path).to eq(login_path)
    expect(page).to have_field(:location, with: "Denver, CO")
  end

  
end 