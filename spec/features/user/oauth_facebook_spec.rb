require_relative '../feature_helper'

feature 'Sign in with facebook' do
  scenario "can sign in user with facebook" do
    visit new_user_session_path

    mock_auth_hash
    click_on "Sign in with Facebook"

    expect(page.body).to have_content('Successfully authenticated from Facebook account.')
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit new_user_session_path

    click_link "Sign in with Facebook"

    expect(page.body).to have_content('Could not authenticate you from Facebook because')
  end
end
