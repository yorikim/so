class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  def facebook
  end

  def twitter
  end


  private

  def oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{action_name}".capitalize) if is_navigational_format?
    elsif !@user.errors.any?
      session["devise.omniauth.provider"] = request.env['omniauth.auth'].provider
      session["devise.omniauth.uid"] = request.env['omniauth.auth'].uid

      redirect_to require_email_path
    end
  end
end
