module ApplicationHelper
  def is_current_user_author_of?(obj)
    current_user != nil && current_user.author_of?(obj)
  end
end
