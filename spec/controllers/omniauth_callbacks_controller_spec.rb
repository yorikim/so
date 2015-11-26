require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  include Devise::TestHelpers

  let!(:user) { create(:user, email: 'mockuser@mail.ru') }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    mock_auth_hash
  end

  describe "GET #facebook" do
    context 'User already created' do
      before do
        @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
      end

      it "shouldn't create new user" do
        expect { get :facebook }.to_not change(User, :count)
      end

      it 'assigns user' do
        expect(assigns(:user)).to eq user
      end

      it 'signs in the user' do
        expect(subject.current_user).to eq user
      end

      it { should redirect_to root_path }
    end

    context 'User is not exists' do
      before do
        @request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new_user@mail.ru', })
        get :facebook
      end

      it "should create new user" do
        expect { get :facebook }.to_not change(User, :count)
      end

      it 'signs in the user' do
        expect(subject.current_user.email).to eq 'new_user@mail.ru'
      end

      it { should redirect_to root_path }
    end

    context 'Invalid auth' do
      before do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      end

      it "shoudn't create new user" do
        expect { get :facebook }.to_not change(User, :count)
      end

      it { should_not redirect_to root_path }
    end
  end
end
