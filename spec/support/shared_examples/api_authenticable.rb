shared_examples "API Authenticable" do |request, action, options = {}|
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  self.instance_methods.grep(/do_request_/).each do |method|
    describe "check access token for ##{method.to_s.split('_').last}" do
      context ' unathorized ' do
        it ' returns 401 status if there is no access_token ' do
          self.send(method)
          should respond_with 401
        end

        it ' returns 401 status if access_token is invalid ' do
          self.send(method, access_token: '1234')
          should respond_with 401
        end
      end

      context 'authorized' do
        it 'returns success code ' do
          self.send(method, access_token: access_token.token)
          expect(response).to be_success
        end
      end
    end
  end
end