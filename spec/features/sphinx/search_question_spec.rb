require_relative '../feature_helper'

feature 'Search for the question index' do
  given!(:body_matched_question) { create(:question, title: 'Question 1', body: 'Test') }
  given!(:title_matched_question) { create(:question, title: 'Test Question 2', body: 'abrakadabra2') }
  given!(:not_matched_question) { create(:question, title: 'Question 3', body: 'abrakadabra3') }

  scenario 'User search only questions', js: true do
    build_index

    visit root_path
    fill_in 'search_query[q]', with: 'Test'
    select "Question", :from => "search_query[index_type]"

    click_on 'Search'

    expect(current_path).to eq search_path

    expect(page).to have_content body_matched_question.title
    expect(page).to have_content title_matched_question.title
    expect(page).to_not have_content not_matched_question.title
  end
end