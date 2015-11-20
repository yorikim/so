require_relative '../feature_helper'
require_relative '../../support/wait_for_ajax'

feature 'Vote for the question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  given!(:own_answer) { create(:answer, question: question, user: user) }
  given!(:foreign_answer) { create(:answer, question: question) }

  scenario 'Logged user is trying to vote for the foreign answer', js: true do
    sign_in user
    visit question_path(question)

    within "#answer-container-#{foreign_answer.id}" do
      expect(page.body).to have_selector "#answer-container-#{foreign_answer.id} span.vote-value", text: '0'

      first('.answer-vote-up-link').click
      wait_for_ajax

      expect(page.body).to have_selector "#answer-container-#{foreign_answer.id} span.vote-value", text: '1'

      first('.answer-vote-down-link').click
      wait_for_ajax
      expect(page.body).to have_selector "#answer-container-#{foreign_answer.id} span.vote-value", text: '0'

      first('.answer-vote-down-link').click
      wait_for_ajax
      expect(page.body).to have_selector "#answer-container-#{foreign_answer.id} span.vote-value", text: '-1'
    end
  end

  scenario 'Logged user is trying to vote for the own answer' do
    sign_in user
    visit question_path(question)

    expect(page.body).to_not have_link href: vote_up_question_answer_path(question, own_answer)
    expect(page.body).to_not have_link href: vote_down_question_answer_path(question, own_answer)
  end

  scenario 'Anonymous user is trying to vote for the question' do
    visit question_path(question)

    expect(page.body).to_not have_link href: vote_up_question_answer_path(question, foreign_answer)
    expect(page.body).to_not have_link href: vote_down_question_answer_path(question, own_answer)
  end
end