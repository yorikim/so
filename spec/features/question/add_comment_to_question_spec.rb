require_relative '../feature_helper'

feature 'Add comments to the question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds comments to the question', js: true do
    click_on 'Add Comment'

    fill_in 'comment_body', with: 'Test comment'

    click_on 'Create comment'
    expect(current_path).to eq question_path(question)

    expect(page).to have_content 'Test comment'
  end

  scenario 'Anonymous user cant add comment to the question' do
    expect(page).to_not have_content 'Add comment'
  end
end