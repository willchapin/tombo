class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  before_save { email.downcase! }
  before_save :create_remember_token 
  validates :name,  presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6, maximum: 20}

  after_validation { errors.delete(:password_digest) }
  has_secure_password


  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
