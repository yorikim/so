class NotifyFollowerJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.followers.find_each do |follower|
      NotifyMailer.notify_follower(follower).deliver_later
    end
  end
end
