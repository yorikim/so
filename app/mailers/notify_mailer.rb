class NotifyMailer < ApplicationMailer
  def notify_author(user)
    mail to: user.email
  end

  def notify_follower(user)
    mail to: user.email
  end
end
