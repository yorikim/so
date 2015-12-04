require 'rails_helper'

shared_examples_for 'commentable model' do
  it { should have_many(:comments).dependent(:destroy) }
end
