require 'rails_helper'

feature 'User can answer to question', %q{
        In order to help community
        As a user
        I want to answer to question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Logged user is trying to create answer to question', js: true do
    sign_in user

    visit question_path(question)

    fill_in 'answer_body', with: 'Test answer body'
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Test answer body'
    end
  end

  scenario 'Anonymous user is trying to create answer to question' do
    visit question_path(question)

    expect(page).to_not have_selector("input[type=submit][value='Create Answer']")
  end
end