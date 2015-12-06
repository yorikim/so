require 'rails_helper'

shared_examples_for 'subscribable model' do
  let(:model) { described_class }
  let(:model_sym) { model.to_s.underscore.to_sym }
  let(:model_object) { create(model_sym) }
  let(:user) { create(:user) }

  it { should have_and_belong_to_many(:followers) }

  it 'adds follower' do
    expect { model_object.add_follower!(user) }.to change{model_object.followers.count}.by(1)
  end
end