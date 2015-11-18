require_relative '../feature_helper'

feature "Remove question's files" do
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
end