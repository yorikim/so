require_relative '../feature_helper'


feature 'Subscribe the question' do
  include ActiveJob::TestHelper

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Logged user is trying to subscribe and unsubscribe to the question', js: true do
    clear_emails
    sign_in user
    visit question_path(question)

    click_link 'Subscribe'
    wait_for_ajax

    expect(page.body).to have_content 'You are successfully subscribed'

    click_link 'Unsubscribe'
    wait_for_ajax

    expect(page.body).to have_content 'You are successfully unsubscribed'

  end

  scenario 'Anonymous user is trying to subscribe for the question' do
    visit question_path(question)

    expect(page.body).to_not have_content 'Subscribe'
    expect(page.body).to_not have_content 'Unsubscribe'
  end
end