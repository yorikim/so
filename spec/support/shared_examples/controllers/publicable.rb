shared_examples_for 'publicable controller' do |channel|
  context 'publish_to' do
    it 'publishes to channel' do
      expect(PrivatePub).to receive(:publish_to).with(channel, anything)
      request
    end
  end
end