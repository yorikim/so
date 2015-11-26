require_relative '../feature_helper'

feature 'Sign up' do

  scenario 'Un-registered user is trying to sign up' do
    clear_emails

    sign_up 'new_user@mail.ru', '12345678', '12345678'

    open_email('new_user@mail.ru')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'User is trying to register with already registered email, short password and wrong confirmation' do
    user = create(:user)

    sign_up user.email, '1234', '8765'

    expect(page).to have_content 'Email has already been taken'
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_content 'Password is too short (minimum is 8 characters)'

    expect(current_path).to eq user_registration_path
  end
end