class User < ActiveRecord::Base
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations

  def author_of?(obj)
    id == obj.user_id
  end

  def self.find_for_oauth(auth)
    return User.new unless is_correct_auth(auth)

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.email
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.is_correct_auth(auth)
    auth.instance_of?(OmniAuth::AuthHash) && auth.valid?
  end
end
