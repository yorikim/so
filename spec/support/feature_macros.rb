module FeatureMacros

  def create_answer(question, title, body)

  end

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Sign in'
  end

  def sign_out
    visit root_path

    click_on 'Logout'
  end

  def sign_up(email, password, password_confirmation)
    visit new_user_registration_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation

    click_on 'Sign up'
  end
end