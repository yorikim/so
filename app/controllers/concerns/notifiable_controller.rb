module NotifiableController
  extend ActiveSupport::Concern

  def notify_followers
    @question.followers.find_each do |follower|
      NotifyMailer.notify_followers(follower).deliver_later
    end
  end
end