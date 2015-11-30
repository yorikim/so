require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :controller do
  describe "check access token" do
    Api::V1::ProfilesController.action_methods.each do |action|
      context "for #{action}" do
        context ' unathorized ' do
          it ' returns 401 status if there is no access_token ' do
            get action, format: :json
            should respond_with 401
          end

          it ' returns 401 status if access_token is invalid ' do
            get action, format: :json, access_token: ' 1234 '
            should respond_with 401
          end
        end

        context ' authorized ' do
          let(:me) { create(:user) }
          let(:access_token) { create(:access_token, resource_owner_id: me.id) }

          it ' returns success code ' do
            get action, format: :json, access_token: access_token.token
            expect(response).to be_success
          end
        end
      end
    end
  end

  describe ' GET /me ' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before { get :me, format: :json, access_token: access_token.token }

    %w(id email created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  describe ' GET /index ' do
    let(:me) { create(:user) }
    let!(:other_users) { create_list(:user, 5) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before { get :index, format: :json, access_token: access_token.token }

    it 'returns other users ' do
      expect(response.body).to be_json_eql(other_users.to_json)
    end

    it 'not returns me' do
      expect(response.body).to_not include_json(me.to_json)
    end

    %w(id email created_at updated_at).each do |attr|
      it "contains #{attr}" do
        json = JSON.parse(response.body)

        other_users.each do |user|
          json_user = json.find { |u| u if u['id'] == user.id }.to_json
          expect(json_user).to be_json_eql(user.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        json = JSON.parse(response.body)

        json.each do |user|
          expect(user.to_json).to_not have_json_path(attr)
        end
      end
    end
  end
end