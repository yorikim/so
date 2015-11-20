require_relative '../feature_helper'

feature 'Add files to the question' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'question_title', with: 'New question title'
    fill_in 'question_body', with: 'New question body'


    all('input[type="file"]').first.set get_correct_filepath("#{Rails.root}/spec/support/fixtures/test1.txt")

    click_on 'Add attachment'

    all('input[type="file"]').last.set get_correct_filepath("#{Rails.root}/spec/support/fixtures/test2.txt")

    click_on 'Ask'

    expect(page).to have_link 'test1.txt', href: '/uploads/attachment/file/1/test1.txt'
    expect(page).to have_link 'test2.txt', href: '/uploads/attachment/file/2/test2.txt'
  end
end