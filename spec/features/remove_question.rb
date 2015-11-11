require 'rails_helper'

feature 'Remove question' do
  given!(:current_user) { create(:user) }
  given!(:question_of_current_user) { create(:question, user: current_user) }

  scenario 'Authenticated user is trying to remove own question' do
    visit question_path(question_of_current_user)

    click_on 'Remove question'

    expect(page).to have_content 'Your question successfully removed.'
    expect(current_path).to eq questions_path
  end

  given!(:another_user) { create(:user) }
  given!(:question_of_another_user) { create(:question, user: another_user) }

  scenario "Authenticated user can't remove foreign question" do
    visit question_path(question_of_current_user)
    expect(page).to_not have_content 'Remove question'
  end
end