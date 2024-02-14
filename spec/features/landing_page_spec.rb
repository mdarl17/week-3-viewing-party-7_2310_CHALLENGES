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

  describe "successfull login attempt" do 
    it 'has a Log In link for registered users to sign in to their account after providing the proper credentials' do
      visit '/'
  
      click_link 'Sign In'
  
      expect(current_path).to eq(login_path)
  
      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
  
      click_button 'Log In'
  
      expect(current_path).to eq(user_path(@user1.id))
      expect(page).to have_content("Welcome back, #{@user1.name}!")
    end
  end
end
