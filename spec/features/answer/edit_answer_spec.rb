require_relative '../feature_helper'

feature 'Edit Answer' do
  given!(:user) { create(:user) }
  given!(:own_question) { create(:question, user: user) }
  given!(:foreign_question) { create(:question) }

  given!(:answer) { create(:answer, question: foreign_question, user: user) }
  given!(:foreign_answer) { create(:answer, question: own_question) }

  describe 'Logged user is' do
    before do
      sign_in user
    end

    scenario 'sees link to edit' do
      visit question_path(foreign_question)

      within '.answer-actions' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'trying to edit own answer', js: true do
      visit question_path(own_question)

      click_on 'Edit question'

      within '.question-container' do
        fill_in 'question_body', with: 'New Answer Body'

        click_on 'Save'

        expect(page).to_not have_content own_question.body

        expect(page).to have_content 'New Answer Body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'trying to edit foreign answer' do
      visit question_path(own_question)
      expect(page).to_not have_selector '.answer-actions a.edit-answer-link'
    end
  end
end