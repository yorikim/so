class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.created_yesterday
    mail to: user.email
  end
end
