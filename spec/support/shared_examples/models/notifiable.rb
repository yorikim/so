require 'rails_helper'

shared_examples_for 'notifiable model' do
  it 'notifies followers' do
    expect(NotifyFollowerJob).to receive(:perform_later).with(subscribed_question)
    TestAfterCommit.with_commits(true) do
      subject.save!
    end
  end
end
