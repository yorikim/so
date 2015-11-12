require 'rails_helper'

feature 'Remove question' do
  given!(:current_user) { create(:user) }
  given!(:own_question) { create(:question, user: current_user) }

  scenario 'Authenticated user is trying to remove own question' do
    sign_in(current_user)

    visit question_path(own_question)
    click_on 'Remove question'

    expect(page).to have_content 'Your question successfully removed.'
    expect(current_path).to eq questions_path
  end

  given!(:another_user) { create(:user) }
  given!(:foreign_question) { create(:question, user: another_user) }

  scenario "Authenticated user can't remove foreign question" do
    sign_in(current_user)

    visit question_path(foreign_question)
    expect(page).to_not have_content 'Remove question'
  end
end