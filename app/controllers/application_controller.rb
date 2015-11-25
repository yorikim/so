require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_permissions!(obj)
    unless current_user.author_of?(obj)
      message = 'You have no authority for this action'
      respond_to do |format|
        format.html { redirect_to questions_path, notice: message }
        format.js do
          obj.errors.add(:user, message)
          render
        end
      end
    end
  end
end
