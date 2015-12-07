class User < ActiveRecord::Base
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question#, class_name: 'Question'

  accepts_nested_attributes_for :authorizations, reject_if: :all_blank, allow_destroy: true


  def self.find_for_oauth(auth)
    unless is_correct_auth(auth)
      user = User.new
      user.errors.add(:base, 'Incorrect oauth data')
      return user
    end

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    return User.new unless auth.info.email

    user = User.where(email: auth.info.email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: auth.info.email,
                      password: password,
                      password_confirmation: password)

      user.skip_confirmation!
      user.save!
    end

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  private

  def self.is_correct_auth(auth)
    auth.instance_of?(OmniAuth::AuthHash) && auth.valid?
  end
end
