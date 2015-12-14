require 'rails_helper'

RSpec.describe NotifyFollowerJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user, followers: [user]) }

  it 'notifies follower' do
    expect(NotifyMailer).to receive(:notify_follower).with(user).and_call_original.twice
    NotifyFollowerJob.perform_now(question)
  end
end
