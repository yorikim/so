require 'rails_helper'

shared_examples_for 'attachable model' do
  it { should have_many(:attachments).dependent(:destroy) }
end
