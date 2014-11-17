require 'spec_helper'

feature 'user signs in' do
  scenario "with valid email and password" do
    jeff = Fabricate(:user)
    visit root_path
    fill_in "Username", with: jeff.username
    fill_in "Password", with: jeff.password
    click_button "Sign In"
  end
end