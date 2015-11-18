require_relative '../feature_helper'

feature "Remove answer's files" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer_with_attachments, user: user, question: question ) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User removes answer's file", js: true do
    click_on 'Edit answer'

    all('.remove_fields').first.click
    click_on 'Save answer'

    expect(page).to_not have_link 'test1.txt', href: '/uploads/attachment/file/1/test2.txt'
  end
end