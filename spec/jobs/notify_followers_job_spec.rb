require 'rails_helper'

RSpec.describe NotifyFollowerJob, type: :job do
  let!(:user) { create(:user) }
  let(:question) { create(:question, followers: [user]) }

  it 'notifies follower' do
    expect(NotifyMailer).to receive(:notify_follower).with(user).and_call_original
    NotifyFollowerJob.perform_now(question)
  end
end
