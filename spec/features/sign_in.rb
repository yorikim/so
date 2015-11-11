require 'rails_helper'

feature 'Sign in', %q{
        In order to be able to ask question
        As a user
        I want to be able to sign in
} do
  scenario 'User sign in' do
    User.create!(email: 'user@mail.ru', password: '12345678')

    visit new_user_session_path

    fill_in 'Email', with: 'user@mail.ru'
    fill_in 'Password', with: '12345678'

    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: '404@mail.ru'
    fill_in 'Password', with: '12345678'

    click_on 'Sign in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end