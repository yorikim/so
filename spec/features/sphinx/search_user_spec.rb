require_relative '../feature_helper'

feature 'Search for the user index' do
  given!(:matched_user) { create(:user, email: 'test_email@gmail.com') }
  given!(:not_matched_user) { create(:user, email: 'test_email@mail.ru') }

  scenario 'User search only questions', js: true do
    build_index

    visit root_path
    fill_in 'search_query[q]', with: 'gmail.com'
    select "User", :from => "search_query[index_type]"

    click_on 'Search'

    expect(current_path).to eq search_path

    expect(page).to have_content matched_user.email
    expect(page).to_not have_content not_matched_user.email
  end
end