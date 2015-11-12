require 'rails_helper'

feature 'Create question', %q{
        In order to get answer from community
        As a user
        I want to ask question
} do
  given!(:user) { create(:user) }

  scenario 'Logged user asks question' do
    sign_in user

    visit questions_path

    click_on 'Ask question'
    fill_in 'question_title', with: 'Test title'
    fill_in 'question_body',  with: 'Test body'

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Anonymous user is trying to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end