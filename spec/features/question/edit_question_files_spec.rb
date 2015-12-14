require_relative '../feature_helper'

feature "Edit question's files" do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_attachments, user: user) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User removes question's file", js: true do
    click_on 'Edit question'

    all('.remove_fields').first.click
    click_on 'Save question'

    expect(page).to_not have_link 'test1.txt', href: '/uploads/attachment/file/1/test1.txt'
  end

  scenario "User add a new file to the question", js: true do
    click_on 'Edit question'
    within '.question-container' do
      click_on 'Add attachment'

      all('input[type="file"]').last.set get_correct_filepath("#{Rails.root}/spec/support/fixtures/test2.txt")
      click_on 'Save question'

      expect(page).to have_link 'test2.txt', href: '/uploads/attachment/file/2/test2.txt'
    end
  end
end