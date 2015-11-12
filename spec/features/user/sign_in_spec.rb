require 'rails_helper'

feature 'Sign in', %q{
        In order to be able to ask question
        As a registered user
        I want to be able to sign in
} do
  given!(:user) { create(:user) }

  scenario 'Registered user sign in' do
    sign_in user

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    sign_in User.new(email: '404@mail.ru', password: '12345678')

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end