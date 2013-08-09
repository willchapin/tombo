class User < ActiveRecord::Base
  attr_accessible :email, :name, :bio, :password, :password_confirmation

  before_save { email.downcase! }
  before_save :create_remember_token 
  validates :name,  presence: true, length: { maximum: 30 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6, maximum: 20}
  validates :password_confirmation, presence: true

  after_validation { errors.delete(:password_digest) }
  has_secure_password

  has_many :tracks, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def feed
    Track.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end




  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
