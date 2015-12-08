shared_examples_for 'notifiable controller' do
  it 'notifies followers' do
    follower = create(:user)
    question.add_follower!(follower)
    expect(NotifyMailer).to receive(:notify_follower).with(follower).and_call_original
    request
  end
end