require_relative '../feature_helper'

feature 'Browse questions', %q{
        In order to exchange experience
        As a user
        I want to browse questions
} do
  given!(:question1) { create(:question) }
  given!(:question2) { create(:question) }

  scenario 'User browse questions' do
    visit questions_path

    expect(page).to have_content question1.title
    expect(page).to have_content question2.title
  end
end