require_relative '../feature_helper'
require_relative '../../support/wait_for_ajax'

feature 'Vote for the question' do
  given(:user) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }

  scenario 'Logged user is trying to vote for the foreign question', js: true do
    sign_in user
    visit question_path(foreign_question)

    within '.question-content' do
      expect(page.body).to have_selector 'span.vote-value', text: '0'

      first('.question-vote-up-link').click
      wait_for_ajax
      expect(page.body).to have_selector 'span.vote-value', text: '1'

      first('.question-vote-down-link').click
      wait_for_ajax
      expect(page.body).to have_selector 'span.vote-value', text: '0'

      first('.question-vote-down-link').click
      wait_for_ajax
      expect(page.body).to have_selector 'span.vote-value', text: '-1'
    end
  end

  scenario 'Logged user is trying to vote for the own question' do
    sign_in user
    visit question_path(own_question)

    expect(page.body).to_not have_link href: vote_up_question_path(foreign_question)
    expect(page.body).to_not have_link href: vote_down_question_path(foreign_question)
  end

  scenario 'Anonymous user is trying to vote for the question' do
    visit question_path(foreign_question)

    expect(page.body).to_not have_link href: vote_up_question_path(foreign_question)
    expect(page.body).to_not have_link href: vote_down_question_path(foreign_question)
  end
end