require_relative '../feature_helper'

feature 'Search for the answer index' do
  given!(:question) { create(:question, title: 'abrakadabra1', body: 'abrakadabra1') }
  given!(:matched_answer) { create(:answer, body: 'Test answer 1', question: question) }
  given!(:not_matched_answer) { create(:answer, body: 'abrakadabra3', question: question) }

  scenario 'User search only answers', js: true do
    ThinkingSphinx::Deltas.suspend!
    build_index
    ThinkingSphinx::Deltas.resume!

    visit root_path
    fill_in 'search_query[q]', with: 'Test'
    select "Answer", :from => "search_query[index_type]"

    click_on 'Search'

    expect(current_path).to eq search_path

    expect(page).to have_content matched_answer.body
    expect(page).to_not have_content not_matched_answer.body
  end
end