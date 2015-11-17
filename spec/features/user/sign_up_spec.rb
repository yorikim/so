require_relative '../feature_helper'

feature 'Sign up' do
  given!(:user) { create(:user) }

  scenario 'Un-registered user is trying to sign up' do
    sign_up 'new_user@mail.ru', '12345678', '12345678'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'User is trying to register with already registered email, short password and wrong confirmation' do
    sign_up user.email, '1234', '8765'

    expect(page).to have_content 'Email has already been taken'
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_content 'Password is too short (minimum is 8 characters)'

    expect(current_path).to eq user_registration_path
  end
end