require_relative '../feature_helper'

feature 'Create question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  given!(:foreign_question) { create(:question) }
  given!(:answer_to_foreign_question) { create(:answer, question: foreign_question, user: user) }

  describe 'User sets the best answer for', js: true do
    before { sign_in user }

    scenario 'his question' do
      visit question_path(question)

      page.find("#set-best-answer-#{answer1.id}").click
      expect(page).to have_selector(".answer-content-best", text: answer1.body)

      page.find("#set-best-answer-#{answer2.id}").click
      expect(page).to have_selector(".answer-content-best", text: answer2.body)
    end

    scenario 'foreign question' do
      visit question_path(foreign_question)

      expect(page).to_not have_link 'Mark as best answer'
    end
  end
end