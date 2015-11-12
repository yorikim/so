require 'rails_helper'

feature 'Remove answer' do
  given!(:current_user) { create(:user) }
  given!(:another_user) { create(:user) }

  given!(:own_question) { create(:question, user: current_user) }
  given!(:foreign_question) { create(:question, user: another_user) }

  given!(:own_answer_to_foreign_question) { create(:answer, question: foreign_question, user: current_user) }
  given!(:foreign_answer_to_own_question) { create(:answer, question: own_question, user: another_user) }

  scenario 'Authenticated user is trying to remove own answer' do
    sign_in(current_user)
    visit question_path(foreign_question)

    click_on 'Remove answer'

    expect(page).to have_content 'Your answer successfully removed.'
    expect(current_path).to eq question_path(foreign_question)
  end

  scenario "Authenticated user can't remove foreign answer" do
    sign_in(current_user)

    visit question_path(own_question)
    expect(page).to_not have_content 'Remove answer'
  end
end