require_relative '../feature_helper'

feature 'Search for the comment index' do
  given!(:question) { create(:question, title: 'Question 1', body: 'Question 1') }
  given!(:answer) { create(:answer, question: question, body: 'Answer 1') }
  given!(:matched_question_comment) { create(:question_comment, body: 'Test comment1', commentable: question) }
  given!(:matched_answer_comment) { create(:answer_comment, body: 'Test comment2', commentable: answer) }
  given!(:not_matched_question_comment) { create(:question_comment, body: 'abrakadabra2', commentable: question) }
  given!(:not_matched_answer_comment) { create(:answer_comment, body: 'abrakadabra2', commentable: answer) }

  scenario 'User search only comments', js: true do
    build_index

    visit root_path
    fill_in 'search_query[q]', with: 'Test'
    select "Comment", :from => "search_query[index_type]"

    click_on 'Search'

    expect(current_path).to eq search_path

    expect(page).to have_content question.title
    expect(page).to have_content matched_question_comment.body
    expect(page).to have_content matched_answer_comment.body

    expect(page).to_not have_content not_matched_question_comment.body
    expect(page).to_not have_content not_matched_answer_comment.body
  end
end