require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    @user1 = User.create!(name: "User One", email: "user1@test.com", password: "gobrowns", password_confirmation: "gobrowns")
    @user2 = User.create!(name: "User Two", email: "user2@test.com", password: "gobrowns", password_confirmation: "gobrowns")
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    # user1 = User.create(name: "User One", email: "user1@test.com")
    # user2 = User.create(name: "User Two", email: "user2@test.com")

    visit root_path

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user2.email)
    end     
  end

  describe 'logging in' do 
    it 'will give site access to properly credentialed users' do
      visit '/'
  
      click_link 'Sign In'
  
      expect(current_path).to eq(login_path)
  
      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
  
      click_button 'Log In'
  
      expect(current_path).to eq(user_path(@user1.id))
      expect(page).to have_content("Welcome back, #{@user1.name}!")
    end

    it 'will not let a user log in without a matching email' do
      click_link 'Sign In'

      expect(current_path).to eq(login_path)

      fill_in :email, with: "notagoodemail@bademail.com"
      fill_in :password, with: @user1.password
      
      click_button 'Log In'
      
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, we could't find an account with the email you entered.")
    end

    it 'will not let a user log in without an authorized password' do
      click_link 'Sign In'

      expect(current_path).to eq(login_path)

      fill_in :email, with: @user1.email
      fill_in :password, with: "afdlsahsdldfhsg"
      
      click_button 'Log In'
      
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, the password entered does not match the one we have on file. Please try logging in again.")
    end
  end

  describe "creating a cookie to track geographic data from user" do 
    it "users can enter their city and state info in text fields that will be displayed on their show page (landing page)" do
      click_link 'Sign In'

      expect(current_path).to eq(login_path)

      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
      fill_in :location, with: "Denver, CO"

      click_button 'Log In'

      expect(current_path).to eq(user_path(@user1.id))

      expect(page).to have_content("Denver, CO")
    end
  end
end
