require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :controller do
  include Devise::TestHelpers

  def do_request_me(options = {})
    get :me, {format: :json}.merge(options)
  end

  def do_request_index(options = {})
    get :index, {format: :json}.merge(options)
  end

  it_behaves_like 'API Authenticable controller'


  describe ' GET /index ', :lurker do
    let(:me) { create(:user) }
    let!(:other_users) { create_list(:user, 5) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before { get :index, format: :json, access_token: access_token.token }

    it 'returns other users ' do
      expect(response.body).to be_json_eql(other_users.to_json).at_path("profiles")
    end
  end
end