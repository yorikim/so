require 'rails_helper'

feature 'User can answer to question', %q{
        In order to help community
        As a user
        I want to answer to question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Logged user is trying to create answer to question' do
    sign_in user

    visit question_path(question)
    click_on 'Answer'

    fill_in 'answer_title', with: 'Test answer title'
    fill_in 'answer_body', with: 'Test answer body'

    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Anonymous user is trying to create answer to question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end