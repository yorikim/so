require 'rails_helper'

feature 'Create question', %q{
        In order to get answer from community
        As a user
        I want to ask question
} do
  scenario 'User asks question' do
    visit questions_path

    click_on 'Ask question'
    fill_in 'question_title', with: 'Test title'
    fill_in 'question_body',  with: 'Test body'

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
  end
end