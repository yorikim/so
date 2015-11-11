require 'rails_helper'

feature 'User can answer to question', %q{
        In order to help community
        As a user
        I want to answer to question
} do
  given!(:question) { create(:question) }

  scenario 'User create answer to question' do
    visit question_path(question)

    click_on 'Answer'

    fill_in 'answer_title', with: 'answer title'
    fill_in 'answer_body',  with: 'answer body'

    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
  end
end