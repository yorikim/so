class NotifyMailer < ApplicationMailer
  def notify_follower(user)
    mail to: user.email
  end
end
