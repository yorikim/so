require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many :authorizations }

  describe '.find_for_auth' do
    let!(:user) { create(:user) }

    let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: user.email}) }
    let!(:auth_with_new_email) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new_user@mail.ru'}) }
    let!(:auth_without_email) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    context 'auth with email' do
      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '123456')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user has not authorization' do
        context 'user already created' do
          it "dont't creates new user" do
            expect { User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it 'creates new authorization' do
            expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns the user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context 'user is not created' do
          it 'creates new user' do
            expect { User.find_for_oauth(auth_with_new_email) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_for_oauth(auth_with_new_email)).to be_a(User)
          end

          it 'fills user email' do
            user = User.find_for_oauth(auth_with_new_email)
            expect(user.email).to eq auth_with_new_email.info.email
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth_with_new_email)
            expect(user.authorizations).to_not be_empty
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth_with_new_email).authorizations.first

            expect(authorization.provider).to eq auth_with_new_email.provider
            expect(authorization.uid).to eq auth_with_new_email.uid
          end
        end
      end
    end

    context 'auth without email' do
      it 'not creates user' do
        expect { User.find_for_oauth(auth_without_email) }.to_not change(User, :count)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth_without_email)).to be_a_new(User)
      end
    end
  end
end