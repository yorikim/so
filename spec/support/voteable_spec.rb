require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:model_sym) { model.to_s.underscore.to_sym }
  let(:model_object) { create(model_sym) }
  let(:user) { create(:user) }

  it 'able to show vote value' do
    expect(model_object.vote_value).to eq 0
  end

  it 'able to be voted up' do
    expect { model_object.vote_up(user) }.to change(model_object, :vote_value).by(1)
  end

  it 'able to be voted up' do
    expect { model_object.vote_down(user) }.to change { model_object.vote_value }.by(-1)
  end
end
