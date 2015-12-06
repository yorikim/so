class NotifyMailer < ApplicationMailer
  def notify_author(user)
    mail to: user.email
  end

  def notify_followers(user)
    mail to: user.email
  end
end
