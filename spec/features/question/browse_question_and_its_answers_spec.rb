require 'rails_helper'

feature "Browse question and it's answers", %q{
        In order to improve knowledge
        As a user
        I want to browse question and see it's answers
} do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User browse questions' do
    visit question_path(question)

    expect(page).to have_content question.title
    answers.each { |answer| expect(page).to have_content answer.title }
  end
end