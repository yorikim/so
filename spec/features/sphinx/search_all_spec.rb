require_relative '../feature_helper'

feature 'Search for the comment index' do
  given!(:question) { create(:question, title: 'Test Question 1', body: 'Question 1') }
  given!(:answer) { create(:answer, body: 'Test Answer 1') }
  given!(:comment) { create(:question_comment, body: 'Test comment1') }
  given!(:matched_user) { create(:user, email: 'test@gmail.com') }

  given!(:not_matched_question) { create(:question, title: 'abrakadabra', body: 'abrakadabra') }
  given!(:not_matched_answer) { create(:answer, body: 'abrakadabra') }
  given!(:not_matched_comment) { create(:question_comment, body: 'abrakadabra') }
  given!(:not_matched_user) { create(:user, email: 'abrakadabra@mail.ru') }

  scenario 'User search only comments', js: true do
    build_index

    visit root_path
    fill_in 'search_query[q]', with: 'Test'
    select "All", :from => "search_query[index_type]"

    click_on 'Search'

    expect(current_path).to eq search_path

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).to have_content matched_user.email

    expect(page).to_not have_content 'abrakadabra'
  end
end