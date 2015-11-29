require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if request.format == 'text/javascript'
      flash[:error] = exception.message
      render exception.action
    else
      redirect_to root_path, alert: exception.message
    end
  end

  check_authorization unless: :devise_controller?
end