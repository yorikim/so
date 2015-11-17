require_relative '../feature_helper'

feature 'Sign out' do
  given!(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    sign_in user

    visit root_path
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end