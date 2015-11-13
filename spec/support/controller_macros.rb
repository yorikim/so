module ControllerMacros
  def login_user(user_type = :user)
    before do
      @user = create(user_type)
      @request.env['devise.mapping'] = Devise.mappings[user_type]
      sign_in @user
    end
  end
end