require_relative '../feature_helper'

feature 'Add files to the answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answer to question', js: true do
    fill_in 'answer_body', with: 'Test answer body'

    all('.new_answer input[type="file"]').first.set get_correct_filepath(File.join(Rails.root, 'spec', 'support', 'fixtures', 'test1.txt'))

    click_on 'Add attachment'

    all('.new_answer input[type="file"]').last.set get_correct_filepath(File.join(Rails.root, 'spec', 'support', 'fixtures', 'test2.txt'))

    click_on 'Create answer'

    expect(page).to have_link 'test1.txt', href: '/uploads/attachment/file/1/test1.txt'
    expect(page).to have_link 'test2.txt', href: '/uploads/attachment/file/2/test2.txt'
  end
end