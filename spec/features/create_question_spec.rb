require 'rails_helper'

feature 'Create question', %q{
        In order to get answer from community
        As a user
        I want to ask question
} do
  given!(:user) { create(:user) }

  scenario 'Logged user asks question' do
    sign_in user
    create_question 'Test title', 'Test body'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Anonymous user is trying to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end