require_relative '../feature_helper'

feature 'Remove answer' do
  given!(:current_user) { create(:user) }

  given!(:own_question) { create(:question, user: current_user) }
  given!(:foreign_question) { create(:question) }

  given!(:own_answer) { create(:answer, question: foreign_question, user: current_user) }
  given!(:foreign_answer) { create(:answer, question: own_question) }

  scenario 'Authenticated user is trying to remove own answer', js: true do
    sign_in(current_user)
    visit question_path(foreign_question)

    click_on 'Remove answer'

    expect(page).to_not have_content(own_answer.body)

    expect(current_path).to eq question_path(foreign_question)
  end

  scenario "Authenticated user can't remove foreign answer", js: true do
    sign_in(current_user)

    visit question_path(own_question)
    expect(page).to_not have_selector '.answer-actions a.remove-answer-link'
  end
end