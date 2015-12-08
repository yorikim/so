module Notifiable
  extend ActiveSupport::Concern

  def notify_followers
    NotifyFollowerJob.perform_later(question)
  end
end