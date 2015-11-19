require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:model_object) { create(model.to_s.underscore.to_sym) }


  it "able to be voted up" do
    expect(model_object.vo).to eq("Stewart Home")
  end

  it "able to be voted up" do
    model_object = FactoryGirl.create(model.to_s.underscore.to_sym)
    expect(person.full_name).to eq("Stewart Home")
  end
end
