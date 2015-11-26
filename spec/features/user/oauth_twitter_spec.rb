require_relative '../feature_helper'

feature 'Sign in with twitter' do
  scenario "can sign in user with twitter" do
    clear_emails
    visit new_user_session_path

    mock_auth_hash
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: 'mockuser@mail.ru'
    click_on 'Continue'

    open_email('mockuser@mail.ru')
    current_email.click_link 'Confirm my account'

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page.body).to have_content('Successfully authenticated from Twitter account.')
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit new_user_session_path

    click_link "Sign in with Twitter"

    expect(page.body).to have_content('Could not authenticate you from Twitter because')
  end
end