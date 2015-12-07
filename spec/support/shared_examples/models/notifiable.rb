require 'rails_helper'

shared_examples_for 'notifiable model' do
  let(:follower) { create(:user) }

  it 'notifies followers' do
    subscribed_question.followers << follower

    expect(NotifyFollowerJob).to receive(:perform_later).with([follower])
    TestAfterCommit.with_commits(true) do
      subject.save!
    end
  end
end
