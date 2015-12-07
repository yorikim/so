module Notifiable
  extend ActiveSupport::Concern

  def notify_followers
    NotifyFollowerJob.perform_later(followers.to_a)
  end
end