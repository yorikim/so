class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :manage, [Question, Answer, Comment], user: user
    can :manage, Attachment, attachable: {user_id: user.id}

    can :make_best, Answer, question: {user_id: user.id}

    alias_action :vote_up, :vote_down, to: :vote
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user

    alias_action :me, :index, to: :use_profile_api
    can :use_profile_api, :profile

    alias_action :show, :index, :create, to: :use_question_api
    can :use_question_api, :question

    alias_action :show, :index, :create, to: :use_answer_api
    can :use_answer_api, :answer
  end
end
