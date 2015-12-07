class NotifyFollowerJob < ActiveJob::Base
  queue_as :default

  def perform(followers)
    followers.find_each do |follower|
      NotifyMailer.notify_follower(follower).deliver_later
    end
  end
end
