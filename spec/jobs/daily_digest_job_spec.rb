require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }

  it 'sends daily digest to user' do
    expect(DailyMailer).to receive(:digest).with(anything).and_call_original
    DailyDigestJob.perform_now
  end
end
