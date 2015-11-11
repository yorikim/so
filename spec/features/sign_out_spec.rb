require 'rails_helper'

feature 'Sign out' do
  given!(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    sign_in user
    sign_out

    expect(page).to have_content 'Signed out successfully.'
  end
end