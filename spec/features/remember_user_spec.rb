require "rails_helper"

RSpec.describe "remembering a user", type: :feature do
  before(:each) do 
    Capybara.current_driver = :selenium
    @user1 = User.create!(name: "User One", email: "user1@test.com", password: "gobrowns", password_confirmation: "gobrowns")
    visit '/'  
  end
  it "keeps a user logged in, even after they navigate to a different site" do
    click_link "Sign In"

    fill_in :email, with: @user1.email
    fill_in :password, with: @user1.password
    fill_in :location, with: "Cleveland, OH"

    click_button "Log In"

    expect(current_path).to eq(user_path(@user1.id))
    expect(@user1.name).to eq("User One")
    expect(@user1.email).to eq("user1@test.com")

    visit "https://msn.com"

    visit user_path(@user1.id)

    expect(current_path).to eq(user_path(@user1.id))
    expect(@user1.name).to eq("User One")
    expect(@user1.email).to eq("user1@test.com")
  end
end 