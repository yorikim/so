require_relative '../feature_helper'

feature 'Edit Question' do
  given!(:user) { create(:user) }
  given!(:own_question) { create(:question, user: user) }
  given!(:foreign_question) { create(:question) }

  describe 'Logged user is' do
    before do
      sign_in user
    end

    scenario 'sees link to edit' do
      visit question_path(own_question)

      within '.question-actions' do
        expect(page).to have_link 'Edit question'
      end
    end

    scenario 'trying to edit own question', js: true do
      visit question_path(own_question)

      click_on 'Edit question'

      within '.question-container' do
        fill_in 'question_title', with: 'New Question title'
        fill_in 'question_body', with: 'New Question Body'

        click_on 'Save'

        expect(page).to_not have_content own_question.title
        expect(page).to_not have_content own_question.body

        expect(page).to have_content 'New Question title'
        expect(page).to have_content 'New Question Body'

        expect(page).to_not have_selector 'input[type=text]'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'trying to edit foreign question' do
      visit question_path(foreign_question)
      expect(page).to_not have_selector '.question-actions a.edit-question-link'
    end
  end
end