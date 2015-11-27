class Users::RegistrationsController < Devise::RegistrationsController
  before_action :load_authorization_params, only: [:require_email]

  def require_email
    respond_with(@user = User.new)
  end

  def submit_email
    password = Devise.friendly_token[0, 20]
    @user = User.create!(user_params.merge(password: password, password_confirmation: password))

    redirect_to new_user_session_path
    # sign_in(@user)
  end


  private

  def load_authorization_params
    @authorization_params = {
        provider: session['devise.omniauth_provider'],
        uid: session['devise.omniauth_uid'],
    }
  end

  def user_params
    params.require(:user).permit(:email,
                                 authorizations_attributes: [:id, :provider, :uid]
    )
  end

end
