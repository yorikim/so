require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::TestHelpers

  describe 'POST #submit_email' do
    let(:user_params) { attributes_for(:user) }

    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    it 'assigns created user' do
      expect { post :submit_email, user: user_params }.to change(User, :count).by(1)
    end

    it 'assigns created user' do
      post :submit_email, user: user_params
      expect(assigns(:user).present?).to eq(true)
    end

    it 'redirects to sign in page' do
      post :submit_email, user: user_params
      should redirect_to new_user_session_path
    end
  end
end
